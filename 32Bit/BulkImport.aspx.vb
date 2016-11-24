
Imports System.DirectoryServices
Imports System.DirectoryServices.AccountManagement
Imports System.Data.OleDb
Imports System.Data
Imports System.IO

Partial Class BulkImport
    Inherits System.Web.UI.Page
    Dim adUser As DirectoryEntry
    Public IPPlanConfig As IPPlanV4Config = New IPPlanV4Config(User.Identity.Name)

#Region "Private functions"
    Protected Function GetUserName() As String
        Return adUser.Properties("mail").Value.ToString()
    End Function

    Private Function isUserMemberOf(appSettingName As String) As Boolean
        Return Page.User.IsInRole(ConfigurationManager.AppSettings(appSettingName).ToString())
    End Function

    Protected Function toBool(str As String) As Boolean
        toBool = False
        Boolean.TryParse(str, toBool)
    End Function

    Protected Function GetIntDefault(Str As String, DefValue As Integer) As Integer
        GetIntDefault = DefValue
        Integer.TryParse(Str, GetIntDefault)
    End Function

    Private Function HostnameExists(Hostname As String) As Boolean
        If Hostname.Trim() = "" Then
            HostnameExists = False
        Else
            Dim dbconn As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
            dbconn.Open()
            Dim sqlcmd As SqlCommand = New SqlCommand("SELECT 1 FROM HostExtraData WHERE Hostname ='" + Hostname + "'", dbconn)
            sqlcmd.CommandType = CommandType.Text
            Dim dr As SqlDataReader = sqlcmd.ExecuteReader()
            HostnameExists = dr.HasRows
            dbconn.Close()
            dbconn.Dispose()
        End If
    End Function

    Private Function EMailExists(EMailAddress As String) As Boolean
        Dim RootEntry As DirectoryEntry = New DirectoryEntry(IPPlanConfig.IPPlan("AD:CountryRoot", "LDAP://OU=Countries,OU=DSV.COM,DC=DSV,DC=COM"))
        Dim searcher As New DirectorySearcher(RootEntry)
        searcher.PropertiesToLoad.Add("cn")
        searcher.PropertiesToLoad.Add("mail")
        searcher.Filter = String.Format(IPPlanConfig.IPPlan("AD:UserValidation", "(&(objectCategory=person)(|(proxyAddresses=SMTP:{0})(proxyAddresses=smtp:{0})(userPrincipalName={0})(samAccountName={0})))"), EMailAddress)
        Dim results As SearchResultCollection = searcher.FindAll()
        Return results.Count = 0
    End Function
#End Region

#Region "Page"
    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        username.Text = User.Identity.Name
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
        End If
    End Sub
#End Region

