
Partial Class StorageReport
    Inherits System.Web.UI.Page

    Private ExportToPDF As Boolean = False

    Private Sub StorageReportExportExcel()
        RGStorage.ExportSettings.Excel.Format = Telerik.Web.UI.GridExcelExportFormat.Xlsx
        RGStorage.ExportSettings.IgnorePaging = True
        RGStorage.ExportSettings.ExportOnlyData = True
        RGStorage.ExportSettings.OpenInNewWindow = True
        RGStorage.ExportSettings.FileName = String.Format("StorageReport_{0:yyyyMMdd}", Now())
        RGStorage.MasterTableView.ExportToExcel()
    End Sub

    Private Sub StorageReportExportPDF()
        RGStorage.ExportSettings.Pdf.Subject = String.Format("Storage report {0:yyyyMMdd}", Now())
        RGStorage.ExportSettings.Pdf.PaperSize = Telerik.Web.UI.GridPaperSize.A4
        Dim t = RGStorage.ExportSettings.Pdf.PageWidth
        RGStorage.ExportSettings.Pdf.PageWidth = RGStorage.ExportSettings.Pdf.PageHeight
        RGStorage.ExportSettings.Pdf.PageHeight = t
        RGStorage.ExportSettings.Pdf.PageLeftMargin = 0
        RGStorage.ExportSettings.Pdf.PageRightMargin = 0
        RGStorage.ExportSettings.Pdf.AllowModify = False
        RGStorage.ExportSettings.Pdf.AllowAdd = False
        RGStorage.ExportSettings.UseItemStyles = True

        RGStorage.Rebind()
        RGStorage.MasterTableView.ExportToPdf()
    End Sub


    Protected Sub UserExportExcel()
        'GTWUsers
        RGStorage.ExportSettings.Excel.Format = Telerik.Web.UI.GridExcelExportFormat.Xlsx
        RGStorage.ExportSettings.IgnorePaging = True
        RGStorage.ExportSettings.ExportOnlyData = True
        RGStorage.ExportSettings.OpenInNewWindow = True
        RGStorage.ExportSettings.FileName = String.Format("UserReport_{0:yyyyMMdd}", Now())
        RGStorage.MasterTableView.HierarchyDefaultExpanded = True
        RGStorage.MasterTableView.DetailTables(0).HierarchyDefaultExpanded = True
        RGStorage.MasterTableView.DetailTables(0).DetailTables(0).HierarchyDefaultExpanded = True
        RGStorage.Rebind()
        RGStorage.MasterTableView.DetailTables(0).DetailTables(0).ExportToExcel()
    End Sub

    Protected Sub RGStorage_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles RGStorage.ItemCommand
        Select Case e.CommandName
            Case "Export"
                Select Case e.CommandArgument
                    Case "StorageExcel"
                        StorageReportExportExcel()
                    Case "StoragePDF"
                        ExportToPDF = True
                        StorageReportExportPDF()
                    Case "CountryUser"
                        UserExportExcel()
                End Select
        End Select
    End Sub

    Protected Sub RGStorage_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles RGStorage.ItemCreated
        If ExportToPDF Then ApplyPDFStyle(e.Item)
    End Sub


    Private Sub ApplyPDFStyle(item As Telerik.Web.UI.GridItem)
        Select Case item.GetType()
            Case GetType(Telerik.Web.UI.GridHeaderItem)
                For Each Cell As TableCell In item.Cells
                    Cell.HorizontalAlign = HorizontalAlign.Center
                    Cell.Style("font-size") = "7pt"
                    Cell.Style("width") = "2px"
                    Cell.Style("text-align") = "center"
                    Cell.Style("margin") = "0px 0px 0px 0px"
                    Cell.Style("padding") = "0px 0px 0px 0px"
                    Cell.BorderStyle = BorderStyle.None
                    Cell.Width = Unit.Pixel(2)
                Next
            Case GetType(Telerik.Web.UI.GridDataItem)
                For Each Cell As TableCell In item.Cells
                    Cell.Style("font-size") = "6pt"
                    Cell.Style("width") = "2px"
                    Cell.Style("text-align") = "center"
                    Cell.Style("margin") = "0px 0px 0px 0px"
                    Cell.Style("padding") = "0px 0px 0px 0px"
                    Cell.BorderStyle = BorderStyle.None
                    Cell.Width = Unit.Pixel(2)
                Next
            Case GetType(Telerik.Web.UI.GridFooterItem)
                For Each Cell As TableCell In item.Cells
                    Cell.Style("font-size") = "6pt"
                    Cell.Style("width") = "2px"
                    Cell.Style("text-align") = "center"
                    Cell.Style("margin") = "0px 0px 0px 0px"
                    Cell.Style("padding") = "0px 0px 0px 0px"
                    Cell.BorderStyle = BorderStyle.None
                    Cell.Width = Unit.Pixel(2)
                Next
        End Select
    End Sub
End Class
