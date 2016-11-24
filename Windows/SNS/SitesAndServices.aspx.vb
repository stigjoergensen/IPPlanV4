Imports Telerik.Web.UI

Partial Class SitesAndServices
    Inherits System.Web.UI.Page

    Protected Sub RGADContainer_DataBound(sender As Object, e As EventArgs) Handles RGADContainer.DataBound
    End Sub

    Protected Sub RGADContainer_DetailTableDataBind(sender As Object, e As GridDetailTableDataBindEventArgs) Handles RGADContainer.DetailTableDataBind
        e.Canceled = False
    End Sub

    Protected Sub RGADContainer_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles RGADContainer.ItemCommand
        Select Case e.CommandName
            Case "show"
                Dim item As GridDataItem = DirectCast(e.Item, GridDataItem)
                Dim ADContainer As String = item.GetDataKeyValue("ADContainer")
                For Each View As GridTableView In RGADContainer.MasterTableView.Items(e.Item.ItemIndex).ChildItem.NestedTableViews()
                    SNSLinks.SelectParameters("StatusID").DefaultValue = e.CommandArgument
                    SNSSites.SelectParameters("StatusID").DefaultValue = e.CommandArgument
                    SNSSubnets.SelectParameters("StatusID").DefaultValue = e.CommandArgument
                    If View.Name = "GTW" + ADContainer Then
                        e.Item.Expanded = True
                        View.Visible = True
                        View.DataSourceID = "SNS" + ADContainer
                        View.DataBind()
                    Else
                        View.Visible = False
                        View.DataSourceID = ""
                    End If
                Next
            Case RadGrid.ExpandCollapseCommandName
                Dim item As GridDataItem = DirectCast(e.Item, GridDataItem)
                Dim ADContainer As String = item.GetDataKeyValue("ADContainer")
                For Each View As GridTableView In RGADContainer.MasterTableView.Items(e.Item.ItemIndex).ChildItem.NestedTableViews()
                    If View.Name = "GTW" + ADContainer Then
                        View.Visible = Not e.Item.Expanded
                        View.DataSourceID = "SNS" + ADContainer
                        View.DataBind()
                    Else
                        View.Visible = False
                        View.DataSourceID = ""
                    End If
                Next
            Case "Execute"
                Select Case e.CommandArgument
                    Case "All"
                        If DirectCast(RGADContainer.MasterTableView.Items(0).FindControl("Action"), RadDropDownList).SelectedValue = "Process" Then ProcessSites()
                        If DirectCast(RGADContainer.MasterTableView.Items(1).FindControl("Action"), RadDropDownList).SelectedValue = "Process" Then ProcessSiteLinks()
                        If DirectCast(RGADContainer.MasterTableView.Items(2).FindControl("Action"), RadDropDownList).SelectedValue = "Process" Then ProcessSubnets()
                        If DirectCast(RGADContainer.MasterTableView.Items(0).FindControl("Action"), RadDropDownList).SelectedValue = "Delete" Then SNSSites.Insert() ' not insert but delete all
                        If DirectCast(RGADContainer.MasterTableView.Items(1).FindControl("Action"), RadDropDownList).SelectedValue = "Delete" Then SNSLinks.Insert() ' not insert but delete all
                        If DirectCast(RGADContainer.MasterTableView.Items(2).FindControl("Action"), RadDropDownList).SelectedValue = "Delete" Then SNSSubnets.Insert() ' not insert but delete all
                    Case "Sites"
                        ProcessSites()
                    Case "Links"
                        ProcessSiteLinks()
                    Case "Subnets"
                        ProcessSubnets()
                End Select
                RGADContainer.Rebind()
        End Select
    End Sub

    Private Sub ProcessSites()
        ' Keys: Countrycode, CityCode 

        Dim View As GridTableView = RGADContainer.MasterTableView.Items(0).ChildItem.NestedTableViews()(0) ' row 0 gridtableview 0 = GTWSites
        For Each item As GridDataItem In View.Items
            SNSSites.UpdateParameters("CountryCode").DefaultValue = item.GetDataKeyValue("CountryCode")
            SNSSites.UpdateParameters("CityCode").DefaultValue = item.GetDataKeyValue("CityCode")
            Select Case DirectCast(item.FindControl("action"), RadDropDownList).SelectedValue
                Case "Approve"
                    SNSSites.UpdateParameters("StatusID").DefaultValue = 500
                    SNSSites.Update()
                Case "Reject"
                    SNSSites.UpdateParameters("StatusID").DefaultValue = 900
                    SNSSites.Update()
                Case "Skip"
                Case "Delete"
                    SNSSites.Delete()
            End Select
        Next
    End Sub

    Private Sub ProcessSiteLinks()
        Dim View As GridTableView = RGADContainer.MasterTableView.Items(1).ChildItem.NestedTableViews()(1) ' row 1 gridtableview 1 = GTWSiteLinks
        For Each item As GridDataItem In View.Items
            SNSLinks.UpdateParameters("CountryCode").DefaultValue = item.GetDataKeyValue("CountryCode")
            SNSLinks.UpdateParameters("CityCode").DefaultValue = item.GetDataKeyValue("CityCode")
            Select Case DirectCast(item.FindControl("action"), RadDropDownList).SelectedValue
                Case "Approve"
                    SNSLinks.UpdateParameters("StatusID").DefaultValue = 500
                    SNSLinks.Update()
                Case "Reject"
                    SNSLinks.UpdateParameters("StatusID").DefaultValue = 900
                    SNSLinks.Update()
                Case "Skip"
                Case "Delete"
                    SNSLinks.Delete()
            End Select
        Next
    End Sub

    Private Sub ProcessSubnets()
        Dim View As GridTableView = RGADContainer.MasterTableView.Items(2).ChildItem.NestedTableViews()(2) ' row 2 gridtableview 2 = GTWSubnets
        For Each item As GridDataItem In View.Items
            SNSSubnets.UpdateParameters("Subnet").DefaultValue = item.GetDataKeyValue("Subnet")
            SNSSubnets.UpdateParameters("CIDR").DefaultValue = item.GetDataKeyValue("CIDR")
            Select Case DirectCast(item.FindControl("action"), RadDropDownList).SelectedValue
                Case "Approve"
                    SNSSubnets.UpdateParameters("StatusID").DefaultValue = 500
                    SNSSubnets.Update()
                Case "Reject"
                    SNSSubnets.UpdateParameters("StatusID").DefaultValue = 900
                    SNSSubnets.Update()
                Case "Skip"
                Case "Delete"
                    SNSSubnets.Delete()
            End Select
        Next
    End Sub

    Protected Sub RGADContainer_ItemDataBound(sender As Object, e As GridItemEventArgs) Handles RGADContainer.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridFooterItem Then
            Dim col = RGADContainer.MasterTableView.GetColumn("execute").OrderIndex
            For Each cell As TableCell In e.Item.Cells
                cell.Visible = False
            Next
            e.Item.Cells(0).Visible = True
            e.Item.Cells(col).Visible = True
            e.Item.Cells(col).ColumnSpan = e.Item.Cells.Count - col
        End If
    End Sub

    Protected Sub RGADContainer_PreRender(sender As Object, e As EventArgs) Handles RGADContainer.PreRender
        Dim footeritem As Telerik.Web.UI.GridFooterItem = RGADContainer.MasterTableView.GetItems(Telerik.Web.UI.GridItemType.Footer)(0)
        Dim label As Label = footeritem.FindControl("rowcount")
        Dim count As Integer = 0

        count = count + RGADContainer.MasterTableView.Items(0).ChildItem.NestedTableViews(0).Items.Count
        count = count + RGADContainer.MasterTableView.Items(1).ChildItem.NestedTableViews(1).Items.Count
        count = count + RGADContainer.MasterTableView.Items(2).ChildItem.NestedTableViews(2).Items.Count
        label.Text = Format("({0})", count)
    End Sub
End Class
