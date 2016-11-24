
Partial Class Windows_Host_Contact
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Hostname.Text = Request.QueryString("Hostname")
            EditMode.Text = Request.QueryString("Mode")
            'If EditMode.Text <> "EditHost" And EditMode.Text <> "ViewHost" Then Throw New Exception(EditMode.Text + " is not an approved Mode of operation")
        End If
    End Sub

End Class
