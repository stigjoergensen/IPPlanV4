
Partial Class Config_UserSettings
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        If Not Page.IsPostBack Then
            Username.Text = Page.User.Identity.Name
            find.Visible = IPPlanSecurity.isInRole(Page, "UserSettings administrator", "Administrator of user settings")
            Username.ReadOnly = Not find.Visible
        End If
    End Sub

    Protected Sub IPPlanV4Config_Updated(sender As Object, e As SqlDataSourceStatusEventArgs) Handles IPPlanV4Config.Updated
        If e.AffectedRows = 0 Then
            IPPlanV4Config.InsertParameters("KeyName").DefaultValue = IPPlanV4Config.UpdateParameters("Keyname").DefaultValue
            IPPlanV4Config.InsertParameters("KeyValue").DefaultValue = IPPlanV4Config.UpdateParameters("KeyValue").DefaultValue
            IPPlanV4Config.Insert()
        End If
    End Sub

    Protected Sub rgIPPlanV4Config_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgIPPlanV4Config.ItemCreated
        If (Not Page.IsPostBack AndAlso TypeOf e.Item Is Telerik.Web.UI.GridEditableItem) Then
            Dim ctl = DirectCast(e.Item, Telerik.Web.UI.GridEditableItem)
            'e.Item.Edit = True
        End If
    End Sub

    Protected Sub rgIPPlanV4Config_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgIPPlanV4Config.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridEditableItem Then
            DirectCast(DirectCast(e.Item, Telerik.Web.UI.GridEditableItem)("ValueColumn").FindControl("NewValue"), Telerik.Web.UI.RadTextBox).ReadOnly = Not Page.User.IsInRole(e.Item.DataItem("EditADGroup"))
        End If
    End Sub

    Protected Sub find_Click(sender As Object, e As EventArgs) Handles find.Click
        rgIPPlanV4Config.DataBind()
    End Sub

    Protected Sub Save_Click(sender As Object, e As EventArgs) Handles Save.Click
        For Each row As Telerik.Web.UI.GridDataItem In rgIPPlanV4Config.Items
            If TypeOf row Is Telerik.Web.UI.GridEditableItem Then
                Dim NewValue As String = DirectCast(DirectCast(row, Telerik.Web.UI.GridEditableItem)("ValueColumn").FindControl("NewValue"), Telerik.Web.UI.RadTextBox).Text
                Dim OldValue As String = DirectCast(DirectCast(row, Telerik.Web.UI.GridEditableItem)("ValueColumn").FindControl("OldValue"), Telerik.Web.UI.RadTextBox).Text
                Dim KeyName As String = DirectCast(DirectCast(row, Telerik.Web.UI.GridEditableItem)("KeyNameColumn"), Telerik.Web.UI.GridTableCell).Text
                If NewValue <> OldValue Then
                    IPPlanV4Config.UpdateParameters("Keyname").DefaultValue = KeyName
                    IPPlanV4Config.UpdateParameters("KeyValue").DefaultValue = NewValue
                    IPPlanV4Config.Update()
                End If
            End If
        Next
    End Sub
End Class
