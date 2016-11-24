
Partial Class Windows_IPPlan
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        username.Text = Page.User.Identity.Name.ToString()
    End Sub

    Protected Sub rgIPPlan_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgIPPlan.ItemCreated

        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem Then
            Dim dataitem As Telerik.Web.UI.GridDataItem = e.Item
            If dataitem.DataItem IsNot Nothing Then
                dataitem("Hostname").Text = dataitem.DataItem("Hostname")
                Dim kv As Dictionary(Of String, String) = New Dictionary(Of String, String)
                For Each Column As DataColumn In DirectCast(e.Item.DataItem, System.Data.DataRowView).Row.Table.Columns
                    kv(Column.Caption) = DirectCast(e.Item.DataItem, System.Data.DataRowView).Row.Item(Column).ToString()
                Next
                DirectCast(DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("HiddenData").FindControl("HiddenData"), TextBox).Text = String.Join(";", kv.ToArray())
            End If
            Dim menu As Telerik.Web.UI.RadContextMenu = e.Item.FindControl("HostMenu")
            Dim target As Telerik.Web.UI.ContextMenuElementTarget = New Telerik.Web.UI.ContextMenuElementTarget()
            target.ElementID = dataitem.ClientID
            menu.Targets.Add(target)
            menu.Items(0).Text = dataitem("Hostname").Text
            menu.Items(0).Value = "Menu:3:" + DirectCast(dataitem("HiddenData").FindControl("HiddenData"), TextBox).Text
            menu.Items(0).ToolTip = "$" + menu.Items(0).Value.Substring(7).Trim("[", "]").Replace("];[", vbCrLf + "$").Replace(",", "=")
        End If
    End Sub

End Class
