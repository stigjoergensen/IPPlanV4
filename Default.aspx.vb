
Partial Class _Default
    Inherits System.Web.UI.Page

    Private Function GetMenuData(ExternalReference As String) As DataTable
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand("SELECT * FROM IPPlanV4Menu WHERE ExternalReference=@ExternalReference", connection)
        selectCommand.Parameters.AddWithValue("ExternalReference", ExternalReference)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        connection.Close()
        connection.Dispose()
        Return products
    End Function

    Private Sub OpenClientWindow(originalUrl As String)
        If originalUrl.ToLower().StartsWith("/page/") Then
            Dim Pagename As String = originalUrl.Substring(6, IIf(originalUrl.IndexOf("?") > 0, originalUrl.IndexOf("?") - 6, originalUrl.Length - 6)) ' remove /page/ and ? parameters
            Dim args As Dictionary(Of String, String)
            If originalUrl.IndexOf("?") > 0 Then
                args = originalUrl.Substring(originalUrl.IndexOf("?") + 1).ToString().Split("&").Select(Function(kvp) kvp.Split("=")).ToDictionary(Function(kvp) kvp(0), Function(kvp) kvp(1))
            Else
                args = New Dictionary(Of String, String)
            End If
            Dim Menues As DataTable = GetMenuData(Pagename)
            If Menues.Rows.Count = 1 Then
                Dim NewUrl As String = Menues.Rows.Item(0)("MenuFunction").ToString()
                Dim SecurityGroups As String() = Menues.Rows.Item(0)("SecurityGroups").ToString().Split(",")
                Dim accessdenied As Boolean = True
                For Each Group As String In SecurityGroups
                    accessdenied = accessdenied Or Page.User.IsInRole(Group)
                Next
                If accessdenied Then
                    Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "OpenErrorWindow", "setTimeout(function() {OpenNewDialog('/window/errorpage.aspx?PageName=" + Pagename + "&Text=""Access not allowed""','Error 404',300,100);},1000);", True)
                Else
                    For Each Pair In args
                        NewUrl = NewUrl.Replace("$" + Pair.Key, Pair.Value)
                    Next
                    'If args.Length > 0 Then NewUrl = NewUrl + "?" + args
                    Dim Javascriptfunction As String = MenuProvider.GetMenuFunction(Menues.Rows.Item(0)("MenuFunctionID"), NewUrl)
                    Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "OpenPageWindow", "setTimeout(function() {" + Javascriptfunction + "},1000);", True)
                End If
            Else
                Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "OpenErrorWindow", "setTimeout(function() {OpenNewDialog('/window/errorpage.aspx?PageName=" + Pagename + "&Text=""Returned other than 1 result""','Error 404',300,100);},1000);", True)
            End If
        ElseIf originalUrl.ToLower().StartsWith("/window/errorpage.aspx") Then
            UI.ScriptManager.RegisterStartupScript(Me, [GetType](), "OpenErrorWindow", "setTimeout(function() { OpenNewDialog('" + originalUrl + "','Error 404',300,100);},1000);", True)
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Username.Text = User.Identity.Name.Substring(User.Identity.Name.IndexOf("\") + 1)
        Hostname.Focus()
        If Request.Form("redirect") <> "" Then
            OpenClientWindow(Request.Form("Redirect"))
        End If

    End Sub


    Protected Sub Page_PreRenderComplete(sender As Object, e As EventArgs) Handles Me.PreRenderComplete
    End Sub
End Class
