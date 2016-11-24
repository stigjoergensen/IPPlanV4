Imports System.Management.Automation.Runspaces
Imports System.Collections.ObjectModel
'Imports System.Net

' Remeber to enable delegation:
' Enable-WSManCredSSP -Role "Client" -DelegateComputer [target computer]
' Enable-WSManCredSSP -Role "Server"
' in active directory set "Trust computer for delegation" for the server

Public Class IPPlanHost
    Public Property ConfirmText As String
    Public Property ConfirmIcon As String = "?" ' other values are 'X,!"
    Public Property ConfirmButton As String = "Confirm"
    Public Property ResultText As String = ""
    Public Property ResultCode As Integer = 0
End Class

Public Class IPPlanPowershell
    Private strings As StringBuilder = Nothing
    Private _execString As String = ""
    Private _IPPlanHost As IPPlanHost
    Private PSResultObjects As Collection(Of System.Management.Automation.PSObject)
    Private Remote As Runspace = Nothing
    Private PS As System.Management.Automation.PowerShell


    Public Enum PSResultCode
        ok = 0
        Failed = 1
        ConnectProblem = 2
    End Enum
    Private _result As PSResultCode

    Public ReadOnly Property Host As IPPlanHost
        Get
            Return _IPPlanHost
        End Get
    End Property

    Public ReadOnly Property Result As PSResultCode
        Get
            Return _result
        End Get
    End Property

    Public ReadOnly Property HTMLResult As String
        Get
            Return System.Net.WebUtility.HtmlEncode(strings.ToString())
        End Get
    End Property

    Public ReadOnly Property PSResult As Collection(Of System.Management.Automation.PSObject)
        Get
            Return PSResultObjects
        End Get
    End Property

    Public ReadOnly Property ExecuteString As String
        Get
            Return _execString
        End Get
    End Property

    Public ReadOnly Property RunSpace As Runspace
        Get
            Return Remote
        End Get
    End Property

    Public ReadOnly Property PowerShell As System.Management.Automation.PowerShell
        Get
            Return PS
        End Get
    End Property

    Public Sub New(Script As String, Hostname As String, Username As String, Password As String, asText As Boolean, Optional Port As Integer = 5985)
        Execute(Script, Hostname, Username, Password, asText, Port)
    End Sub

    Public Sub New(APIname As String, Caller As String, Params As Dictionary(Of String, String))
        If Params Is Nothing Then Params = New Dictionary(Of String, String)
        Params.Add("Caller", Caller)
        Params.Add("ClientIP", System.Web.HttpContext.Current.Request.UserHostAddress)

        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM Powershell WHERE APIName=@APIName", Conn)
        cmd.Parameters.AddWithValue("APIName", APIname)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read() Then
            Params.Add("AssetPSID", reader("PSID").ToString)
            Dim parmstr As String = ""
            For Each Key As String In Params.Keys
                If Params(Key).Length > 0 Then
                    parmstr = String.Format("{0} -{1} '{2}'", parmstr, Key, Params(Key))
                End If
            Next
            Select Case reader("ExecModeID").ToString()
                Case "2"
                    parmstr = parmstr + " -verbose"
                Case "3"
                    parmstr = parmstr + " -debug"
                Case "4"
                    parmstr = parmstr + " -verbose -debug"
            End Select

            Execute(String.Format(". {0}\{1} {2}", reader("Location").ToString(), reader("ScriptName").ToString(), parmstr), reader("Hostname").ToString(), reader("Username").ToString(), reader("Password").ToString(), False)
        End If
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Sub

    Private Sub Execute(Script As String, Hostname As String, Username As String, Password As String, asText As Boolean, Optional Port As Integer = 5985)
        _IPPlanHost = New IPPlanHost()
        _result = PSResultCode.ok
        strings = New StringBuilder()

        If asText Then
            _execString = String.Format("//{0}:*******@{1}:{2} {3}|out-string", Username, Hostname, Port, Script)
        Else
            _execString = String.Format("//{0}:*******@{1}:{2} {3}", Username, Hostname, Port, Script)
        End If
        Dim shell As String = "http://schemas.microsoft.com/powershell/Microsoft.PowerShell"
        Dim target = New Uri(String.Format("http://{0}:{1}/wsman", Hostname, Port))
        Dim SecureString = New System.Security.SecureString()
        For Each letter As Char In Password.ToCharArray()
            SecureString.AppendChar(letter)
        Next
        SecureString.MakeReadOnly()

        Dim cred As System.Management.Automation.PSCredential = New System.Management.Automation.PSCredential(Username, SecureString)
        Dim ConnInfo = New WSManConnectionInfo(target, shell, cred)
        Try

            PS = System.Management.Automation.PowerShell.Create()
            PS.Runspace = RunspaceFactory.CreateRunspace(ConnInfo)
            Dim Pipeline As Pipeline = PS.Runspace.CreatePipeline()
            PS.Runspace.Open()
            PS.Commands.AddScript(Script)

            PS.Runspace.SessionStateProxy.SetVariable("IPPlanHost", _IPPlanHost)
            Try
                If asText Then
                    PS.Commands.AddCommand("out-string")
                    PSResultObjects = PS.Invoke()
                    For Each obj As System.Management.Automation.PSObject In PSResultObjects
                        strings.AppendLine(obj.ToString())
                    Next
                Else
                    'PS.Invoke(Nothing, PSResultObjects)
                    PSResultObjects = PS.Invoke()
                    Dim a = PS.Runspace.SessionStateProxy.GetVariable("IPPlanHost")
                    _IPPlanHost.ConfirmText = DirectCast(a, System.Management.Automation.PSObject).Members("ConfirmText").Value
                    _IPPlanHost.ConfirmIcon = DirectCast(a, System.Management.Automation.PSObject).Members("ConfirmIcon").Value
                    _IPPlanHost.ConfirmButton = DirectCast(a, System.Management.Automation.PSObject).Members("ConfirmButton").Value
                    _IPPlanHost.ResultCode = DirectCast(a, System.Management.Automation.PSObject).Members("ResultCode").Value
                    _IPPlanHost.ResultText = DirectCast(a, System.Management.Automation.PSObject).Members("ResultText").Value
                End If
            Catch ex As Exception
                strings.AppendLine("Execute Failed:")
                strings.AppendLine(ex.Message)
                strings.AppendLine(ex.StackTrace.ToString())
                _result = PSResultCode.Failed
            End Try
            If PSResultObjects.Count = 0 AndAlso strings.Length > 0 AndAlso PS.HadErrors AndAlso _IPPlanHost.ConfirmText IsNot Nothing AndAlso _IPPlanHost.ConfirmText.Length = 0 Then
                Dim str As String = ""
                For Each Err As System.Management.Automation.ErrorRecord In PS.Streams.Error
                    str = String.Format("{0}{1}", str, vbCrLf, Err.Exception.Message)
                Next
                Throw New Exception(str)
            End If
            PS.Runspace.Close()
        Catch ex As Exception
            strings.AppendLine("Connection failed:")
            strings.AppendLine(ex.Message)
            strings.AppendLine(ex.StackTrace.ToString())
            _result = PSResultCode.ConnectProblem
        End Try
    End Sub

End Class
