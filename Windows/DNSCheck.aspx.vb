
Partial Class Windows_DNSCheck
    Inherits System.Web.UI.Page

    Protected Sub DomainStateFilter_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.DropDownListEventArgs)
        'DNSDomainNamesView.MasterTableView.FilterExpression()
    End Sub

    Private ExportToPDF As Boolean = False

    Private Sub StorageReportExportExcel()
        DNSDomainNamesView.MasterTableView.GetColumn("ExpandColumn").Visible = False
        DNSDomainNamesView.ExportSettings.Excel.Format = Telerik.Web.UI.GridExcelExportFormat.Xlsx
        DNSDomainNamesView.ExportSettings.IgnorePaging = True
        DNSDomainNamesView.ExportSettings.ExportOnlyData = True
        DNSDomainNamesView.ExportSettings.OpenInNewWindow = True
        DNSDomainNamesView.ExportSettings.FileName = String.Format("DNSReport_{0:yyyyMMdd}", Now())
        DNSDomainNamesView.MasterTableView.ExportToExcel()
    End Sub

    Private Sub StorageReportExportPDF()
        DNSDomainNamesView.ExportSettings.Pdf.Subject = String.Format("DNS report {0:yyyyMMdd}", Now())
        DNSDomainNamesView.ExportSettings.Pdf.PaperSize = Telerik.Web.UI.GridPaperSize.A4
        Dim t = DNSDomainNamesView.ExportSettings.Pdf.PageWidth
        DNSDomainNamesView.ExportSettings.Pdf.PageWidth = DNSDomainNamesView.ExportSettings.Pdf.PageHeight
        DNSDomainNamesView.ExportSettings.Pdf.PageHeight = t
        DNSDomainNamesView.ExportSettings.Pdf.PageLeftMargin = 0
        DNSDomainNamesView.ExportSettings.Pdf.PageRightMargin = 0
        DNSDomainNamesView.ExportSettings.Pdf.AllowModify = False
        DNSDomainNamesView.ExportSettings.Pdf.AllowAdd = False
        DNSDomainNamesView.ExportSettings.UseItemStyles = True

        DNSDomainNamesView.Rebind()
        DNSDomainNamesView.MasterTableView.ExportToPdf()


    End Sub

    Private Sub RefreshDomainCheck(DomainID As Integer)
        PowershellResult.Text = ""
        Dim PS As IPPlanPowershell = New IPPlanPowershell("DNSCheck", Page.User.Identity.Name, Nothing)
        Select Case PS.Result
            Case IPPlanPowershell.PSResultCode.ConnectProblem
                PowershellResult.Text = PS.HTMLResult
            Case IPPlanPowershell.PSResultCode.Failed

            Case IPPlanPowershell.PSResultCode.ok
                PowershellResult.Text = "Started to get data for each domain, will finish in 10 min or so"
        End Select
    End Sub

    Protected Sub DNSDomainNamesView_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles DNSDomainNamesView.ItemCommand
        Select Case e.CommandName
            Case "Export"
                Select Case e.CommandArgument
                    Case "Excel"
                        StorageReportExportExcel()
                    Case "PDF"
                        ExportToPDF = True
                        StorageReportExportPDF()
                End Select
            Case "DomainRefresh"
                RefreshDomainCheck(e.CommandArgument)
            Case "Approve"
                DNSDomainServers.InsertParameters("DomainID").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("DomainID").Text
                DNSDomainServers.InsertParameters("ServerName").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("ServerName").Text
                DNSDomainServers.InsertParameters("ServerType").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("RecordType").Text
                DNSDomainServers.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
                DNSDomainServers.Insert()
                DirectCast(e.Item, Telerik.Web.UI.GridDataItem).OwnerTableView.Rebind()
            Case "Revoke"
                DNSDomainServers.DeleteParameters("DomainID").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("DomainID").Text
                DNSDomainServers.DeleteParameters("ServerName").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("ServerName").Text
                DNSDomainServers.DeleteParameters("ServerType").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("RecordType").Text
                DNSDomainServers.Delete()
                DirectCast(e.Item, Telerik.Web.UI.GridDataItem).OwnerTableView.Rebind()
            Case "Promote"
                DNSDomainServers.UpdateParameters("DomainID").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("DomainID").Text
                DNSDomainServers.UpdateParameters("ServerName").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("ServerName").Text
                DNSDomainServers.UpdateParameters("ServerType").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("RecordType").Text
                DNSDomainServers.Update()
                DirectCast(e.Item, Telerik.Web.UI.GridDataItem).OwnerTableView.Rebind()
            Case Telerik.Web.UI.RadGrid.PerformInsertCommandName ' insert of approved servers
                DNSApprovedServers.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
            Case Telerik.Web.UI.RadGrid.UpdateEditedCommandName ' Update of approved servers
                DNSApprovedServers.UpdateParameters("DomainID").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem).GetDataKeyValue("DomainID")
                DNSApprovedServers.UpdateParameters("ServerType").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem).GetDataKeyValue("ServerType")
                DNSApprovedServers.UpdateParameters("Servername").DefaultValue = DirectCast(DirectCast(e.Item, Telerik.Web.UI.GridDataItem)("ServerName").Controls.Item(0), System.Web.UI.WebControls.TextBox).Text
                DNSApprovedServers.UpdateParameters("Orgservername").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem).GetDataKeyValue("ServerName")
                DNSApprovedServers.Update()
            Case "AddDomains"
                PanelDNSAdd.Visible = True
                PanelDNSList.Visible = False
                AddDNSDomains.Visible = True
                CloseAddDNSDomains.Visible = False
            Case "Enable"
                DNSDomainNames.UpdateParameters("DomainID").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem).GetDataKeyValue("DomainID")
                DNSDomainNames.Update()
            Case "Disable"
                DNSDomainNames.DeleteParameters("DomainID").DefaultValue = DirectCast(e.Item, Telerik.Web.UI.GridDataItem).GetDataKeyValue("DomainID")
                DNSDomainNames.Delete()
        End Select
    End Sub



    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        DNSDomainNames.SelectParameters("Global").DefaultValue = IPPlanSecurity.isInRole(Page, "DNSCheckGlobal", "Members can edit The global Aproval list")
    End Sub

    Protected Sub DNSDomainNamesView_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles DNSDomainNamesView.ItemCreated
        If TypeOf e.Item Is Telerik.Web.UI.GridHeaderItem Then
            Dim headerItem As Telerik.Web.UI.GridHeaderItem = TryCast(e.Item, Telerik.Web.UI.GridHeaderItem)
            If headerItem.OwnerTableView.Name = "DomainList" Then
                headerItem.Cells(0).Style.Add("white-space", "nowrap;")
                headerItem.Cells(0).Style.Add("width", "64px;")

                Dim imgBtn As ImageButton
                Dim blank As Label

                'imgBtn = New ImageButton()
                'imgBtn.ID = "DomainRefresh"
                'imgBtn.CommandName = "DomainRefresh"
                'imgBtn.ImageUrl = "~/Images/refresh_16x16.png"
                'headerItem("ExpandColumn").Controls.Add(imgBtn)

                blank = New Label()
                blank.Text = "&nbsp;&nbsp;"
                headerItem("ExpandColumn").Controls.Add(blank)

                imgBtn = New ImageButton()
                imgBtn.ID = "ExportExcel"
                imgBtn.CommandName = "Export"
                imgBtn.CommandArgument = "Excel"
                imgBtn.ImageUrl = "~/Images/Excel_16x16.png"
                headerItem("ExpandColumn").Controls.Add(imgBtn)

                blank = New Label()
                blank.Text = "&nbsp;&nbsp;"
                headerItem("ExpandColumn").Controls.Add(blank)

                imgBtn = New ImageButton()
                imgBtn.ID = "AddDomains"
                imgBtn.CommandName = "AddDomains"
                imgBtn.CommandArgument = ""
                imgBtn.ImageUrl = "~/Images/add.png"
                headerItem("ExpandColumn").Controls.Add(imgBtn)
            End If
        End If
    End Sub

    Protected Sub AddDNSDomains_Click(sender As Object, e As EventArgs) Handles AddDNSDomains.Click
        Dim result As StringBuilder = New StringBuilder()
        PanelDNSAdd.Visible = True
        PanelDNSList.Visible = False
        AddDNSDomains.Visible = False
        CloseAddDNSDomains.Visible = True

        DNSDomainNames.SelectParameters("Global").DefaultValue = ""
        Dim table As DataTable = Nothing
        Dim dataview As DataView = Nothing
        For Each line As String In DNSList.Text.Split(vbCr)
            line = line.Replace("www.", "").Trim()
            If line.Contains(".") Then
                DNSDomainNames.SelectParameters("DomainName").DefaultValue = line
                dataview = DirectCast(DNSDomainNames.Select(DataSourceSelectArguments.Empty), DataView)
                table = dataview.ToTable()
                If table.Rows.Count > 0 Then
                    For Each row As DataRow In table.Rows
                        If row("Enabled") = 0 Then
                            DNSDomainNames.UpdateParameters("DomainID").DefaultValue = row("DomainID")
                            result.AppendFormat("# {0} have been enabled again{1}", line, vbCrLf)
                        Else
                            result.AppendFormat("  {0} Allready exists.{1}", line, vbCrLf)
                        End If
                    Next
                Else
                    DNSDomainNames.InsertParameters("DomainName").DefaultValue = line
                    DNSDomainNames.Insert()
                    result.AppendFormat("  {0} have been added to the list{1}", line, vbCrLf)
                End If
            Else
                result.AppendFormat("! {0} is not a valid domain name{1}", line, vbCrLf)
            End If
        Next
        DNSList.Text = result.ToString()
        DNSDomainNamesView.DataBind()
    End Sub

    Protected Sub CloseAddDNSDomains_Click(sender As Object, e As EventArgs) Handles CloseAddDNSDomains.Click
        PanelDNSAdd.Visible = False
        PanelDNSList.Visible = True
        AddDNSDomains.Visible = True
        CloseAddDNSDomains.Visible = False
    End Sub
End Class
