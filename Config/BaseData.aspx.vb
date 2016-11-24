
Partial Class Config_BaseData
    Inherits System.Web.UI.Page

    ' SELECT <set> FROM TableName
    ' INSERT INTO Tablename (<set>) VALUES(<set>)
    ' UPDATE SET <set> WHERE <set> 
    ' DELETE FROM TableName WHERE <set>

    Private SelectList As List(Of String)
    Private WhereList As List(Of String)
    Private UpdateSetList As List(Of String)
    Private InsertList As List(Of String)
    Private InsertValueList As List(Of String)
    Private KeyList As List(Of String)

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If ViewState("SelectCommand") IsNot Nothing Then
            TableEdit.SelectCommand = ViewState("SelectCommand")
            TableEdit.UpdateCommand = ViewState("UpdateCommand")
            TableEdit.InsertCommand = ViewState("InsertCommand")
            TableEdit.DeleteCommand = ViewState("DeleteCommand")
        End If
        Dim GroupItem As Telerik.Web.UI.RadPanelItem = Nothing
        If Not IsPostBack Then
            Dim view As DataView = TableGroup.Select(DataSourceSelectArguments.Empty())
            For Each row As DataRow In view.Table.Rows
                If GroupItem Is Nothing OrElse row("GroupName").ToString <> GroupItem.Text Then
                    GroupItem = New Telerik.Web.UI.RadPanelItem()
                    GroupItem.Text = row("GroupName").ToString()
                    GroupItem.ToolTip = "ID: " + row("BaseGroupID").ToString()
                    SelectPanel.Items.Add(GroupItem)
                End If
                Dim item As Telerik.Web.UI.RadPanelItem = New Telerik.Web.UI.RadPanelItem()
                item.Text = row("name").ToString()
                item.Value = row("EditADGroup").ToString()
                item.ToolTip = row("Description").ToString()
                GroupItem.Items.Add(item)
            Next
        End If
    End Sub

    Protected Sub rgTableInfo_DataBinding(sender As Object, e As EventArgs) Handles rgTableInfo.DataBinding
        TableEdit.SelectParameters.Clear()
        TableEdit.UpdateParameters.Clear()
        TableEdit.InsertParameters.Clear()
        TableEdit.DeleteParameters.Clear()
        SelectList = New List(Of String)
        WhereList = New List(Of String)
        UpdateSetList = New List(Of String)
        InsertList = New List(Of String)
        InsertValueList = New List(Of String)
        KeyList = New List(Of String)
        rgTableEdit.MasterTableView.DataKeyNames = New [String]() {}
    End Sub

    Protected Sub rgTableInfo_DataBound(sender As Object, e As EventArgs) Handles rgTableInfo.DataBound
        If SelectList IsNot Nothing Then
            selectcmd.Text = "SELECT " + String.Join(",", SelectList.ToArray()) + " FROM " + TableName.Text
            updatecmd.Text = "UPDATE " + TableName.Text + " SET " + String.Join(",", UpdateSetList.ToArray()) + " WHERE " + String.Join(" AND ", WhereList.ToArray())
            deletecmd.Text = "DELETE FROM " + TableName.Text + " WHERE " + String.Join(" AND ", WhereList.ToArray())
            insertcmd.Text = "INSERT INTO " + TableName.Text + "(" + String.Join(",", InsertList.ToArray()) + ") VALUES(" + String.Join(",", InsertValueList.ToArray()) + ")"

            Dim arr As String() = KeyList.ToArray()
            rgTableEdit.MasterTableView.DataKeyNames = arr

            ViewState("SelectCommand") = selectcmd.Text
            ViewState("UpdateCommand") = updatecmd.Text
            ViewState("InsertCommand") = insertcmd.Text
            ViewState("DeleteCommand") = deletecmd.Text
            If SelectList.Count > 0 Then

                TableEdit.SelectCommand = selectcmd.Text
                TableEdit.UpdateCommand = updatecmd.Text
                TableEdit.InsertCommand = insertcmd.Text
                TableEdit.DeleteCommand = deletecmd.Text

                'rgTableEdit.DataSource = TableEdit
                rgTableEdit.DataBind()
            End If
        End If
    End Sub

    Protected Sub rgTableInfo_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgTableInfo.ItemDataBound
        Select Case e.Item.GetType()
            Case GetType(Telerik.Web.UI.GridDataItem)
                If SelectList IsNot Nothing Then
                    SelectList.Add("[" + e.Item.DataItem("Name").ToString() + "]")
                    If e.Item.DataItem("is_primarykey").ToString() = "1" Then
                        WhereList.Add(e.Item.DataItem("Name").ToString() + "=@" + e.Item.DataItem("name".ToString()))
                        KeyList.Add(e.Item.DataItem("Name").ToString())
                        TableEdit.UpdateParameters.Add(e.Item.DataItem("Name").ToString(), e.Item.DataItem("Datatype").ToString())
                        TableEdit.DeleteParameters.Add(e.Item.DataItem("Name").ToString(), e.Item.DataItem("Datatype").ToString())
                        If e.Item.DataItem("is_identity").ToString() <> "True" Then
                            InsertList.Add(e.Item.DataItem("name".ToString()))
                            InsertValueList.Add("@" + e.Item.DataItem("name".ToString()))
                            TableEdit.InsertParameters.Add(e.Item.DataItem("Name").ToString(), e.Item.DataItem("Datatype").ToString())
                            'UpdateSetList.Add(e.Item.DataItem("Name").ToString() + "=@" + e.Item.DataItem("name".ToString()))
                        End If
                    Else
                        If e.Item.DataItem("is_computed").ToString() <> "True" And e.Item.DataItem("is_identity").ToString() <> "True" Then
                            InsertList.Add(e.Item.DataItem("name".ToString()))
                            InsertValueList.Add("@" + e.Item.DataItem("name".ToString()))
                            TableEdit.InsertParameters.Add(e.Item.DataItem("Name").ToString(), e.Item.DataItem("Datatype").ToString())

                            UpdateSetList.Add(e.Item.DataItem("Name").ToString() + "=@" + e.Item.DataItem("name".ToString()))
                            TableEdit.UpdateParameters.Add(e.Item.DataItem("Name").ToString(), e.Item.DataItem("Datatype").ToString())
                        End If
                    End If
                End If
        End Select
    End Sub

    Protected Sub rgTableEdit_DataBound(sender As Object, e As EventArgs) Handles rgTableEdit.DataBound
        rgTableEdit.Columns(1).Visible = False                              ' edit column
        For Each Str As String In EditADGroup.Text.Split(",")
            rgTableEdit.Columns(1).Visible = rgTableEdit.Columns(1).Visible Or Page.User.IsInRole(Str)
        Next
        rgTableEdit.Columns(2).Visible = rgTableEdit.Columns(1).Visible     ' add / delete column
        rgTableEdit.Columns(0).Visible = rgTableEdit.Items.Count > 0        ' export column
        rgTableEdit.Columns(0).OrderIndex = 9998
    End Sub

    Protected Sub rgTableEdit_DeleteCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgTableEdit.DeleteCommand
        Dim EditedItem As Telerik.Web.UI.GridEditableItem = e.Item
        Dim NewValues As Dictionary(Of String, String) = New Dictionary(Of String, String)
        e.Item.OwnerTableView.ExtractValuesFromItem(NewValues, EditedItem)
        InsertHistory(TableName.Text, "Delete", NewValues, EditedItem.SavedOldValues)
    End Sub

    Protected Sub rgTableEdit_InsertCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgTableEdit.InsertCommand
        Dim EditedItem As Telerik.Web.UI.GridEditableItem = e.Item
        Dim NewValues As Dictionary(Of String, String) = New Dictionary(Of String, String)
        e.Item.OwnerTableView.ExtractValuesFromItem(NewValues, EditedItem)
        InsertHistory(TableName.Text, "Insert", NewValues, EditedItem.SavedOldValues)
    End Sub

    Protected Sub rgTableEdit_UpdateCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgTableEdit.UpdateCommand
        Dim EditedItem As Telerik.Web.UI.GridEditableItem = e.Item
        Dim NewValues As Dictionary(Of String, String) = New Dictionary(Of String, String)
        e.Item.OwnerTableView.ExtractValuesFromItem(NewValues, EditedItem)
        InsertHistory(TableName.Text, "Update", NewValues, EditedItem.SavedOldValues)
    End Sub

    Protected Sub rgTableEdit_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgTableEdit.ItemCreated
        Select Case e.Item.GetType()
            Case GetType(Telerik.Web.UI.GridHeaderItem)
                Dim lb As LinkButton = New LinkButton()
                lb.Text = "Add"
                lb.CommandName = "InitInsert"
                lb.Attributes.Add("style", "text-decoration: underline;")
                DirectCast(e.Item, Telerik.Web.UI.GridHeaderItem)("DeleteColumn").Controls.Add(lb)

                Dim filterbutton As Telerik.Web.UI.RadButton = New Telerik.Web.UI.RadButton()
                filterbutton.Image.ImageUrl = "/images/filter_16x16"
                filterbutton.Image.EnableImageButton = True
                filterbutton.Image.IsBackgroundImage = True
                filterbutton.Width = 16
                filterbutton.Height = 16
                DirectCast(e.Item, Telerik.Web.UI.GridHeaderItem)("EditColumn").Controls.Add(filterbutton)
        End Select
    End Sub

    Protected Sub rgTableEdit_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgTableEdit.ItemCommand
        Select Case e.CommandName
            Case "Export"
                rgTableEdit.ExportSettings.Excel.Format = Telerik.Web.UI.GridExcelExportFormat.Xlsx
                rgTableEdit.ExportSettings.IgnorePaging = True
                rgTableEdit.ExportSettings.ExportOnlyData = True
                rgTableEdit.ExportSettings.OpenInNewWindow = True
                rgTableEdit.ExportSettings.FileName = String.Format("Export_{0:yyyyMMdd}", Now())
                rgTableEdit.MasterTableView.ExportToExcel()
                InsertHistory(TableName.Text, "Export")
        End Select
    End Sub

    Protected Sub rgBaseData_DataBound(sender As Object, e As EventArgs) Handles rgBaseData.DataBound
        'rgBaseData.Columns(0).Visible = Page.User.IsInRole("GRIT.G.U.IPPlan.Admin")
        If IPPlanSecurity.isInRole(Page, "BaseData Administrator", "Members can edit base data") Then
            rgBaseData.Items(0).Edit = True
        End If
        rgBaseData.Visible = (TableName.Text <> "")
    End Sub

    Protected Sub SelectPanel_ItemClick(sender As Object, e As Telerik.Web.UI.RadPanelBarEventArgs) Handles SelectPanel.ItemClick
        If e.Item.Items.Count = 0 Then
            TableName.Text = e.Item.Text
            EditADGroup.Text = e.Item.Value
            rgTableInfo.DataBind()
            rgBaseData.DataBind()
            rgAffectedTables.DataBind()
        End If
    End Sub

    Protected Sub rgBaseData_UpdateCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgBaseData.UpdateCommand
        Dim EditedItem As Telerik.Web.UI.GridEditableItem = e.Item
        Dim NewValues As Dictionary(Of String, String) = New Dictionary(Of String, String)
        e.Item.OwnerTableView.ExtractValuesFromItem(NewValues, EditedItem)
        If EditedItem.GetDataKeyValue("BaseDataID").ToString() = "" Then
            InsertHistory("BaseData", "Insert", NewValues, EditedItem.SavedOldValues)
            BaseData.InsertParameters("BaseGroupID").DefaultValue = NewValues("BaseGroupID")
            BaseData.InsertParameters("Description").DefaultValue = NewValues("Description")
            BaseData.InsertParameters("EditADGroup").DefaultValue = NewValues("EditADGroup")
            BaseData.Insert()
        Else
            InsertHistory("BaseData", "Update", NewValues, EditedItem.SavedOldValues)
            BaseData.UpdateParameters("BaseDataID").DefaultValue = EditedItem.GetDataKeyValue("BaseDataID")
            BaseData.UpdateParameters("BaseGroupID").DefaultValue = NewValues("BaseGroupID")
            BaseData.UpdateParameters("Description").DefaultValue = NewValues("Description")
            BaseData.UpdateParameters("EditADGroup").DefaultValue = NewValues("EditADGroup")
            BaseData.Update()
        End If
        rgBaseData.Items(0).Edit = True
    End Sub

    Private Sub InsertHistory(TableName As String, Method As String, Optional NewValues As Dictionary(Of String, String) = Nothing, Optional Oldvalues As Hashtable = Nothing)
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        connection.Open()
        Dim cmdInsertMain As SqlCommand = New SqlCommand("INSERT INTO BaseDataHistory(TableName,Method,Who) VALUES(@TableName,@Method,@Who)", connection)
        cmdInsertMain.Parameters.Add("TableName", SqlDbType.VarChar).Value = TableName
        cmdInsertMain.Parameters.Add("Method", SqlDbType.VarChar).Value = Method
        cmdInsertMain.Parameters.Add("Who", SqlDbType.VarChar).Value = Page.User.Identity.Name.ToString()
        cmdInsertMain.ExecuteNonQuery()
        If NewValues IsNot Nothing Then
            Dim cmdGetIdent As SqlCommand = New SqlCommand("SELECT @@Identity", connection)
            Dim Ident As Integer = cmdGetIdent.ExecuteScalar()
            Dim cmdInsertItem As SqlCommand = New SqlCommand("INSERT INTO BaseDataHistoryItem(HistoryID,Name,NewValue,OldValue) VALUES(@HistoryId,@Name,@NewValue,@OldValue)", connection)
            cmdInsertItem.Parameters.Add("HistoryID", SqlDbType.BigInt).Value = Ident
            cmdInsertItem.Parameters.Add("Name", SqlDbType.VarChar)
            cmdInsertItem.Parameters.Add("NewValue", SqlDbType.VarChar)
            cmdInsertItem.Parameters.Add("OldValue", SqlDbType.VarChar)
            For Each Parameter As KeyValuePair(Of String, String) In NewValues
                cmdInsertItem.Parameters("name").Value = Parameter.Key.ToString()
                cmdInsertItem.Parameters("NewValue").Value = IIf(Parameter.Value Is Nothing, DBNull.Value, Parameter.Value)
                cmdInsertItem.Parameters("OldValue").Value = IIf(Oldvalues(Parameter.Key) Is Nothing, DBNull.Value, Oldvalues(Parameter.Key))
                cmdInsertItem.ExecuteNonQuery()
            Next
        End If
        connection.Close()
    End Sub

    Protected Sub rgAffectedTables_DataBound(sender As Object, e As EventArgs) Handles rgAffectedTables.DataBound
        panelAffectedTables.Visible = rgAffectedTables.Items.Count > 0
    End Sub


    Protected Sub TableEditFilter_ApplyExpressions(sender As Object, e As Telerik.Web.UI.RadFilterApplyExpressionsEventArgs) Handles TableEditFilter.ApplyExpressions
        'rgTableEdit.DataBind()
    End Sub

    Protected Sub ApplyFilter_Click(sender As Object, e As EventArgs) Handles ApplyFilter.Click
        TableEditFilter.FireApplyCommand()
        'rgTableEdit.Rebind()

        UI.ScriptManager.RegisterStartupScript(Me, [GetType](), "close", "CloseFilterPopup();", True)
    End Sub
End Class
