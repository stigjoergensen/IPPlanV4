Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class AppSearch
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function GetApplicationList(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As String()
        Dim res As List(Of String) = New List(Of String)
        Dim dbconn As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        dbconn.Open()
        Dim sqlcmd As SqlCommand = New SqlCommand("SELECT Name FROM EAP1ApplicationView WHERE (((CAST(ID AS VARCHAR) = @Search AND ISNUMERIC(@Search)=1) OR (Name LIKE '%'+@Search+'%' AND ISNUMERIC(@Search)=0)) AND (HostLinkable=@Hostlinkable OR @HostLinkable=-1))", dbconn)
        sqlcmd.Parameters.AddWithValue("HostLinkable", 1)
        sqlcmd.Parameters.AddWithValue("Search", prefixText)
        sqlcmd.CommandType = CommandType.Text
        Dim dr As SqlDataReader = sqlcmd.ExecuteReader()
        While dr.Read
            res.Add(dr("Name").ToString())
        End While
        dbconn.Close()
        dbconn.Dispose()
        Return res.ToArray()
    End Function


End Class