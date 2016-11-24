Imports Telerik.Web.UI


Partial Class Config_MenuConfig
    Inherits System.Web.UI.Page

    Protected Sub GridView_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles RGConfig.ItemCommand
        If e.CommandName = RadGrid.ExpandCollapseCommandName Then
            Dim item As GridDataItem = DirectCast(e.Item, GridDataItem)
            If item.Expanded = False Then
                item.ChildItem.NestedTableViews(0).Visible = True
                item.ChildItem.NestedTableViews(1).Visible = False
            End If
        ElseIf e.CommandName = "ShowQueue" Then
            Dim item As GridDataItem = DirectCast(e.Item, GridDataItem)
            If item.Expanded = False Then
                item.ChildItem.NestedTableViews(1).Visible = True
                item.ChildItem.NestedTableViews(0).Visible = False
            End If
            item.Expanded = Not item.Expanded
        ElseIf e.CommandName = "ShowConfig" Then
            Dim item As GridDataItem = DirectCast(e.Item, GridDataItem)
            If item.Expanded = False Then
                item.ChildItem.NestedTableViews(1).Visible = False
                item.ChildItem.NestedTableViews(0).Visible = True
            End If
            item.Expanded = Not item.Expanded
        End If

    End Sub

    Protected Sub RadGrid1_ItemCommand(sender As Object, e As GridCommandEventArgs) Handles RGThreads.ItemCommand
        If e.CommandName = "ShowLog" Then
            Dim item As GridDataItem = DirectCast(e.Item, GridDataItem)
            Dim SessionID As Long = item.GetDataKeyValue("SessionID")
            MultiPage1.SelectedIndex = 2
            'RadGrid2.MasterTableView.FilterExpression = "[SessionID]=" + SessionID.ToString()
            Dim Column As GridColumn = RGLog.Columns.FindByDataField("SessionID")
            If Column IsNot Nothing Then
                Column.CurrentFilterValue = SessionID.ToString()
                Column.CurrentFilterFunction = GridKnownFunction.EqualTo
            End If
        End If
    End Sub

    Protected Sub Refresh_Click(sender As Object, e As EventArgs)
        RGLog.Rebind()
    End Sub

    Protected Sub Refresh_Click1(sender As Object, e As EventArgs)
        RGLog.Rebind()
    End Sub

    Protected Sub ShowStoppedThreads_CheckedChanged(sender As Object, e As EventArgs)
        Dim col As GridColumn = RGThreads.Columns.FindByDataField("StateID")
        If DirectCast(sender, RadButton).Checked Then
            col.CurrentFilterValue = 900
            col.CurrentFilterFunction = GridKnownFunction.NotEqualTo
        Else
            col.CurrentFilterFunction = GridKnownFunction.NoFilter
        End If
        RGThreads.Rebind()
    End Sub

    Protected Sub RGLog_ItemDataBound(sender As Object, e As GridItemEventArgs) Handles RGLog.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem Then
            Dim Item As Telerik.Web.UI.GridDataItem = e.Item
            Dim lb As LinkButton = Item("Stack").FindControl("linkButton")
            Dim l As Label = Item("Stack").FindControl("label")
            lb.Visible = DirectCast(e.Item.DataItem, DataRowView).Item("Stack").ToString().Length > 0
            l.Visible = Not lb.Visible
        End If
    End Sub


    Protected Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        rgHNASFileScanQueueProgress.DataBind()
    End Sub
End Class
