Imports System.Management.Automation.Runspaces
Imports System.Collections.ObjectModel

' ([PSID=<>] | [APIName=<>]) [Execute=1]

'DataTypeID	Name	    PSName	Comment
'   1	    String	    string	
'   2	    Integer	    int	
'   3	    Date	    date	date format string
'   4   	Dropdown	string	comma list of values
'   5	    Boolean	    switch	


Partial Class Windows_ExecutePS
    Inherits System.Web.UI.Page

    Dim ShowLocked As Boolean = True

    Private Function GetPSIDbyAPIName(APIName As String) As Integer
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand("SELECT PSID FROM Powershell WHERE APIname=@APIname", connection)
        selectCommand.Parameters.AddWithValue("APIname", APIName)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        connection.Close()
        connection.Dispose()
        If products.Rows.Count <> 1 Then
            Return Nothing
        Else
            Return products(0)("PSID").ToString()
        End If
    End Function

    Protected Sub RGpowershell_DataBound(sender As Object, e As EventArgs) Handles RGpowershell.DataBound
        If Not (Request.QueryString("execute") Is Nothing) AndAlso Request.QueryString("execute").ToString() = "1" Then Execute_Click(sender, e)
    End Sub

    Protected Sub RGpowershell_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles RGpowershell.ItemDataBound
        If TypeOf e.Item Is Telerik.Web.UI.GridDataItem Then
            Dim LockedValue As String = ""
            Dim item As Telerik.Web.UI.GridDataItem = e.Item
            Dim Mandatory As Boolean = (item.DataItem("Mandatory") = 1)
            Dim DefaultValue As Object = item.DataItem("DefaultValue")
            Dim DataTypeID As Integer = item.DataItem("DataTypeID")
            Dim ParamName As String = item.DataItem("paramName").ToString()
            Dim Locked As Boolean = (item.DataItem("Locked").ToString() = "1")
            If IsDBNull(DefaultValue) Then DefaultValue = Nothing

            If Locked Then
                Select Case ParamName.ToUpper()
                    Case "CALLER"
                        LockedValue = User.Identity.Name.ToString()
                    Case "ASSETPSID"
                        LockedValue = PSID.Text
                    Case "CLIENTIP"
                        LockedValue = System.Web.HttpContext.Current.Request.UserHostAddress
                    Case "CONFIRM"
                        LockedValue = (IIf(Confirm.Visible, "Yes", "No"))
                End Select
                e.Item.Display = ShowLocked
            End If
            If Mandatory Then
                Dim div As Label = item("Field").FindControl("Mandatory")
                div.CssClass = "boxred"
            End If
            Select Case DataTypeID
                Case 1 ' string
                    Dim obj As Telerik.Web.UI.RadTextBox = item("Field").FindControl("Field_1")
                    If Locked Then
                        obj.Text = LockedValue
                        obj.ReadOnly = True
                        obj.Attributes.Add("disabled", "disabled")
                    Else
                        If DefaultValue IsNot Nothing Then obj.Text = DefaultValue
                        If Not (Request.QueryString(ParamName) Is Nothing) AndAlso Request.QueryString(ParamName).ToString() <> "" Then obj.Text = Request.QueryString(ParamName)
                    End If
                    obj.Visible = True
                Case 2 ' Integer
                    Dim obj As Telerik.Web.UI.RadNumericTextBox = item("Field").FindControl("Field_2")
                    If Locked Then
                        obj.Text = LockedValue
                        obj.ReadOnly = True
                        obj.Attributes.Add("disabled", "disabled")
                    Else
                        If DefaultValue IsNot Nothing Then obj.Text = DefaultValue
                        If Not (Request.QueryString(ParamName) Is Nothing) AndAlso Request.QueryString(ParamName).ToString() <> "" Then obj.Text = Request.QueryString(ParamName)
                        Dim valueSet As String = item.DataItem("Values").ToString()
                        If valueSet <> "" Then
                            Integer.TryParse(valueSet.Split("-")(0), obj.MinValue)
                            Integer.TryParse(valueSet.Split("-")(1), obj.MaxValue)
                        End If
                    End If
                    obj.NumberFormat.DecimalDigits = 0
                    obj.Visible = True
                Case 3 ' Date
                    Dim obj As Telerik.Web.UI.RadDatePicker = item("Field").FindControl("Field_3")
                    If Locked Then
                        obj.DateInput.Text = LockedValue
                        obj.Enabled = False
                        obj.Attributes.Add("disabled", "disabled")
                    Else
                        obj.DateInput.DateFormat = item.DataItem("Values")
                        obj.DateInput.DisplayDateFormat = obj.DateInput.DateFormat
                        If Not (Request.QueryString(ParamName) Is Nothing) AndAlso Request.QueryString(ParamName).ToString() <> "" Then obj.DateInput.Text = Request.QueryString(ParamName)
                    End If
                    obj.Visible = True
                Case 4 ' Drop Down
                    If DefaultValue Is Nothing Then DefaultValue = ""
                    Dim obj As Telerik.Web.UI.RadDropDownList = item("Field").FindControl("Field_4")
                    If Locked Then
                        obj.Enabled = False
                        obj.Attributes.Add("disabled", "disabled")
                    Else
                        Dim defvalue As String = ""
                        If Not (Request.QueryString(ParamName) Is Nothing) AndAlso Request.QueryString(ParamName).ToString() <> "" Then defvalue = Request.QueryString(ParamName).ToString().ToUpper()
                        If Not Mandatory Then
                            obj.Items.Add("")
                        End If
                        For Each Str As String In item.DataItem("Values").ToString().Split(",")
                            obj.Items.Add(Str)
                            obj.Items(obj.Items.Count - 1).Selected = ((Str.ToUpper() = DefaultValue.ToString().ToUpper()) Or (Str.ToUpper() = defvalue))
                        Next
                    End If
                    obj.Visible = True
                Case 5 ' boolean
                    If DefaultValue Is Nothing Then DefaultValue = ""
                    Dim obj As Telerik.Web.UI.RadDropDownList = item("Field").FindControl("Field_5")
                    If Locked Then
                        obj.Items.Add("No")
                        obj.Items.Add("Yes")
                        obj.SelectedText = IIf(LockedValue = "", "No", LockedValue)
                        obj.Attributes.Add("disabled", "disabled")
                    Else
                        Dim str As String = DefaultValue.ToString().ToUpper()
                        If Not (Request.QueryString(ParamName) Is Nothing) AndAlso Request.QueryString(ParamName).ToString() <> "" Then str = Request.QueryString(ParamName)
                        If str = "YES" Or str = "1" Or str = "TRUE" Then
                            obj.Items.Add("Yes")
                            obj.Items.Add("No")
                        Else
                            obj.Items.Add("No")
                            obj.Items.Add("Yes")
                        End If
                        obj.Items(0).Selected = True
                    End If
                    obj.Visible = True
            End Select
        End If
    End Sub

    'DataTypeID	Name	    PSName	Comment
    '   1	    String	    string	
    '   2	    Integer	    int	
    '   3	    Date	    date	date format string
    '   4   	Dropdown	string	comma list of values
    '   5	    Boolean	    switch	
    Private Sub ExecuteScript(Optional confirmed As Boolean = False)
        Dim Debugging As Boolean = False
        ConfirmText.Text = ""
        ConfirmImg.Visible = False
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM Powershell WHERE PSID=@PSID", Conn)
        cmd.Parameters.AddWithValue("PSID", PSID.Text)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read() Then
            Dim parmstr As String = ""
            For Each item As Telerik.Web.UI.GridDataItem In RGpowershell.Items
                'Dim lbl As Label = item.FindControl("lblParamName")
                Dim ParamName As String = item.Item("ParamName").Text
                Dim DataTypeID As Integer = item.Item("DataTypeID").Text
                Dim value As String = ""
                Select Case DataTypeID
                    Case 1 ' string
                        value = DirectCast(item("Field").FindControl("Field_1"), Telerik.Web.UI.RadTextBox).Text
                        If value.Length > 0 AndAlso value <> "''" Then parmstr = String.Format("{0} -{1} '{2}'", parmstr, ParamName, value)
                    Case 2 ' Integer
                        value = DirectCast(item("Field").FindControl("Field_2"), Telerik.Web.UI.RadNumericTextBox).Text
                        If value.Length > 0 AndAlso value <> "''" Then parmstr = String.Format("{0} -{1} {2}", parmstr, ParamName, value)
                    Case 3 ' Date
                        Dim obj As Object = DirectCast(item("Field").FindControl("Field_3"), Telerik.Web.UI.RadDatePicker).DbSelectedDate
                        If obj IsNot Nothing Then
                            value = DirectCast(obj, DateTime).ToString(item.Item("Values").Text)
                            If value.Length > 0 AndAlso value <> "''" Then parmstr = String.Format("{0} -{1} '{2}'", parmstr, ParamName, value)
                        End If
                    Case 4 ' drop down
                        value = DirectCast(item("Field").FindControl("Field_4"), Telerik.Web.UI.RadDropDownList).SelectedText
                        If value.Length > 0 AndAlso value <> "''" Then parmstr = String.Format("{0} -{1} '{2}'", parmstr, ParamName, value)
                    Case 5 ' boolean as dropdown
                        If confirmed AndAlso ParamName.ToUpper() = "CONFIRM" Then
                            value = "Yes"
                        Else
                            value = DirectCast(item("Field").FindControl("Field_5"), Telerik.Web.UI.RadDropDownList).SelectedText
                        End If
                        If value.Length > 0 AndAlso value = "Yes" Then parmstr = String.Format("{0} -{1}", parmstr, ParamName)
                End Select
            Next
            Select Case reader("ExecModeID").ToString()
                Case "2"
                    parmstr = parmstr + " -verbose"
                Case "3"
                    parmstr = parmstr + " -debug"
                    Debugging = True
                Case "4"
                    parmstr = parmstr + " -verbose -debug"
                    Debugging = True
            End Select

            Dim output As DataTable = New DataTable()
            output.Columns.Add("RowID", GetType(System.Int32))
            output.Columns.Add("Text", GetType(System.String))
            output.Columns.Add("Table", GetType(System.Data.DataTable))
            output.Columns.Add("ToolTip", GetType(System.String))

            Dim msg As DataTable = New DataTable()
            msg.Columns.Add("Type", GetType(System.String))
            msg.Columns.Add("Message", GetType(System.String))
            msg.Columns.Add("Line", GetType(System.Int64))
            msg.Columns.Add("Script", GetType(System.String))

            Dim Exec As IPPlanPowershell = New IPPlanPowershell(String.Format(". {0}\\{1} {2}", reader("Location").ToString(), reader("ScriptName").ToString(), parmstr), reader("Hostname").ToString(), reader("Username").ToString(), reader("Password").ToString(), False)
            If Exec.Result = IPPlanPowershell.PSResultCode.ok Then
                'output.Rows.Add(New Object() {output.Rows.Count, Exec.ExecuteString, Nothing, ""})
                If Exec.PSResult IsNot Nothing Then
                    For Each PSObj As System.Management.Automation.PSObject In Exec.PSResult
                        If PSObj IsNot Nothing Then
                            If PSObj.TypeNames(0).ToString().StartsWith("System.") Then
                                output.Rows.Add(New Object() {output.Rows.Count, PSObj.ToString(), Nothing, String.Join(vbCrLf, PSObj.TypeNames.ToArray())})
                            ElseIf PSObj.TypeNames(0).ToString().StartsWith("Deserialized.") Then
                                Dim idx As Integer = PSObj.TypeNames(0).ToString().LastIndexOf(".") + 1
                                ProcessPSObject(output, PSObj.TypeNames(0).ToString().Substring(idx), PSObj)
                            End If
                        End If
                    Next
                    msg.Rows.Add(New Object() {"Execute", Exec.ExecuteString, 0, "."})
                    For Each dbg As System.Management.Automation.DebugRecord In Exec.PowerShell.Streams.Debug
                        msg.Rows.Add(New Object() {"Debug", dbg.Message, dbg.InvocationInfo.ScriptLineNumber, dbg.InvocationInfo.InvocationName})
                    Next
                    For Each vb As System.Management.Automation.VerboseRecord In Exec.PowerShell.Streams.Verbose
                        msg.Rows.Add(New Object() {"Verbose", vb.Message, vb.InvocationInfo.ScriptLineNumber, vb.InvocationInfo.InvocationName})
                    Next
                    For Each wrn As System.Management.Automation.WarningRecord In Exec.PowerShell.Streams.Warning
                        msg.Rows.Add(New Object() {"Warning", wrn.Message, wrn.InvocationInfo.ScriptLineNumber, wrn.InvocationInfo.InvocationName})
                    Next
                    For Each Err As System.Management.Automation.ErrorRecord In Exec.PowerShell.Streams.Error
                        msg.Rows.Add(New Object() {"Error", Err.ToString(), Err.InvocationInfo.ScriptLineNumber, Err.InvocationInfo.InvocationName})
                    Next
                End If
                If Exec.Host.ConfirmText.Length > 0 Then
                    Confirm.Visible = True
                    ConfirmImg.Visible = True
                    ConfirmText.Text = Exec.Host.ConfirmText.Replace(vbCr, "<br>")
                    Confirm.Text = Exec.Host.ConfirmButton
                    Select Case Exec.Host.ConfirmIcon.ToUpper()
                        Case "?"
                            ConfirmImg.ImageUrl = "/Images/Question_32x32.png"
                        Case "!"
                            ConfirmImg.ImageUrl = "/Images/Error_32x32.png"
                        Case "X"
                            ConfirmImg.ImageUrl = "/Images/Cancel_32x32.png"
                    End Select
                End If

                If output.Rows.Count > 1 Then
                    TabStrip.SelectedIndex = 0
                    Multipage.SelectedIndex = 0
                Else
                    TabStrip.SelectedIndex = 1
                    Multipage.SelectedIndex = 1
                End If

                PSOutput.DataSource = output
                PSOutput.DataBind()

                If Debugging Then
                    PSMessage.DataSource = msg
                    PSMessage.DataBind()
                End If
                View2.Visible = Debugging
                TabStrip.Tabs(1).Visible = Debugging

                exceptionPanel.Visible = False
            Else
                pnlResult.CssClass = "boxred"
                Exception.Text = Exec.ExecuteString + vbCrLf + Exec.HTMLResult
                exceptionPanel.Visible = True
            End If

            sdsPowershell.InsertParameters("who").DefaultValue = Page.User.Identity.Name
            sdsPowershell.InsertParameters("PSID").DefaultValue = PSID.Text
            sdsPowershell.InsertParameters("Params").DefaultValue = Exec.ExecuteString
            sdsPowershell.InsertParameters("ResultCode").DefaultValue = Exec.Result
            sdsPowershell.Insert()
        End If
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        If Not IsPostBack Then
            ShowLocked = (Request.QueryString("ShowLocked") IsNot Nothing) AndAlso Request.QueryString("ShowLocked").ToString() = "1"
            If Not (Request.QueryString("PSID") Is Nothing) AndAlso Request.QueryString("PSID").ToString() <> "" Then PSID.Text = Request.QueryString("PSID").ToString()
            If Not (Request.QueryString("APIName") Is Nothing) AndAlso Request.QueryString("APIName").ToString() <> "" Then PSID.Text = GetPSIDbyAPIName(Request.QueryString("APIName").ToString())

            If PSID.Text = "" Then PSID.Text = "4"
        End If
    End Sub

    Protected Sub Execute_Click(sender As Object, e As EventArgs) Handles Execute.Click
        pnlSetup.Visible = False
        pnlResult.Visible = True
        ExecuteScript()
    End Sub

    Protected Sub Close_Click(sender As Object, e As EventArgs) Handles Close.Click
        pnlSetup.Visible = True
        pnlResult.Visible = False
    End Sub

    Protected Sub Confirm_Click(sender As Object, e As EventArgs) Handles Confirm.Click
        pnlSetup.Visible = False
        pnlResult.Visible = True
        Confirm.Visible = False
        ConfirmText.Text = ""
        ExecuteScript(True)
    End Sub


    Private Sub ProcessPSObject(Tables As DataTable, TableName As String, PSObj As System.Management.Automation.PSObject)
        Dim TempTable As DataTable = Nothing
        For Each row As DataRow In Tables.Rows
            If row("text").ToString() = "£" + TableName Then
                TempTable = row("Table")
            End If
        Next
        If TempTable Is Nothing Then
            TempTable = New DataTable()
            Tables.Rows.Add(New Object() {Tables.Rows.Count, "£" + TableName, TempTable, String.Join(vbCrLf, PSObj.TypeNames.ToArray())})
            For Each prop As System.Management.Automation.PSPropertyInfo In PSObj.Properties
                TempTable.Columns.Add(prop.Name)
            Next
        End If
        Dim WorkRow As DataRow = TempTable.NewRow()
        For Each prop As System.Management.Automation.PSPropertyInfo In PSObj.Properties
            WorkRow(prop.Name) = prop.Value
        Next
        TempTable.Rows.Add(WorkRow)
    End Sub

    Protected Sub PSOutput_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles PSOutput.ItemDataBound
        If e.Item.ItemType = Telerik.Web.UI.GridItemType.Item Or e.Item.ItemType = Telerik.Web.UI.GridItemType.AlternatingItem Then
            Dim item As Telerik.Web.UI.GridDataItem = e.Item
            Dim Text As Label = DirectCast(item("Field").FindControl("Text"), Label)
            Dim dataset As Telerik.Web.UI.RadGrid = item("Field").FindControl("DataSet")
            If IsDBNull(e.Item.DataItem("Table")) Then
                Text.Visible = True
                Text.Text = e.Item.DataItem("Text")
                dataset.Visible = False
            Else
                Text.Visible = False
                dataset.Visible = True
                dataset.DataSource = DirectCast(item.DataItem("Table"), DataTable)
                dataset.MasterTableView.DataSource = DirectCast(item.DataItem("Table"), DataTable)
                dataset.DataBind()
            End If
        End If
    End Sub

End Class
