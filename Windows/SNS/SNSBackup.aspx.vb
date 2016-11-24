
Partial Class Windows_SNS_SNSBackup
    Inherits System.Web.UI.Page

    Protected Sub RGSNSBackup_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles RGSNSBackup.ItemCreated
        If TypeOf (e.Item) Is Telerik.Web.UI.GridFooterItem Then
            Dim footeritem = DirectCast(e.Item, Telerik.Web.UI.GridFooterItem)
            Dim btn As LinkButton = New LinkButton()
            btn.Text = "Backup"
            btn.OnClientClick = "top.OpenWindowV1('/windows/ExecutePS.aspx?APIName=SNSBackup&Execute=1','SNSBackup');"
            footeritem.Cells(5).Controls.Add(btn)
        End If
    End Sub
End Class
