Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Web.Script.Serialization
Imports System.Web.Script.Services

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class TimeInfo
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function HelloWorld() As String
        Return "Hello World"
    End Function

    <WebMethod()> _
    Public Function GetTimeInfo() As Telerik.Web.UI.RadRotatorItemData()
        Dim result As List(Of Telerik.Web.UI.RadRotatorItemData) = New List(Of Telerik.Web.UI.RadRotatorItemData)
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand("SELECT * FROM TimeInfo WHERE Visible=1 ORDER BY PlaceName", connection)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        For Each row As System.Data.DataRow In products.Rows
            Dim obj As Telerik.Web.UI.RadRotatorItemData = New Telerik.Web.UI.RadRotatorItemData
            'obj.Html = String.Format("<script type='text/javascript'>GetRotatorTime({0},'{1}',{2},{3},{4});</script>", {row("TimeInfoID").ToString(), row("PlaceName").ToString(), row("UTCOffset").ToString(), row("DSTStartWeekNo").ToString(), row("DSTEndWeekNo").ToString()})
            obj.Html = String.Format("GetRotatorTime({0},'{1}',{2},{3},{4});", {row("TimeInfoID").ToString(), row("PlaceName").ToString(), row("UTCOffset").ToString(), row("DSTStartWeekNo").ToString(), row("DSTEndWeekNo").ToString()})
            result.Add(obj)
        Next
        connection.Close()
        connection.Dispose()
        Return result.ToArray()
    End Function

    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Sub GetTimeInfoJson()
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand("SELECT * FROM TimeInfo WHERE Visible=1 ORDER BY PlaceName", connection)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
        Dim rows As New List(Of Dictionary(Of String, Object))()
        Dim row As Dictionary(Of String, Object)
        For Each dr As DataRow In products.Rows
            row = New Dictionary(Of String, Object)()
            For Each col As DataColumn In products.Columns
                row.Add(col.ColumnName, dr(col))
            Next
            rows.Add(row)
        Next
        Dim str As String = serializer.Serialize(rows)
        Context.Response.Clear()
        Context.Response.ContentType = "application/json"
        Context.Response.AddHeader("content-disposition", "attachment; filename=TimeInfo.json")
        Context.Response.AddHeader("content-length", Str.Length.ToString())
        'Context.Response.Flush()
        Context.Response.Write(Str)
    End Sub



End Class