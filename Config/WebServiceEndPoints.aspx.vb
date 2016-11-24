
Partial Class Config_WebServiceEndPoints
    Inherits System.Web.UI.Page

    Protected Sub WebServiceEndPointsView_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles WebServiceEndPointsView.ItemCommand
        If e.CommandName = "RefreshServices" Then
            Dim headeritem As Telerik.Web.UI.GridHeaderItem = DirectCast(e.Item, Telerik.Web.UI.GridHeaderItem)
            'headeritem.OwnerTableView.DataKeyValues("")
            Dim EndPoint As IPPlanWebServiceEndPoint = New IPPlanWebServiceEndPoint(e.Item.OwnerTableView.ParentItem.GetDataKeyValue("EndPointID"), e.Item.OwnerTableView.ParentItem.GetDataKeyValue("EnvironmentID"), "_refresh")
            headeritem.OwnerTableView.Rebind()
        End If
        If e.CommandName = "AddServer" Then
            Dim item As Telerik.Web.UI.GridDataItem = e.Item
            item.Expanded = True
            item.ChildItem.NestedTableViews(0).IsItemInserted = True
            item.ChildItem.NestedTableViews(0).Rebind()
        End If
    End Sub
End Class
