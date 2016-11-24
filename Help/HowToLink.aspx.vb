
Partial Class Help_HowToLink
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        IPPlanV4Menu.SelectParameters("SiteName").DefaultValue = Request.Url.AbsoluteUri.Substring(0, Request.Url.AbsoluteUri.Length - Request.Url.AbsolutePath.Length) + "/Page/"
    End Sub

    Protected Sub rglinks_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rglinks.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem Then
            Dim ctrl As Label = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("URL").FindControl("Parameters")
            Dim MenuFunction As String = DirectCast(e.Item.DataItem, DataRowView)("MenuFunction").ToString()
            If MenuFunction.Contains("$") Then
                Dim startX As Integer = MenuFunction.IndexOf("?")
                Dim EndX As Integer = MenuFunction.IndexOf(",", startX) - 1
                ctrl.Text = MenuFunction.Substring(startX, EndX - startX)
            Else
                ctrl.Text = ""
            End If
        End If
    End Sub
End Class
