
Partial Class Windows_Host_Details_Windows_Disk
    Inherits System.Web.UI.UserControl

    Public Property Hostname() As String
        Get
            Return lblHostname.Text
        End Get
        Set(value As String)
            lblHostname.Text = value
        End Set
    End Property

    Public Property includeHistory() As String
        Get
            Return lblIncludeHistory.Text
        End Get
        Set(value As String)
            lblIncludeHistory.Text = value
        End Set
    End Property

    Protected Sub rgHostDisk_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgHostDisk.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem Then
            If DirectCast(e.Item, Telerik.Web.UI.GridDataItem).GetDataKeyValue("DeviceID").ToString() = lblDeviceID.Text Then
                e.Item.Selected = True
            End If
        End If
    End Sub


    Protected Sub rgHostDisk_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rgHostDisk.SelectedIndexChanged
        lblDeviceID.Text = rgHostDisk.SelectedValue
    End Sub

    Protected Sub GraphMethod_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles GraphMethod.SelectedIndexChanged
        LineChart.DataSourceID = "HostDiskHistory" + GraphMethod.SelectedValue.ToString()
        LineChart.DataBind()
        Dim t As Integer = LineChart.PlotArea.Series(1).Items.Count
    End Sub
End Class
