
Partial Class Config_EditPowershell
    Inherits System.Web.UI.Page


    Protected Sub RGpowershell_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles RGpowershell.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem AndAlso e.Item.OwnerTableView.Name = "Arguments" Then
            Dim item As Telerik.Web.UI.GridDataItem = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)
            If TypeOf item.DataItem Is DataRowView AndAlso DirectCast(item.DataItem, System.Data.DataRowView).Item("Locked").ToString() = "1" Then
                item("EditCommand").Enabled = False
                item("DeleteCommand").Enabled = False
                item("FieldName").Enabled = False
                item("ParamName").Enabled = False
                item("DataTypeID").Enabled = False
                item("Mandatory").Enabled = False
                item("Values").Enabled = False
                item("Comment").Enabled = False
            End If
        End If
        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem AndAlso e.Item.OwnerTableView.Name = "PowershellScrips" Then
            Dim item As Telerik.Web.UI.GridDataItem = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)
            If TypeOf item.DataItem Is DataRowView AndAlso DirectCast(item.DataItem, System.Data.DataRowView).Item("Locked").ToString() = "1" Then
                item("EditCommand").Enabled = False
                item("DeleteCommand").Enabled = False
                item("Title").Enabled = False
                item("Hostname").Enabled = False
                item("Location").Enabled = False
                item("ScriptName").Enabled = False
                item("APIName").Enabled = False
                item("MenuLocationID").Enabled = False
                item("Enabled").Enabled = False
                item("Username").Enabled = False
                item("Password").Enabled = False
                item("ExecModeID").Enabled = False
            End If
        End If

    End Sub
End Class
