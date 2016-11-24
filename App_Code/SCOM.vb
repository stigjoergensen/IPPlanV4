Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class SCOM
     Inherits System.Web.Services.WebService

    Private Function GetDBValue(Value As Object) As String
        If IsDBNull(Value) Then Return Nothing Else Return Value.ToString()
    End Function


    Public Class OperationalMode
        Public ID As Integer
        Public Name As String
        Public Visible As Integer
    End Class

    Public Class Environment
        Public ID As Integer
        Public Name As String
        Public Description As String
        Public ShortName As String
        Public DefaultPatchDateID As Integer
    End Class

    Public Class ContactType
        Public ID As Integer
        Public Name As String
        Public isPatchApprover As Integer
        Public isContact As Integer
        Public HelpText As String
        Public isEditAble As Integer
        Public SortOrder As Integer
    End Class

    Public Class Contact
        Public hostname As String
        Public ContactTypeID As Integer
        Public Contact As String
    End Class

    <WebMethod()> _
    Public Function GetOperationalMode(Hostname As String) As OperationalMode
        GetOperationalMode = Nothing
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT OM.* FROM HostExtraData AS HED INNER JOIN IPPlanOperationMode AS OM ON OM.ID = HED.OperationMode WHERE Hostname = @Hostname", Conn)
        cmd.Parameters.AddWithValue("Hostname", Hostname)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read() Then
            GetOperationalMode = New OperationalMode()
            GetOperationalMode.ID = reader("ID")
            GetOperationalMode.Name = reader("OperationalMode")
            GetOperationalMode.Visible = reader("Visible")
        End If
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function

    <WebMethod()> _
    Public Function ListOperationalMode() As List(Of OperationalMode)
        ListOperationalMode = New List(Of OperationalMode)()

        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * from IPPlanOperationMode", Conn)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read()
            Dim item As OperationalMode = New OperationalMode()
            item.ID = reader("ID")
            item.Name = reader("OperationalMode")
            item.Visible = reader("Visible")
            ListOperationalMode.Add(item)
        End While
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function


    <WebMethod()> _
    Public Function GetEnvironment(Hostname As String) As Environment
        GetEnvironment = Nothing
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT E.* FROM HostExtraData AS HED INNER JOIN IPPlanEnvironment AS E ON E.EnvironmentID = HED.EnvironmentID WHERE Hostname=@Hostname", Conn)
        cmd.Parameters.AddWithValue("Hostname", Hostname)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read() Then
            GetEnvironment = New Environment()
            GetEnvironment.ID = reader("EnvironmentID")
            GetEnvironment.Name = reader("EnvironmentName")
            GetEnvironment.Description = reader("EnvironmentDescription")
            GetEnvironment.ShortName = reader("ShortName")
            GetEnvironment.DefaultPatchDateID = reader("DefaultPatchDateID")
        End If
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function

    <WebMethod()> _
    Public Function ListEnvironment() As List(Of Environment)
        ListEnvironment = New List(Of Environment)()
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM IPPlanEnvironment", Conn)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read()
            Dim item As Environment = New Environment()
            item.ID = reader("EnvironmentID")
            item.Name = reader("EnvironmentName")
            item.Description = reader("EnvironmentDescription")
            item.ShortName = reader("ShortName")
            item.DefaultPatchDateID = reader("DefaultPatchDateID")
            ListEnvironment.Add(item)
        End While
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function

    <WebMethod()> _
    Public Function ListContactType() As List(Of ContactType)
        ListContactType = New List(Of ContactType)()
        Dim item As ContactType = Nothing

        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM IPPlanContactTypes", Conn)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read()
            item = New ContactType()
            item.ID = GetDBValue(reader("ContactTypeID"))
            item.Name = GetDBValue(reader("ContactTypeName"))
            item.isPatchApprover = GetDBValue(reader("isPatchApprover"))
            item.isContact = GetDBValue(reader("isContact"))
            item.HelpText = GetDBValue(reader("HelpText"))
            item.isEditAble = GetDBValue(reader("isEditAble"))
            item.SortOrder = GetDBValue(reader("SortOrder"))
            ListContactType.Add(item)
        End While
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function

    <WebMethod()> _
    Public Function ListContact(Hostname As String) As List(Of Contact)
        ListContact = New List(Of Contact)()

        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM HostContact WHERE Hostname=@Hostname", Conn)
        cmd.Parameters.AddWithValue("Hostname", Hostname)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read()
            Dim item As Contact = New Contact()
            item.hostname = reader("Hostname")
            item.ContactTypeID = reader("ContactTypeID")
            item.Contact = reader("Contact")
            ListContact.Add(item)
        End While
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function

    <WebMethod()> _
    Public Function GetContact(Hostname As String, ContactTypeID As Integer) As Contact
        Dim item As Contact = Nothing
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM HostContact WHERE Hostname=@Hostname And ContactTypeID=@ContactTypeID", Conn)
        cmd.Parameters.AddWithValue("Hostname", Hostname)
        cmd.Parameters.AddWithValue("ContactTypeID", ContactTypeID)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read()
            item = New Contact()
            item.hostname = reader("Hostname")
            item.ContactTypeID = reader("ContactTypeID")
            item.Contact = reader("Contact")
        End While
        reader.Close()
        Conn.Close()
        Conn.Dispose()
        Return item
    End Function
End Class