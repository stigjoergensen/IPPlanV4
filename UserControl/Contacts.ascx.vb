
Partial Class UserControl_Contacts
    Inherits System.Web.UI.UserControl

    Private Const ScriptName = "ContactsJavascript"
    Private _Hostname As String
    Private Hostvalues As Dictionary(Of String, String)
    Private ShowSecurityEdit As Boolean = False

    Public Property EditMode As String
    Public Property HostnameID As String
    Public Property HostnameProperty As String


    Private Function FindControlRecursive(control As Control, id As String) As Control
        If control Is Nothing Then
            Return Nothing
        End If
        If control.ID = id Then
            Return control
        End If

        For Each c As Control In control.Controls
            Dim found = FindControlRecursive(c, id)
            If found IsNot Nothing Then
                Return found
            End If
        Next

        Return Nothing
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim ctrl As Control = FindControlRecursive(Me.Page, HostnameID)
        If TypeOf ctrl Is WebControl Then
            Dim a As Type = ctrl.GetType()
            Dim propinfo As System.Reflection.PropertyInfo = a.GetProperty(HostnameProperty)
            lblHostname.Text = propinfo.GetValue(ctrl, {})
            GetHostValues()
        Else
            Throw New InvalidCastException("HostnameID is not pointing to a WebControl")
        End If
    End Sub

    Protected Sub rgContacts_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgContacts.ItemCommand
        Select Case e.CommandName.ToLower()
            Case "update"
                For Each row As Telerik.Web.UI.GridDataItem In rgContacts.Items
                    Dim ContactTypeName As String = DirectCast(row("ContactTypeName").FindControl("ContactTypeName"), Label).Text
                    Dim originalvalue As String = DirectCast(row("Contact").FindControl("originalContact"), Label).Text
                    Dim Contact As String = DirectCast(row("Contact").FindControl("Contact"), Telerik.Web.UI.RadComboBox).SelectedValue
                    Dim exists As Integer = "0" + DirectCast(row("Contact").FindControl("Exists"), Label).Text
                    Dim ContactTypeID As Integer = DirectCast(row("Contact").FindControl("ContactTypeID"), Label).Text
                    If exists > 0 Then
                        If Contact.Trim().Length() = 0 Then
                            HostContact.DeleteParameters("ContactTypeID").DefaultValue = ContactTypeID
                            HostContact.Delete()

                            HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("'{0}' have been removed, was '{1}'", {ContactTypeName, originalvalue})
                            HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
                            HostExtraDataHistory.InsertParameters("When").DefaultValue = Now()
                            HostExtraDataHistory.Insert()
                        Else
                            If originalvalue <> Contact Then
                                HostContact.UpdateParameters("ContactTypeID").DefaultValue = ContactTypeID
                                HostContact.UpdateParameters("Contact").DefaultValue = Contact
                                HostContact.Update()

                                HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("'{0}' have been updated from '{1}' to '{2}'", {ContactTypeName, originalvalue, Contact})
                                HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
                                HostExtraDataHistory.InsertParameters("When").DefaultValue = Now()
                                HostExtraDataHistory.Insert()
                            End If
                        End If
                    Else
                        If Contact.Trim().Length > 0 Then
                            HostContact.InsertParameters("ContactTypeID").DefaultValue = ContactTypeID
                            HostContact.InsertParameters("Contact").DefaultValue = Contact
                            HostContact.Insert()
                            HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("'{0}' have been inserted with '{1}'", {ContactTypeName, Contact})
                            HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
                            HostExtraDataHistory.InsertParameters("When").DefaultValue = Now()
                            HostExtraDataHistory.Insert()
                        End If
                    End If
                Next
            Case "security"
                ShowSecurityEdit = DirectCast(e.CommandSource, Telerik.Web.UI.RadButton).Text.ToLower() = "edit security"
                rgContacts.DataBind()
            Case "updatesecurity"
                For Each row As Telerik.Web.UI.GridDataItem In rgContacts.Items
                    Dim ContactTypeName As String = DirectCast(row("ContactTypeName").FindControl("ContactTypeName"), Label).Text
                    Dim ContactTypeID As Integer = DirectCast(row("Contact").FindControl("ContactTypeID"), Label).Text
                    Dim Security As String = DirectCast(row("Security").FindControl("Security"), Telerik.Web.UI.RadTextBox).Text
                    Dim OriginalSecurity As String = DirectCast(row("Security").FindControl("OriginalSecurity"), Label).Text
                    If OriginalSecurity <> Security Then
                        IPPlanV4ContactTypes.UpdateParameters("ContactTypeID").DefaultValue = ContactTypeID
                        IPPlanV4ContactTypes.UpdateParameters("EditGroups").DefaultValue = Security
                        IPPlanV4ContactTypes.Update()

                        HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("Security updated on '{0}' from '{1}' to '{2}'", {ContactTypeName, OriginalSecurity, Security})
                        HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
                        HostExtraDataHistory.InsertParameters("When").DefaultValue = Now()
                        HostExtraDataHistory.Insert()
                    End If
                Next
        End Select
    End Sub

    Protected Sub rgContacts_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgContacts.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem Then
            Dim GridRow As Telerik.Web.UI.GridDataItem = DirectCast(e.Item, Telerik.Web.UI.GridDataItem)
            Dim OriginalContact As Label = GridRow("Contact").FindControl("OriginalContact")
            Dim SecurityInfo As Image = GridRow("Security").FindControl("SecurityInfo")
            Dim SecurityEdit As Telerik.Web.UI.RadTextBox = GridRow("Security").FindControl("Security")
            Dim SecurityText As StringBuilder = New StringBuilder()

            Dim contact As Telerik.Web.UI.RadComboBox = GridRow("Contact").FindControl("Contact")
            contact.Text = IIf(IsDBNull(GridRow.DataItem("Contact")), "", GridRow.DataItem("Contact"))
            contact.SelectedValue = contact.Text
            contact.Attributes.Add("ReturnAttribute", "mail,cn")
            contact.Attributes.Add("SearchClasses", "user,group")

            Dim Editable As Boolean = False
            For Each Str As String In GridRow.DataItem("EditGroups").ToString().Split(",")
                For Each key As String In Hostvalues.Keys
                    Str = Str.Replace("$" + key, Hostvalues(key))
                Next
                SecurityText.AppendLine(Str)
                Editable = Editable Or Page.User.IsInRole(Str)
            Next
            Editable = Editable Or (GridRow.DataItem("isUserEditAble") = 1 AndAlso Page.User.IsInRole(IIf(IsDBNull(GridRow.DataItem("Contact")), "group does not exists", GridRow.DataItem("Contact").ToString())))

            If SecurityText.Length > 2 Then
                SecurityText.Insert(0, "The following groups have access to modify:" + Environment.NewLine)
                SecurityInfo.ToolTip = SecurityText.ToString()
                SecurityInfo.Visible = True
            Else
                SecurityInfo.Visible = False
            End If

            SecurityEdit.Visible = ShowSecurityEdit
            SecurityInfo.Visible = SecurityInfo.Visible And (Not ShowSecurityEdit)

            OriginalContact.Visible = Not (Editable And (EditMode = "1"))
            contact.Visible = Editable And (EditMode = "1")
        ElseIf TypeOf e.Item Is Telerik.Web.UI.GridFooterItem Then
            Dim Button As Telerik.Web.UI.RadButton = DirectCast(e.Item, Telerik.Web.UI.GridFooterItem)("ContactTypeName").FindControl("Security")
            Button.Visible = IPPlanSecurity.isInRole(Page, "Contact Administrator", "Administrator of contacts")
            If ShowSecurityEdit Then
                Button.Text = "Hide Security"
            Else
                Button.Text = "Edit Security"
            End If
            DirectCast(e.Item, Telerik.Web.UI.GridFooterItem)("Security").FindControl("UpdateSecurity").Visible = ShowSecurityEdit
        End If
    End Sub

    Private Sub GetHostValues()
        Hostvalues = New Dictionary(Of String, String)
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand("SELECT * FROM HostExtraData WHERE Hostname=@Hostname", connection)
        selectCommand.Parameters.AddWithValue("Hostname", lblHostname.Text)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        If products.Rows.Count > 0 Then
            For Each col As System.Data.DataColumn In products.Columns
                If Not IsDBNull(products.Rows(0)(col.ColumnName)) Then
                    Hostvalues.Add(col.ColumnName, products.Rows(0)(col.ColumnName).ToString())
                End If
            Next
        End If
        connection.Close()
        connection.Dispose()
    End Sub
End Class
