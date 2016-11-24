Imports Microsoft.VisualBasic
Imports System.Configuration

Public Class IPPlanV4Config
    ' "MyList" is not read and maintained by this routine, its purely done by default.aspx


    Private _ConnectionString As String = ""
    Private _Username As String = ""

    Private PersonalList As Dictionary(Of String, String)
    Private IPPlanList As Dictionary(Of String, String)

    Private Enum KeyListType
        System = 0
        User = 1
    End Enum


    Public Sub New(Username As String)
        _ConnectionString = ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString
        _Username = Username
        PersonalList = New Dictionary(Of String, String)
        IPPlanList = New Dictionary(Of String, String)

        Dim Conn As SqlConnection = New SqlConnection(_ConnectionString)
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT KeyName,KeyValue FROM IPPlanV4Config WHERE Username=@Username AND GroupName = 'PersonalConfig'", Conn)
        cmd.Parameters.AddWithValue("Username", Username)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read()
            PersonalList.Add(reader("KeyName").ToString().ToUpper(), reader("KeyValue"))
        End While
        reader.Close()
        cmd.CommandText = "SELECT KeyName,KeyValue FROM IPPlanV4Config WHERE UserName='IPPlan' AND GroupName = 'PersonalConfig'"
        reader = cmd.ExecuteReader()
        While reader.Read()
            IPPlanList.Add(reader("KeyName").ToString().ToUpper(), reader("KeyValue"))
        End While
        reader.Close()
        Conn.Close()
        Conn.Dispose()
        SetValue(KeyListType.User, "LastLogon", Now.ToString("yyyy-MM-dd HH:mm:ss"))
    End Sub

    Private Function GetValue(IPPlan As KeyListType, Name As String, Def As String) As String
        Select Case IPPlan
            Case KeyListType.System
                If IPPlanList.ContainsKey(Name.ToUpper()) Then
                    Return IPPlanList(Name.ToUpper())
                Else
                    SetValue(IPPlan, Name, Def)
                    Return Def
                End If
            Case KeyListType.User
                If PersonalList.ContainsKey(Name.ToUpper()) Then
                    Return PersonalList(Name.ToUpper())
                Else
                    SetValue(IPPlan, Name, Def)
                    Return Def
                End If
            Case Else
                Return Nothing
        End Select
    End Function

    Private Sub SetValue(IPPlan As KeyListType, Name As String, Value As String)
        Dim Conn As SqlConnection = New SqlConnection(_ConnectionString)
        Conn.Open()
        Dim cmd As SqlCommand = Nothing
        Select Case IPPlan
            Case KeyListType.User
                If PersonalList.ContainsKey(Name.ToUpper()) Then
                    PersonalList(Name.ToUpper()) = Value
                    cmd = New SqlCommand("UPDATE IPPlanV4Config SET KeyValue=@Value WHERE KeyName=@Name AND GroupName='PersonalConfig' AND Username=@Username", Conn)
                Else
                    PersonalList.Add(Name.ToUpper(), Value)
                    cmd = New SqlCommand("INSERT INTO IPPlanV4Config(KeyName,KeyValue,GroupName,Username) VALUES (@Name,@Value,'PersonalConfig',@Username)", Conn)
                End If
                cmd.Parameters.AddWithValue("Username", _Username)
            Case KeyListType.System
                If IPPlanList.ContainsKey(Name.ToUpper()) Then
                    IPPlanList(Name.ToUpper()) = Value
                    cmd = New SqlCommand("UPDATE IPPlanV4Config SET KeyValue=@Value WHERE KeyName=@Name AND GroupName='PersonalConfig' AND Username=@Username", Conn)
                Else
                    IPPlanList.Add(Name.ToUpper(), Value)
                    cmd = New SqlCommand("INSERT INTO IPPlanV4Config(KeyName,KeyValue,GroupName,Username) VALUES (@Name,@Value,'PersonalConfig',@Username)", Conn)
                End If
                cmd.Parameters.AddWithValue("Username", "IPPlan")
        End Select
        If IPPlan Then
        Else
        End If
        cmd.Parameters.AddWithValue("Name", Name)
        cmd.Parameters.AddWithValue("Value", Value)
        cmd.ExecuteNonQuery()
    End Sub

    Public Property Personal(Keyname As String, Def As String) As String
        Get
            Return GetValue(KeyListType.User, Keyname, Def)
        End Get
        Set(value As String)
            SetValue(KeyListType.User, Keyname, value)
        End Set
    End Property

    Public Property IPPlan(KeyName As String, Def As String) As String
        Get
            Return GetValue(KeyListType.System, KeyName, Def)
        End Get
        Set(value As String)
            SetValue(KeyListType.System, KeyName, value)
        End Set
    End Property
End Class
