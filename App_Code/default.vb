Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class _default
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function GetFunctionList(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As String()
        Dim res As List(Of String) = New List(Of String)
        Dim dbconn As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        dbconn.Open()
        Dim sqlcmd As SqlCommand = New SqlCommand("select [function] AS [Function] from HostExtraData where [function] like '%'+@Search+'%' union select FunctionAlias as [Function] from HostExtraData where [functionAlias] like '%'+@SearchAlias+'%'", dbconn)
        sqlcmd.Parameters.AddWithValue("Search", prefixText)
        sqlcmd.Parameters.AddWithValue("SearchAlias", prefixText)
        sqlcmd.CommandType = CommandType.Text
        Dim dr As SqlDataReader = sqlcmd.ExecuteReader()
        While dr.Read
            res.Add(dr("Function").ToString())
        End While
        dbconn.Close()
        dbconn.Dispose()
        Return res.ToArray()
    End Function

End Class