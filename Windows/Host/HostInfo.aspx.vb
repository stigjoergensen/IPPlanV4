Imports System.IO

Partial Class Windows_HostInfo
    Inherits System.Web.UI.Page

    Const DefaultEditMode As String = "Edit" 'View or Edit or New
    Const DefaultHostName As String = "i04071"

    Const ReadGroups As String = "domain users"
    Const UpdateGroups As String = "none"
    Const EditorWidth As Integer = 250

    Private Sub SetUserControlProperty(Control As UserControl, PropertyName As String, PropertyValue As Object)
        Dim type As Type = Control.GetType()
        Dim prop As System.Reflection.PropertyInfo = type.GetProperty(PropertyName)
        If prop IsNot Nothing Then
            prop.SetValue(Control, PropertyValue, Nothing)
        End If

    End Sub

    Private Sub LoadUserControl()
        If ControlPath.Text <> "" Then
            Dim control As UserControl = Page.LoadControl(ControlPath.Text)
            SetUserControlProperty(control, "Hostname", Hostname.Text)
            SetUserControlProperty(control, "EditMode", EditMode.Text)
            SetUserControlProperty(control, "IncludeHistory", IncludeHistory.SelectedValue)
            ControlPanel.ContentTemplateContainer.Controls.Clear()
            ControlPanel.ContentTemplateContainer.Controls.Add(control)
        End If
    End Sub

    Private Function GetViewSecurity(AccessMethod As String) As DataView
        IPPlanV4ViewSecurity.SelectParameters("ViewName").DefaultValue = "Host"
        IPPlanV4ViewSecurity.SelectParameters("AccessMethod").DefaultValue = AccessMethod
        Dim dv As DataView = DirectCast(IPPlanV4ViewSecurity.Select(DataSourceSelectArguments.Empty), DataView)
        Return dv
    End Function

    Private Function AddViewSecurity(CacheTable As DataView, ViewName As String, KeyName As String) As DataRow()
        IPPlanV4ViewSecurity.InsertParameters("ViewName").DefaultValue = ViewName
        IPPlanV4ViewSecurity.InsertParameters("KeyName").DefaultValue = KeyName
        IPPlanV4ViewSecurity.InsertParameters("KeyTitle").DefaultValue = KeyName
        IPPlanV4ViewSecurity.Insert()

        IPPlanV4ViewSecurityAccessMethod.SelectParameters("Viewname").DefaultValue = ViewName
        Dim dv As DataView = DirectCast(IPPlanV4ViewSecurityAccessMethod.Select(DataSourceSelectArguments.Empty), DataView)
        For Each ViewRow As DataRow In dv.Table.Rows
            'IPPlanV4ViewSecurityAccessMethod.InsertParameters("SecurityID").DefaultValue = IPPlanV4ViewSecurity.InsertParameters("SecurityID").DefaultValue
            IPPlanV4ViewSecurityAccessMethod.InsertParameters("AccessMethod").DefaultValue = ViewRow("AccessMethod")
            IPPlanV4ViewSecurityAccessMethod.InsertParameters("ReadGroups").DefaultValue = ReadGroups
            IPPlanV4ViewSecurityAccessMethod.InsertParameters("WriteGroups").DefaultValue = UpdateGroups
            IPPlanV4ViewSecurityAccessMethod.Insert()
        Next

        Dim row As DataRow = CacheTable.Table.NewRow()
        row("ViewName") = ViewName
        row("KeyName") = KeyName
        row("KeyTitle") = KeyName
        row("ReadGroups") = ReadGroups
        row("WriteGroups") = UpdateGroups
        Return CacheTable.Table.Select(String.Format("KeyName='{0}'", KeyName))
    End Function

    Private Function GetHostExtraData(ViewName As String) As DataTable
        Dim Table As DataTable = New DataTable("HostExtraData")
        Table.Columns.Add("FieldTitle", Type.GetType("System.String"))
        Table.Columns.Add("FieldName", Type.GetType("System.String"))
        Table.Columns.Add("FieldValue", Type.GetType("System.String"))
        Table.Columns.Add("Editable", Type.GetType("System.Boolean"))
        Table.Columns.Add("DefaultValue", Type.GetType("System.String"))
        Table.Columns.Add("Formating", Type.GetType("System.String"))
        Table.Columns.Add("SortOrder", Type.GetType("System.Int32"))

        Dim Security As DataView = GetViewSecurity(ViewName)
        Dim dv As DataView = DirectCast(HostExtraData.Select(DataSourceSelectArguments.Empty), DataView)
        If dv IsNot Nothing Then
            For Each column As DataColumn In dv.Table.Columns
                Dim SecurityRows As DataRow() = Security.Table.Select(String.Format("KeyName='{0}'", column.ColumnName))
                If SecurityRows.Count = 0 Then
                    SecurityRows = AddViewSecurity(Security, "Host", column.ColumnName)
                End If
                Dim visible As Boolean = False
                Dim editable As Boolean = False
                For Each row As DataRow In SecurityRows
                    For Each Group As String In row("ReadGroups").ToString().Split(",")
                        visible = visible Or Page.User.IsInRole(Group)
                    Next
                    For Each Group As String In row("WriteGroups").ToString().Split(",")
                        editable = editable Or Page.User.IsInRole(Group)
                    Next
                Next
                If visible Or editable Then
                    Dim row As DataRow = Table.NewRow()
                    row("FieldTitle") = SecurityRows(0)("KeyTitle")
                    row("FieldName") = column.ColumnName
                    row("DefaultValue") = SecurityRows(0)("DefaultValue")
                    row("Formating") = SecurityRows(0)("Formating")
                    If dv.Table.Rows.Count > 0 Then row("FieldValue") = dv.Table.Rows(0)(column).ToString()
                    row("Editable") = editable
                    row("SortOrder") = SecurityRows(0)("Sortorder")
                    Table.Rows.Add(row)
                End If
            Next
        End If
        Table.DefaultView.Sort = "SortOrder ASC, FieldName ASC"
        Return Table
    End Function

    Private Sub PopulatePanelTable(Table As DataTable, Folder As String)
        ' Add the folder
        Dim FolderRow As DataRow = Table.NewRow()
        FolderRow("Folder") = Folder
        FolderRow("ParentFolder") = Path.GetDirectoryName(Folder)
        FolderRow("Filename") = ""
        FolderRow("Title") = Path.GetFileName(Folder)
        FolderRow("IconFile") = "none"
        Table.Rows.Add(FolderRow)

        ' Add Files
        Dim files() As String = Directory.GetFiles(Folder)
        For Each File In files
            If Path.GetExtension(File).ToLower() = ".ascx" Then
                Dim Dir As String = Path.GetDirectoryName(File)
                'If Path.GetFileNameWithoutExtension(File).ToLower() = "default" Then
                If Path.GetFileNameWithoutExtension(File).ToLower() = Path.GetFileName(Dir).ToLower() Then
                    FolderRow("Filename") = File
                Else
                    Dim FileRow As DataRow = Table.NewRow()
                    FileRow("Folder") = File
                    FileRow("ParentFolder") = Folder
                    FileRow("Filename") = File
                    FileRow("Title") = Path.GetFileNameWithoutExtension(File)
                    FileRow("IconFile") = "none"
                    Table.Rows.Add(FileRow)
                End If
            End If
        Next

        ' Iterate folders in folder
        Dim folders() As String = Directory.GetDirectories(Folder)
        For Each SubFolder As String In folders
            PopulatePanelTable(Table, SubFolder)
        Next
    End Sub

    Private Sub PopulatePanelMenu()
        Dim Folders() As String = Directory.GetDirectories(Server.MapPath("~\Windows\Host\Details"))
        Dim PanelMenuTable As DataTable = New DataTable("PanelMenu")
        PanelMenuTable.Columns.Add("ParentFolder", Type.GetType("System.String"))
        PanelMenuTable.Columns.Add("Folder", Type.GetType("System.String"))
        PanelMenuTable.Columns.Add("Filename", Type.GetType("System.String"))
        PanelMenuTable.Columns.Add("Title", Type.GetType("System.String"))
        PanelMenuTable.Columns.Add("IconFile", Type.GetType("System.String"))
        For Each folder As String In Folders
            PopulatePanelTable(PanelMenuTable, folder)
        Next

        Dim row As DataRow = PanelMenuTable.NewRow()
        row("ParentFolder") = Nothing
        row("Folder") = Server.MapPath("~\Windows\Host\Details")
        row("Filename") = ""
        row("Title") = "Server info"
        row("IconFile") = "none"
        PanelMenuTable.Rows.Add(row)


        PanelMenu.DataSource = PanelMenuTable
        PanelMenu.DataBind()
        PanelMenu.ExpandMode = Telerik.Web.UI.PanelBarExpandMode.MultipleExpandedItems
        For Each item As Telerik.Web.UI.RadPanelItem In PanelMenu.GetAllItems()
            If item.Items.Count > 0 Then item.Expanded = True
        Next
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Hostname.Text = Request.QueryString("Hostname")
            EditMode.Text = Request.QueryString("Mode")
            If EditMode.Text = "" Then EditMode.Text = DefaultEditMode
            If Not EditMode.Text.StartsWith("New") And Hostname.Text = "" Then Hostname.Text = DefaultHostName
            If EditMode.Text <> "Edit" And EditMode.Text <> "View" And EditMode.Text <> "New" Then Throw New Exception(EditMode.Text + " is not an approved Mode of operation")
            PopulatePanelMenu()
        End If
        rgHostExtraData.DataSource = GetHostExtraData(EditMode.Text)
        rgHostExtraData.DataBind()
        LoadUserControl()
        InfoPanel.Visible = (EditMode.Text = "View")
    End Sub

    Function GetDBValue(Value As Object) As String
        If IsDBNull(Value) Then Return "" Else Return Value.ToString()
    End Function

    Protected Sub rgHostExtraData_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgHostExtraData.ItemDataBound
        Dim newHost As Boolean = Me.EditMode.Text.StartsWith("New")
        Dim EditMode As Boolean = Me.EditMode.Text.StartsWith("Edit")
        Select Case e.Item.GetType()
            Case GetType(Telerik.Web.UI.GridFooterItem)
                Dim griditem As Telerik.Web.UI.GridFooterItem = e.Item
                Dim cell As System.Web.UI.WebControls.TableCell = griditem("FieldValue")
                cell.FindControl("Update").Visible = EditMode
                cell.FindControl("Create").Visible = newHost
                cell.FindControl("Terminate").Visible = (IPPlanSecurity.isInRole(Page, "Terminate Administrator", "Users can terminate servers") And Not (newHost))
                cell.FindControl("TerminateReq").Visible = EditMode
                rgHostExtraData.ShowFooter = cell.FindControl("Update").Visible Or cell.FindControl("Terminate").Visible Or cell.FindControl("Create").Visible

                Dim footer As Telerik.Web.UI.GridFooterItem = DirectCast(e.Item, Telerik.Web.UI.GridFooterItem)
                'footer("FieldTitle").ColumnSpan = 5
                For i = rgHostExtraData.MasterTableView.GetColumn("FieldTitle").OrderIndex + 1 To footer.Cells.Count - 1
                    footer.Cells(i).Visible = False
                Next
            Case GetType(Telerik.Web.UI.GridDataItem)
                Dim griditem As Telerik.Web.UI.GridDataItem = e.Item
                Dim cell As System.Web.UI.WebControls.TableCell = griditem("FieldValue")
                Dim OriginalValue As Label = griditem("ExtraValues").FindControl("OriginalValue")
                Dim ValueType As Label = griditem("ExtraValues").FindControl("ValueType")
                Dim DefaultValue As String = GetDBValue(e.Item.DataItem("DefaultValue"))
                Select Case e.Item.DataItem("Fieldname")
                    Case "Hostname"
                        Dim textbox As Telerik.Web.UI.RadTextBox = New Telerik.Web.UI.RadTextBox()
                        cell.Controls.Add(textbox)
                        If newHost Then textbox.Text = GetDBValue(e.Item.DataItem("DefaultValue")) Else textbox.Text = GetDBValue(e.Item.DataItem("FieldValue"))
                        textbox.ReadOnly = Not (e.Item.DataItem("Editable") And newHost)
                        textbox.DisabledStyle.CssClass = "riDisabled"
                        textbox.Width = EditorWidth
                        OriginalValue.Text = textbox.Text
                        ValueType.Text = "TextBox"
                    Case "Function", "FunctionAlias", "Location", "AssignedIP", "ManagementIP", "Asset"
                        Dim textbox As Telerik.Web.UI.RadTextBox = New Telerik.Web.UI.RadTextBox()
                        cell.Controls.Add(textbox)
                        If newHost Then textbox.Text = GetDBValue(e.Item.DataItem("DefaultValue")) Else textbox.Text = GetDBValue(e.Item.DataItem("FieldValue"))
                        textbox.ReadOnly = Not (e.Item.DataItem("Editable") And (EditMode Or newHost))
                        textbox.Width = EditorWidth
                        OriginalValue.Text = textbox.Text
                        ValueType.Text = "TextBox"
                    Case "EnvironmentID", "Backup", "Country", "OperationMode", "TierID", "ServiceID", "PatchEnabled", "AppID", "NetworkType"
                        Dim dropdown As Telerik.Web.UI.RadDropDownList = New Telerik.Web.UI.RadDropDownList
                        dropdown.DataTextField = "Text"
                        dropdown.DataValueField = "Value"
                        cell.Controls.Add(dropdown)
                        dropdown.DataSourceID = e.Item.DataItem("FieldName")
                        dropdown.DataBind()
                        If dropdown.Items.FirstOrDefault(Function(i) TryCast(i, Telerik.Web.UI.DropDownListItem).Value = GetDBValue(e.Item.DataItem("FieldValue"))) Is Nothing Then
                            Dim emptyitem As Telerik.Web.UI.DropDownListItem = New Telerik.Web.UI.DropDownListItem
                            emptyitem.Value = GetDBValue(e.Item.DataItem("FieldValue"))
                            emptyitem.Text = "Illegal value, please fix"
                            dropdown.Items.Add(emptyitem)
                        End If
                        If newHost Then dropdown.SelectedValue = GetDBValue(e.Item.DataItem("DefaultValue")) Else dropdown.SelectedValue = GetDBValue((e.Item.DataItem("FieldValue")))
                        dropdown.Enabled = e.Item.DataItem("EditAble") And (EditMode Or newHost)
                        dropdown.Width = EditorWidth
                        OriginalValue.Text = dropdown.SelectedValue
                        ValueType.Text = "DropDown"
                    Case "Responsible", "Owner", "Contact"
                        Dim textbox As Telerik.Web.UI.RadTextBox = New Telerik.Web.UI.RadTextBox()
                        cell.Controls.Add(textbox)
                        If newHost Then textbox.Text = GetDBValue(e.Item.DataItem("DefaultValue")) Else textbox.Text = GetDBValue(e.Item.DataItem("FieldValue"))
                        textbox.ReadOnly = Not (e.Item.DataItem("Editable") And (EditMode Or newHost))
                        textbox.Width = EditorWidth
                        OriginalValue.Text = textbox.Text
                        ValueType.Text = "TextBox"
                    Case "EndOfLife", "CreateDate", "LastUpdate"
                        Dim datebox As Telerik.Web.UI.RadDateTimePicker = New Telerik.Web.UI.RadDateTimePicker()
                        cell.Controls.Add(datebox)
                        If newHost Then
                            If GetDBValue(e.Item.DataItem("DefaultValue")) <> "" Then
                                datebox.SelectedDate = Date.Parse(GetDBValue(e.Item.DataItem("DefaultValue")))
                            End If
                        Else
                            If GetDBValue(e.Item.DataItem("FieldValue")) <> "" Then
                                datebox.SelectedDate = Date.Parse(GetDBValue(e.Item.DataItem("FieldValue")))
                            End If
                        End If
                        datebox.Enabled = e.Item.DataItem("Editable") And (EditMode Or newHost)
                        'datebox.DateInput.DateFormat = "yyyy.MM.dd HH:mm"
                        'datebox.DateInput.DisplayDateFormat = "yyyy.MM.dd HH:mm"
                        datebox.DateInput.DateFormat = e.Item.DataItem("Formating")
                        datebox.DateInput.DisplayDateFormat = e.Item.DataItem("Formating")
                        datebox.Width = EditorWidth
                        If datebox.SelectedDate Is Nothing Then
                            OriginalValue.Text = ""
                        Else
                            OriginalValue.Text = datebox.SelectedDate
                        End If
                        ValueType.Text = "DateBox"
                End Select
        End Select
    End Sub

    Protected Sub rgHostExtraData_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgHostExtraData.ItemCommand
        If e.CommandName = "Update" Then
        End If
    End Sub

    Protected Sub PanelMenu_ItemClick(sender As Object, e As Telerik.Web.UI.RadPanelBarEventArgs) Handles PanelMenu.ItemClick
        ControlPath.Text = e.Item.Value.Replace(Server.MapPath("/"), "~\")
        LoadUserControl()
    End Sub

    Function SetDBValue(Value As Object) As Object
        If Value Is Nothing Then
            Return ""
        Else
            If Value.ToString() = "" Then
                Return ""
            Else
                Return Value.ToString()
            End If
        End If
    End Function

    Protected Sub Update_Click(sender As Object, e As EventArgs)
        Dim updateHostExtraData As String = ""
        Dim delimiter As String = ""
        HostExtraData.UpdateParameters.Clear()
        HostExtraData.UpdateParameters.Add("_key", Hostname.Text)
        Dim InsertHostHistory As String = ""
        For Each row As Telerik.Web.UI.GridDataItem In rgHostExtraData.Items
            Dim OriginalValue As String = DirectCast(row("ExtraValues").FindControl("Originalvalue"), Label).Text
            Dim NewValue As String = ""
            Dim ValueType As String = DirectCast(row("ExtraValues").FindControl("ValueType"), Label).Text
            Dim Fieldname As String = row("FieldName").Text
            Select Case ValueType
                Case "TextBox"
                    NewValue = SetDBValue(DirectCast(row("FieldValue").Controls(0), Telerik.Web.UI.RadTextBox).Text)
                Case "DateBox"
                    NewValue = SetDBValue(DirectCast(row("FieldValue").Controls(0), Telerik.Web.UI.RadDateTimePicker).SelectedDate)
                Case "DropDown"
                    NewValue = SetDBValue(DirectCast(row("FieldValue").Controls(0), Telerik.Web.UI.RadDropDownList).SelectedValue)
            End Select
            If NewValue <> OriginalValue Then
                InsertHostHistory = String.Format("{0}{1}{2} have changed from '{3}' to '{4}'", InsertHostHistory, Environment.NewLine, Fieldname, OriginalValue)
                updateHostExtraData = String.Format("{0} {1}[{2}]=@{2}", updateHostExtraData, delimiter, Fieldname)
                HostExtraData.UpdateParameters.Add(Fieldname, NewValue)
                HostExtraData.UpdateParameters(HostExtraData.UpdateParameters.Count - 1).ConvertEmptyStringToNull = True
                delimiter = ", "
            End If
        Next
        HostExtraData.UpdateParameters("LastUpdate").DefaultValue = Now()
        HostExtraData.UpdateCommand = String.Format("UPDATE HostExtraData SET {0} WHERE Hostname=@_key", updateHostExtraData)
        If HostExtraData.UpdateParameters.Count > 1 Then
            HostExtraData.Update()
            HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
            HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("Was changed `r`n{0}", InsertHostHistory)
            HostExtraDataHistory.Insert()
        End If
    End Sub

    Protected Sub IPPlanV4ViewSecurity_Inserted(sender As Object, e As SqlDataSourceStatusEventArgs) Handles IPPlanV4ViewSecurity.Inserted
        IPPlanV4ViewSecurityAccessMethod.InsertParameters("SecurityID").DefaultValue = e.Command.Parameters("@SecurityID").Value
    End Sub

    Protected Sub TerminateReq_Click(sender As Object, e As EventArgs)
        DirectCast(sender, Telerik.Web.UI.RadButton).Visible = False
        PanelTerminateReq.Visible = True
    End Sub

    Protected Sub TerminateReqExec_Click(sender As Object, e As EventArgs) Handles TerminateReqExec.Click
        Dim Params As Dictionary(Of String, String) = New Dictionary(Of String, String)
        Params.Add("Hostname", Hostname.Text)
        Params.Add("Reason", TerminateReason.Text)
        Dim exec As IPPlanPowershell = New IPPlanPowershell("TerminateRequest", User.Identity.Name, Params)
        If exec.Host.ResultCode = 0 Then
            HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
            HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("Requested terminated with the following reason: '{0}'", TerminateReason.Text)
            HostExtraDataHistory.Insert()
            PanelTerminateReq.Visible = False
            ErrorLabel.Text = exec.Host.ResultText
        Else
            HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
            HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("Failed to request termination", exec.Host.ResultText)
            HostExtraDataHistory.Insert()
            ErrorLabel.Text = exec.Host.ResultText
        End If
    End Sub

    Protected Sub Terminate_Click(sender As Object, e As EventArgs)
        Dim Params As Dictionary(Of String, String) = New Dictionary(Of String, String)
        Params.Add("Hostname", Hostname.Text)
        Dim exec As IPPlanPowershell = New IPPlanPowershell("TerminateExecute", User.Identity.Name, Params)
        If exec.Host.ResultCode = 0 Then
            HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
            HostExtraDataHistory.InsertParameters("Description").DefaultValue = "have been terminated"
            HostExtraDataHistory.Insert()
            HostExtraData.Delete()
            ErrorLabel.Text = exec.Host.ResultText
        Else
            HostExtraDataHistory.InsertParameters("Who").DefaultValue = Page.User.Identity.Name
            HostExtraDataHistory.InsertParameters("Description").DefaultValue = String.Format("Failed to terminate", exec.Host.ResultText)
            HostExtraDataHistory.Insert()
            ErrorLabel.Text = exec.Host.ResultText
        End If
    End Sub
End Class
