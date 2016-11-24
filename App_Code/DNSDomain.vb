Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class DNSDomain
    Inherits System.Web.Services.WebService

    Private Function GetDBValue(obj As Object) As Object
        If IsDBNull(obj) Then Return String.Empty Else Return obj
    End Function

    Public Class DNSDomainName
        Public DomainID As Integer
        Public DomainName As String
        Public Responsible As String
        Public DNSError As String
    End Class

    Private Function ProcessDomainNameList(List As SqlDataReader) As List(Of DNSDomainName)
        ProcessDomainNameList = New List(Of DNSDomainName)
        While List.Read()
            ProcessDomainNameList.Add(New DNSDomainName With {.DomainID = List("DomainID"), .DomainName = List("Domainname"), .Responsible = GetDBValue(List("Responsible")), .DNSError = GetDBValue(List("DNSError"))})
        End While
    End Function

    <WebMethod()> _
    Public Function GetDomainNames(AgeHours As Integer) As List(Of DNSDomainName)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM DNSDomainNames WHERE DATEDIFF(HOUR,LastCheck,GETDATE()) >= @AgeHours AND [Enabled]=1 AND DomainID > 0", Conn)
        cmd.Parameters.AddWithValue("AgeHours", AgeHours)
        GetDomainNames = ProcessDomainNameList(cmd.ExecuteReader())
        Conn.Close()
        Conn.Dispose()
    End Function

    <WebMethod()> _
    Public Function GetDomainName(DomainID As Integer) As List(Of DNSDomainName)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM DNSDomainNames WHERE DomainID = @DomainID", Conn)
        cmd.Parameters.AddWithValue("DomainID", DomainID)
        GetDomainName = ProcessDomainNameList(cmd.ExecuteReader())
        Conn.Close()
        Conn.Dispose()
    End Function

    <WebMethod()> _
    Public Sub ResetDNSServer(DomainID As Integer)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("DELETE FROM DNSDomainServers WHERE DomainID=@DomainID", Conn)
        cmd.Parameters.AddWithValue("DomainID", DomainID)
        cmd.ExecuteNonQuery()
        cmd.CommandText = "UPDATE DNSDomainNames SET LastCheck=GETDATE() WHERE DomainID=@DomainID"
        cmd.ExecuteNonQuery()
        Conn.Close()
        Conn.Dispose()
    End Sub

    <WebMethod()> _
    Public Sub InsertDNSServer(DomainID As Integer, RecordType As String, Servername As String)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("INSERT INTO DNSDomainServers(DomainID,ServerName,RecordType) VALUES(@DomainID,@ServerName,@RecordType)", Conn)
        cmd.Parameters.AddWithValue("DomainID", DomainID)
        cmd.Parameters.AddWithValue("RecordType", RecordType)
        cmd.Parameters.AddWithValue("ServerName", Servername)
        Try
            cmd.ExecuteNonQuery()
        Catch ex As Exception

        End Try
        Conn.Close()
        Conn.Dispose()
    End Sub

    <WebMethod()> _
    Public Sub UpdateDomainName(DomainID As Integer, Responsible As String)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("UPDATE DNSDomainNames SET Responsible=@Responsible, DNSError=@DNSError WHERE DomainID=@DomainID", Conn)
        cmd.Parameters.AddWithValue("DomainID", DomainID)
        cmd.Parameters.AddWithValue("Responsible", Responsible)
        cmd.Parameters.AddWithValue("DNSError", DBNull.Value)
        cmd.ExecuteNonQuery()
        cmd.CommandText = "UPDATE DNSDomainNames SET LastCheck=GETDATE() WHERE DomainID=@DomainID"
        cmd.ExecuteNonQuery()
        Conn.Close()
        Conn.Dispose()
    End Sub

    <WebMethod()> _
    Public Sub UpdateDomainNameError(DomainID As Integer, DNSError As String)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("UPDATE DNSDomainNames SET DNSError=@DNSError WHERE DomainID=@DomainID", Conn)
        cmd.Parameters.AddWithValue("DomainID", DomainID)
        cmd.Parameters.AddWithValue("DNSError", DNSError)
        cmd.ExecuteNonQuery()
        cmd.CommandText = "UPDATE DNSDomainNames SET LastCheck=GETDATE() WHERE DomainID=@DomainID"
        cmd.ExecuteNonQuery()
        Conn.Close()
        Conn.Dispose()
    End Sub

End Class