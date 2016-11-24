
Partial Class Windows_IPPlanSearch
    Inherits System.Web.UI.Page

    Private Sub SetText(Obj As Telerik.Web.UI.RadComboBox, QueryStringName As String)
        If Request.QueryString(QueryStringName) <> "" Then
            Obj.Text = Request.QueryString(QueryStringName)
        End If
    End Sub

    Private Sub SetText(obj As Telerik.Web.UI.RadDropDownList, QueryStringName As String)
        If Request.QueryString(QueryStringName) <> "" Then
            obj.SelectedValue = Request.QueryString(QueryStringName)
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            SetText(Hostname, "Hostname")
            SetText(Func, "function")
            SetText(Environment, "EnvironmentID")
            SetText(ApplicationID, "Application")
            SetText(IPAddress, "IPAddress")
            SetText(MACAddress, "MACAddress")
            SetText(AssignedIP, "AssignedIP")
            SetText(ManagementIP, "ManagementIP")
            SetText(Country, "CountryID")
            SetText(SerialNumber, "SerialNumber")
            SetText(Asset, "Asset")
            SetText(OSName, "OSName")
            SetText(PatchApply, "DateID")
            SetText(Certificate, "CertificateName")
            SetText(Terminated, "Terminated")
            If Request.QueryString("Execute") = "1" Then
                ClientScript.RegisterStartupScript(Me.GetType(), "Perform Seach Click", "<script type=""text/javascript"">PerformSearch(null,null);</script>")
            End If
        End If
    End Sub
End Class