#Region "Upload"
    Private Sub ProcessUploadedExcel(ExcelPath As String)
        Dim oledbConn As OleDbConnection = New OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ExcelPath + ";Extended Properties='Excel 12.0;HDR=YES;IMEX=1;';")
        oledbConn.Open()
        Dim oledbcmd As OleDbCommand = New OleDbCommand("SELECT Version,[Date] FROM [Base Data$] WHERE ID=1", oledbConn)
        oledbcmd.CommandType = CommandType.Text
        Dim oledbDataAdapter = New OleDbDataAdapter(oledbcmd)
        Dim ds As DataSet = New DataSet()
        Try
            oledbDataAdapter.Fill(ds, "BaseData")
            If ds.Tables("BaseData").Rows.Count <> 1 Then
                Throw New Exception("Was not able to read 1 line of base data")
            End If
            Dim version As String = ds.Tables("BaseData").Rows(0)("Version")
            Dim datestamp As String = ds.Tables("BaseData").Rows(0)("Date")
            pnlUpload.Controls.Add(New LiteralControl("Importing Version " + version + ". Template Date " + datestamp + "<br/>"))

            oledbcmd.CommandText = "SELECT [Hostname],[Function],[Function Alias],[Service*],[Backup*],[Location],[Country*],[Assigned IP],[Environment*],[Operational Mode*],[Application Name*],[Application ID],[Contact],[Responsible],[Owner],[Management IP],[Asset Tag] FROM [Import$]"
            Try
                Dim i As Integer = 0
                oledbDataAdapter.Fill(ds, "Import")
                For Each row As DataRow In ds.Tables("Import").Rows
                    i = i + 1
                    If Not (row("Hostname").ToString().StartsWith("#") Or row("Hostname").ToString().ToUpper() = "EXAMPLE") Then
                        sdsHostImport.InsertParameters("Hostname").DefaultValue = row("Hostname").ToString().Trim()
                        sdsHostImport.InsertParameters("Function").DefaultValue = row("Function").ToString().Trim()
                        sdsHostImport.InsertParameters("FunctionAlias").DefaultValue = row("Function Alias").ToString().Trim()
                        sdsHostImport.InsertParameters("Service").DefaultValue = row("Service*").ToString().Trim()
                        sdsHostImport.InsertParameters("Backup").DefaultValue = row("Backup*").ToString().Trim()
                        sdsHostImport.InsertParameters("Location").DefaultValue = row("Location").ToString().Trim()
                        sdsHostImport.InsertParameters("Country").DefaultValue = row("Country*").ToString().Trim()
                        sdsHostImport.InsertParameters("AssignedIP").DefaultValue = row("Assigned IP").ToString().Trim()
                        sdsHostImport.InsertParameters("Environment").DefaultValue = row("Environment*").ToString().Trim()
                        sdsHostImport.InsertParameters("OperationalMode").DefaultValue = row("Operational Mode*").ToString().Trim()
                        If row("Application Name*").ToString().Trim() <> "" Then
                            sdsHostImport.InsertParameters("Application").DefaultValue = row("Application Name*").ToString().Trim()
                        Else
                            sdsHostImport.InsertParameters("Application").DefaultValue = row("Application ID").ToString().Trim()
                        End If
                        sdsHostImport.InsertParameters("Contact").DefaultValue = row("Contact").ToString().Trim()
                        sdsHostImport.InsertParameters("Responsible").DefaultValue = row("Responsible").ToString().Trim()
                        sdsHostImport.InsertParameters("Owner").DefaultValue = row("Owner").ToString().Trim()
                        sdsHostImport.InsertParameters("ManagementIP").DefaultValue = row("Management IP").ToString().Trim()
                        sdsHostImport.InsertParameters("AssetTag").DefaultValue = row("Asset Tag").ToString().Trim()
                        sdsHostImport.Insert()
                    Else
                        pnlUpload.Controls.Add(New LiteralControl("Line " + i.ToString() + " was skipped<br/>"))
                    End If
                Next
            Catch ex As Exception
                Throw New Exception("Was not able to read excel, have you messed with the headlines on the Import sheet? <br>" + ex.Message.ToString())
            End Try
        Catch ex As Exception
            Throw New Exception("Was not able to read excel, have you messed with the data on the 'Base Data' sheet? <br>" + ex.Message.ToString())
        End Try
        oledbConn.Close()
        oledbConn.Dispose()
    End Sub

    Private Function CheckFilename(Filename As String) As DateTime ' nothing = file is allowed to upload
        sdsHostImportFilename.SelectParameters("Filename").DefaultValue = Filename
        Dim dv As DataView = DirectCast(sdsHostImportFilename.Select(DataSourceSelectArguments.Empty), DataView)
        If dv.Count = 0 Then
            CheckFilename = Nothing
            sdsHostImportFilename.InsertParameters("Filename").DefaultValue = Filename
            sdsHostImportFilename.Insert()
        Else
            CheckFilename = dv.Item(0)("ImportDate")
        End If
        dv = Nothing
    End Function

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Try
            Dim ExcelPath As String = Server.MapPath(IPPlanConfig.IPPlan("UploadPath", "/BulkImport/") + Now.ToString("yyyyMMddhhmmss.xlsx"))
            If fuExcelUpload.HasFile Then
                Dim FileUploadedEalier As DateTime = CheckFilename(fuExcelUpload.FileName)
                If FileUploadedEalier = Nothing Then
                    fuExcelUpload.SaveAs(ExcelPath)
                    ProcessUploadedExcel(ExcelPath)
                    lblUpload.Text = "Uploaded successfully"
                Else
                    lblUpload.Text = "This file have allready been uploaded on the " + FileUploadedEalier.ToString("yyyy-MM-dd") + ". Please rename the file if you are 100% sure this havnt been uploaded before"
                End If
            End If
            'System.IO.File.Delete(excelpath)
        Catch ex As Exception
            lblUpload.Text = ex.Message.ToString()
        End Try
    End Sub

    Private Function DownloadData(excelcmd As OleDbCommand, SQLCmd As String, Column As String) As Integer
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString)
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand(SQLCmd, Conn)
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        Dim i As Integer = 1
        While reader.Read()
            excelcmd.CommandText = "UPDATE [Base Data$] SET [" + Column + "]='" + reader(0).ToString() + "' WHERE ID=" + i.ToString()
            excelcmd.ExecuteNonQuery()
            i = i + 1
        End While
        reader.Close()
        Conn.Close()
        Conn.Dispose()
        Return i
    End Function


    Protected Sub lnkDownload_Click(sender As Object, e As EventArgs) Handles lnkDownload.Click
        Dim BulkImportDownloadFilename = IPPlanConfig.IPPlan("BulkImportDownloadFilename", "/BulkImport/IPPlanHostImport.xlsx")
        Dim BulkImportDownloadFilenameServer = Server.MapPath(BulkImportDownloadFilename)
        System.IO.File.Copy(Server.MapPath(IPPlanConfig.IPPlan("BulkImportTemplate", "/BulkImport/IPPlanHostImport_Template.xlsx")), BulkImportDownloadFilenameServer, True)
        Dim oledbConn As OleDbConnection = New OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + BulkImportDownloadFilenameServer + ";Extended Properties='Excel 12.0;HDR=NO;IMEX=0';")
        oledbConn.Open()
        Dim oledbcmd As OleDbCommand = New OleDbCommand()
        oledbcmd.CommandType = CommandType.Text
        oledbcmd.Connection = oledbConn

        oledbcmd.CommandText = "UPDATE [Base Data$] SET [Version]=" + IPPlanConfig.IPPlan("Import:ExcelVersion", "1") + " WHERE ID=1"
        oledbcmd.ExecuteNonQuery()

        oledbcmd.CommandText = "UPDATE [Base Data$] SET [Date]='" + Now().ToString("yyyy.MM.dd") + "' WHERE ID=1"
        oledbcmd.ExecuteNonQuery()

        'C=Service	D=Backup	E=Country	F=Environment	G=Operational Mode	H=Application
        Dim MaxRows As Integer = 0
        MaxRows = Math.Max(DownloadData(oledbcmd, "SELECT ServiceShortName FROM MasterService", "Service"), MaxRows)
        MaxRows = Math.Max(DownloadData(oledbcmd, "SELECT BackupType FROM MasterBackup", "Backup"), MaxRows)
        MaxRows = Math.Max(DownloadData(oledbcmd, "SELECT ISO2 FROM Country WHERE ArsEnabled=1", "Country"), MaxRows)
        MaxRows = Math.Max(DownloadData(oledbcmd, "SELECT EnvironmentName FROM IPPlanEnvironment", "Environment"), MaxRows)
        MaxRows = Math.Max(DownloadData(oledbcmd, "SELECT OperationalMode FROM IPPlanOperationMode WHERE Visible=1", "Operational Mode"), MaxRows)
        MaxRows = Math.Max(DownloadData(oledbcmd, "SELECT Name FROM ApplicationList WHERE [_status]=1 or [_status]=4", "Application"), MaxRows)

        oledbConn.Close()
        oledbConn.Dispose()
        Response.Redirect(BulkImportDownloadFilename.Replace("\", "/"))
    End Sub


#End Region

#Region "dvHostImport"

    Private Function ValidateControl(Control As WebControl, Value As String, Name As String) As Boolean ' true = errors found
        Dim ErrorString As String = ""
        ValidateControl = False
        Select Case Control.GetType()
            Case GetType(Label)
            Case GetType(TextBox)
                Select Case Name.ToLower()
                    Case "hostname"
                        ValidateControl = HostnameExists(Value)
                        If ValidateControl Then ErrorString = Value + " already exists."
                    Case "owner"
                        ValidateControl = EMailExists(Value)
                        If ValidateControl Then ErrorString = Value + " dont exists."
                    Case "responsible"
                        ValidateControl = EMailExists(Value)
                        If ValidateControl Then ErrorString = Value + " dont exists."
                    Case "contact"
                        ValidateControl = EMailExists(Value)
                        If ValidateControl Then ErrorString = Value + " dont exists."
                End Select
                If ValidateControl Then
                    Control.Attributes.Add("title", ErrorString)
                Else
                    Control.Attributes.Remove("title")
                End If
            Case GetType(DropDownList)
                Dim ddl As DropDownList = DirectCast(Control, DropDownList)
                Dim si As ListItem = ddl.SelectedItem
                If ddl.ID = "ctlApplication" Then
                    ValidateControl = False
                Else
                    ValidateControl = (si.Value = si.Text)
                End If
                If ValidateControl Then
                    ErrorString = Name + " have an illegal value"
                    Control.Attributes.Add("title", ErrorString)
                Else
                    Control.Attributes.Remove("title")
                End If
        End Select
        If Control.Parent.GetType() Is GetType(Label) Then
            If ValidateControl Then
                DirectCast(Control.Parent, Label).CssClass = "boxred"
                DirectCast(Control.Parent, Label).ToolTip = ErrorString
            Else
                DirectCast(Control.Parent, Label).CssClass = ""
                DirectCast(Control.Parent, Label).ToolTip = ""
            End If
        End If
    End Function

    Private Sub SetButtons(Container As RepeaterItem, Optional ContainsError As Boolean = False)
        Dim status As Integer = DirectCast(Container.FindControl("ctlStatusID"), DropDownList).SelectedValue
        Container.FindControl("btnSubmit").Visible = ((status >= 100) And (status < 500) And Not ContainsError)
        Container.FindControl("btnApprove").Visible = ((status >= 500) And (status < 900) And Not ContainsError) ' and user isInRole(Approver)
        Container.FindControl("btnDelete").Visible = ((status >= 100) And (status < 500))
        Container.FindControl("btnReject").Visible = ((status >= 500) And (status < 900)) ' and user isInRole(Approver)
    End Sub

    Private Function HandleControl(wctl As WebControl, DataRow As System.Data.DataRowView, Container As RepeaterItem) As Boolean ' Contains Errors
        HandleControl = False
        If wctl.HasControls Then
            For Each Control In wctl.Controls
                If TypeOf Control Is WebControl Then HandleControl = HandleControl Or HandleControl(DirectCast(Control, WebControl), DataRow, Container)
            Next
        End If
        If wctl.ID IsNot Nothing Then
            If (wctl.ID.StartsWith("ctl")) Then
                Dim ControlValue As Object = DataRow.Row(wctl.ID.Substring(3))
                If IsDBNull(ControlValue) Then ControlValue = String.Empty
                Select Case wctl.GetType()
                    Case GetType(Label)
                        Dim lbl As Label = DirectCast(wctl, Label)
                        lbl.Text = ControlValue
                    Case GetType(TextBox)
                        Dim teb As TextBox = DirectCast(wctl, TextBox)
                        teb.Text = ControlValue
                        teb.AutoPostBack = True
                    Case GetType(DropDownList)
                        Dim ddl As DropDownList = DirectCast(wctl, DropDownList)
                        ddl.AutoPostBack = True
                        Dim li As ListItem = ddl.Items.FindByValue(ControlValue)
                        If li Is Nothing Then li = ddl.Items.FindByText(ControlValue)
                        If li Is Nothing Then
                            ddl.Items.Add(ControlValue)
                            ddl.SelectedValue = ControlValue
                        Else
                            ddl.SelectedValue = li.Value
                        End If
                End Select
                HandleControl = HandleControl Or ValidateControl(wctl, ControlValue, wctl.ID.Substring(3))
            End If
        End If
    End Function

    Protected Sub rpHostImport_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        ' TODO: Make readonly etc when not editable
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim Status As Integer = DirectCast(e.Item.DataItem, System.Data.DataRowView).Item("StatusID")
            Dim ContainsError As Boolean = False
            For Each ctl In e.Item.Controls
                If TypeOf ctl Is WebControl Then ContainsError = ContainsError Or HandleControl(DirectCast(ctl, WebControl), DirectCast(e.Item.DataItem, System.Data.DataRowView), e.Item)
            Next
            SetButtons(e.Item, ContainsError)
        End If
    End Sub

    Protected Sub ctlddl_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = DirectCast(sender, DropDownList)
        Dim ContainsError As Boolean = ValidateControl(ddl, ddl.SelectedValue, ddl.ID.Substring(3))
        SetButtons(ddl.Parent.Parent, ContainsError)
    End Sub

    Protected Sub ctlTeb_TextChanged(sender As Object, e As EventArgs)
        ValidateControl(sender, DirectCast(sender, TextBox).Text, DirectCast(sender, TextBox).ID.Substring(3))
    End Sub


    Private Sub SetSqlParameters(Collection As ParameterCollection, Control As Control)
        If Control.HasControls Then
            For Each subcontrol In Control.Controls
                SetSqlParameters(Collection, subcontrol)
            Next
        End If
        If Control.ID IsNot Nothing Then
            If (Control.ID.StartsWith("ctl")) Then
                Dim ParameterName As String = Control.ID.Substring(3)
                If Collection(ParameterName) IsNot Nothing Then
                    Select Case Control.GetType()
                        Case GetType(Label)
                            Collection(ParameterName).DefaultValue = DirectCast(Control, Label).Text
                        Case GetType(TextBox)
                            Collection(ParameterName).DefaultValue = DirectCast(Control, TextBox).Text
                        Case GetType(DropDownList)
                            Collection(ParameterName).DefaultValue = DirectCast(Control, DropDownList).SelectedValue
                    End Select
                End If
            End If
        End If
    End Sub

    Private Function TransferToHostExtraData(RequestID As Integer) As Boolean ' True = Transfer Completed ok
        Dim dbconn As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        dbconn.Open()
        Dim cmd As SqlCommand = New SqlCommand("Execute-HostImport", dbconn)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.AddWithValue("RequestID", RequestID)
        cmd.Parameters.AddWithValue("Approver", Page.User.Identity.Name)
        cmd.Parameters.AddWithValue("NetworkZone", 0)
        Dim res As Boolean = (cmd.ExecuteScalar() = 0)
        dbconn.Close()
        dbconn.Dispose()
        Return res
    End Function

    Protected Sub rpHostImport_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rpHostImport.ItemCommand
        Select Case e.CommandName
            Case "Save"
                SetSqlParameters(sdsHostImport.UpdateParameters, e.Item)
                sdsHostImport.Update()
            Case "Submit"
                SetSqlParameters(sdsHostImport.UpdateParameters, e.Item)
                sdsHostImport.Update()
                SetSqlParameters(sdsHostImport.DeleteParameters, e.Item)
                sdsHostImport.DeleteParameters("StatusID").DefaultValue = 500 ' Job will take this to 501 and notify it.help that approval is needed
                sdsHostImport.Delete() ' this is not actually delete but update of the status
            Case "Approve"
                SetSqlParameters(sdsHostImport.UpdateParameters, e.Item)
                sdsHostImport.Update()
                ' TransferToHostExtradata ecevutes dbo.Execute-HostImport which sets status to 900 unless somethings goes wrong
                If Not TransferToHostExtraData(sdsHostImport.UpdateParameters("ImportRequest").DefaultValue) Then
                    sdsHostImport.DeleteParameters("StatusID").DefaultValue = 951 ' Job will take this to 200 and notify user that enty couldnt be transfered
                    sdsHostImport.Delete() ' this is not actually delete but update of the status
                End If
            Case "Delete"
                SetSqlParameters(sdsHostImport.UpdateParameters, e.Item)
                sdsHostImport.Update()
                SetSqlParameters(sdsHostImport.DeleteParameters, e.Item)
                sdsHostImport.DeleteParameters("StatusID").DefaultValue = 998
                sdsHostImport.Delete() ' this is not actually delete but update of the status
            Case "Reject"
                SetSqlParameters(sdsHostImport.UpdateParameters, e.Item)
                sdsHostImport.Update()
                SetSqlParameters(sdsHostImport.DeleteParameters, e.Item)
                sdsHostImport.DeleteParameters("StatusID").DefaultValue = 950 ' Job will take this back to 200 and notify user that entries have been rejected
                sdsHostImport.Delete() ' this is not actually delete but update of the status
        End Select
    End Sub


#End Region

End Class
