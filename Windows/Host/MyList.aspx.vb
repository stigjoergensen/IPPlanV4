
Partial Class Windows_Host_MyList
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        If Not IsPostBack Then
            Hostname.Text = Request.QueryString("Hostname")            
            If Request.QueryString("Mode").ToLower() = "addhost" Then
                AddHost.Visible = True
                RemoveHost.Visible = False
                MyHostList.InsertParameters("Username").DefaultValue = Page.User.Identity.Name
                MyHostList.Insert()
            Else
                AddHost.Visible = False
                RemoveHost.Visible = True
                MyHostList.DeleteParameters("Username").DefaultValue = Page.User.Identity.Name
                MyHostList.Delete()
            End If
        End If
    End Sub
End Class
