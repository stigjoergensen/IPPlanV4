
Partial Class Windows_ErrorPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        pagename.Text = Request.QueryString("Pagename")
    End Sub
End Class
