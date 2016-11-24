<%@ Page Language="VB" AutoEventWireup="false" CodeFile="BulkImport.aspx.vb" Inherits="BulkImport" Title="Bulk Import" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<link href="/styles/default.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:TextBox runat="server" ID="username" Visible="false" Text="" />
    <div>
        <asp:Panel ID="pnlUpload" runat="server" Visible="true">
            <asp:FileUpload ID="fuExcelUpload" runat="server"/><asp:Button ID="btnUpload" runat="server" Text="Upload" /><asp:Label ID="lblUpload" runat="server" Text="" /><br />
            <asp:LinkButton ID="lnkDownload" runat="server" Text="Download excel template" />
        </asp:Panel>
        <asp:Repeater ID="rpHostImport" runat="server" DataSourceID="sdsHostImport" DataMember="" OnItemDataBound="rpHostImport_ItemDataBound">
            <HeaderTemplate>
                <table width="100%" class="gridview" cellspacing="0">
                    <tr class="header">
                        <th>Request</th>
                        <th>Status</th>
                        <th>Hostname</th>
                        <th>Function</th>
                        <th>Alias</th>
                        <th>Service</th>
                        <th>Backup</th>
                        <th>Environment</th>
                        <th>OperationalMode</th>
                        <th>AssignedIP</th>
                        <th>ManagementIP</th>
                    </tr>
                    <tr class="header">
                        <th></th>
                        <th></th>
                        <th>Location/City</th>
                        <th colspan="2">Country</th>
                        <th colspan="2">Application</th>
                        <th>Contact</th>
                        <th>Responsible</th>
                        <th>Owner</th>
                        <th>AssetTag</th>
                    </tr>
                    <tr class="header">
                        <th></th>
                        <th></th>
                        <th colspan="9">Comment</th>
                    </tr>
            </HeaderTemplate>
            <AlternatingItemTemplate>
                <tr class="row">
                    <td><asp:Label runat="server"><asp:Label ID="ctlImportRequest" runat="server" Width="98%"/></asp:Label></td><td><asp:Label runat="server"><asp:DropDownList ID="ctlStatusID" runat="server" DataSourceID="sdsHostImportStatus" DataTextField="Description" DataValueField="StatusID" Enabled="false" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlHostname" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged" /></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlFunction" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlFunctionAlias" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:DropDownList ID="ctlService" runat="server" DataSourceID="sdsMasterService" DataTextField="ServiceShortName" DataValueField="ServiceID" Width="98%"  OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:DropDownList ID="ctlBackup" runat="server" DataSourceID="sdsMasterBackup" DataTextField="BackupType" DataValueField="BackupID" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:DropDownList ID="ctlEnvironment" runat="server" DataSourceID="sdsIPPlanEnvironment" DataTextField="EnvironmentName" DataValueField="EnvironmentID" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:DropDownList ID="ctlOperationalMode" runat="server" DataSourceID="sdsIPPlanOperationMode" DataTextField="OperationalMode" DataValueField="ID" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlAssignedIP" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlManagementIP" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td></tr><tr class="row">
                    <td><asp:LinkButton runat="server" ID="btnSave" Text="Save" CommandName="Save" CommandArgument='<%# Eval("ImportRequest")%>' /></td>
                    <td></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlLocation" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td colspan="2"><asp:Label runat="server"><asp:DropDownList ID="ctlCountry" runat="server" DataSourceID="sdsCountry" DataTextField="Name" DataValueField="ISO2" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td colspan="2"><asp:Label runat="server"><asp:DropDownList ID="ctlApplication" runat="server" DataSourceID="sdsApplicationList" DataTextField="Name" DataValueField="AppNumber" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlContact" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlResponsible" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlOwner" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlAssetTag" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td></tr><tr class="row">
                    <td>
                        <asp:LinkButton runat="server" ID="btnSubmit" Text="Submit" CommandName="Submit" CommandArgument='<%# Eval("ImportRequest")%>' />
                        <asp:LinkButton runat="server" ID="btnApprove" Text ="Approve" CommandName="Approve" CommandArgument='<%# Eval("ImportRequest")%>' />
                    </td>
                    <td>
                        <asp:LinkButton runat="server" ID="btnDelete" Text="Remove" CommandName="Delete" CommandArgument='<%# Eval("ImportRequest")%>' />
                        <asp:LinkButton runat="server" ID="btnReject" Text="Reject" CommandName="Reject" CommandArgument='<%# Eval("ImportRequest")%>' />
                    </td>
                    <td colspan="9"><asp:TextBox ID="ctlComment" runat="server" MaxLength="200" Width="98%"/></td>
                </tr>
            </AlternatingItemTemplate>
            <ItemTemplate>
                <tr class="alternaterow">
                    <td><asp:Label runat="server"><asp:Label ID="ctlImportRequest" runat="server" Width="98%"/></asp:Label></td><td><asp:Label runat="server"><asp:DropDownList ID="ctlStatusID" runat="server" DataSourceID="sdsHostImportStatus" DataTextField="Description" DataValueField="StatusID" Enabled="false" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlHostname" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlFunction" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlFunctionAlias" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:DropDownList ID="ctlService" runat="server" DataSourceID="sdsMasterService" DataTextField="ServiceShortName" DataValueField="ServiceID" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:DropDownList ID="ctlBackup" runat="server" DataSourceID="sdsMasterBackup" DataTextField="BackupType" DataValueField="BackupID" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:DropDownList ID="ctlEnvironment" runat="server" DataSourceID="sdsIPPlanEnvironment" DataTextField="EnvironmentName" DataValueField="EnvironmentID" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:DropDownList ID="ctlOperationalMode" runat="server" DataSourceID="sdsIPPlanOperationMode" DataTextField="OperationalMode" DataValueField="ID" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlAssignedIP" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlManagementIP" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td></tr><tr class="alternaterow">
                    <td><asp:LinkButton runat="server" ID="btnSave" Text="Save" CommandName="Save" CommandArgument='<%# Eval("ImportRequest")%>' /></td>
                    <td></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlLocation" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td colspan="2"><asp:Label runat="server"><asp:DropDownList ID="ctlCountry" runat="server" DataSourceID="sdsCountry" DataTextField="Name" DataValueField="ISO2" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td colspan="2"><asp:Label runat="server"><asp:DropDownList ID="ctlApplication" runat="server" DataSourceID="sdsApplicationList" DataTextField="Name" DataValueField="AppNumber" Width="98%" OnSelectedIndexChanged="ctlddl_SelectedIndexChanged"/></asp:Label></td>
                    <td><asp:Label runat="server"><asp:TextBox ID="ctlContact" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlResponsible" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlOwner" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td><td><asp:Label runat="server"><asp:TextBox ID="ctlAssetTag" runat="server" Width="98%" OnTextChanged="ctlteb_TextChanged"/></asp:Label></td></tr><tr class="alternaterow">
                    <td>
                        <asp:LinkButton runat="server" ID="btnSubmit" Text="Submit" CommandName="Submit" CommandArgument='<%# Eval("ImportRequest")%>' />
                        <asp:LinkButton runat="server" ID="btnApprove" Text ="Approve" CommandName="Approve" CommandArgument='<%# Eval("ImportRequest")%>' />
                    </td>
                    <td>
                        <asp:LinkButton runat="server" ID="btnDelete" Text="Remove" CommandName="Delete" CommandArgument='<%# Eval("ImportRequest")%>' />
                        <asp:LinkButton runat="server" ID="btnReject" Text="Reject" CommandName="Reject" CommandArgument='<%# Eval("ImportRequest")%>' />
                    </td>
                    <td colspan="9"><asp:TextBox ID="ctlComment" runat="server" MaxLength="200" Width="98%"/></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    <tr>
                        <td colspan="11"> Items in red boxes must be corrected before you are able to submit the host for approval</td></tr></table></FooterTemplate></asp:Repeater><asp:SqlDataSource ID="sdsHostImportStatus" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" SelectCommand="SELECT * FROM HostImportStatus" />
        <asp:SqlDataSource ID="sdsMasterBackup" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" SelectCommand="SELECT * FROM MasterBackup" />
        <asp:SqlDataSource ID="sdsCountry" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" SelectCommand="SELECT * FROM Country WHERE ARSEnabled=1" />
        <asp:SqlDataSource ID="sdsIPPlanEnvironment" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" SelectCommand="SELECT * FROM IPPlanEnvironment" />
        <asp:SqlDataSource ID="sdsIPPlanOperationMode" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" SelectCommand="SELECT * FROM IPPlanOperationMode" />
        <asp:SqlDataSource ID="sdsApplicationList" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" SelectCommand="SELECT * FROM ApplicationList  WHERE [_status]=1 or [_status]=4" />
        <asp:SqlDataSource ID="sdsMasterService" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" SelectCommand="SELECT * FROM MasterService" />
        <asp:SqlDataSource ID="sdsHostImportFilename" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true"
            SelectCommand="SELECT * FROM HostImportFilename WHERE Filename=@Filename AND Importer=@Username ORDER BY ImportDate DESC"
            InsertCommand="INSERT INTO HostImportFilename([Importer],[Filename]) VALUES(@Username,@Filename)"
            >
            <SelectParameters>
                <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Filename" ConvertEmptyStringToNull="true" Type="String" />
            </SelectParameters>
            <InsertParameters>
                <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Filename" ConvertEmptyStringToNull="true" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsHostImport" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true"
            SelectCommand="SELECT * FROM HostImport WHERE Importer=@Username AND StatusID <800"
            InsertCommand="INSERT INTO HostImport([Importer],[StatusID],[ImportDate],[Hostname],[Function],[FunctionAlias],[Service],[Backup],[Location],[Country],[AssignedIP],[Environment],[OperationalMode],[Application],[Contact],[Responsible],[Owner],[ManagementIP],[AssetTag])
                                        VALUES(@Username,100,getdate(),@Hostname,@Function,@FunctionAlias,@Service,@Backup,@Location,@Country,@AssignedIP,@Environment,@OperationalMode,@Application,@Contact,@Responsible,@Owner,@ManagementIP,@AssetTag)"
            UpdateCommand="UPDATE HostImport SET [StatusID]=@StatusID, [Hostname]=@Hostname,[Function]=@Function,[FunctionAlias]=@FunctionAlias,[Service]=@Service,[Backup]=@Backup,[Location]=@Location,[Country]=@Country,[AssignedIP]=@AssignedIP,[Environment]=@Environment,[OperationalMode]=@OperationalMode,[Application]=@Application,[Contact]=@Contact,[Responsible]=@Responsible,[Owner]=@Owner,[ManagementIP]=@ManagementIP,[AssetTag]=@AssetTag,[Comment]=@Comment WHERE [ImportRequest]=@ImportRequest"
            DeleteCommand="UPDATE HostImport SET [StatusID]=@StatusID WHERE [ImportRequest]=@ImportRequest"
            >
            <SelectParameters>
                <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Hostname" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Function" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="FunctionAlias" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Service" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Backup" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Location" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Country" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="AssignedIP" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Environment" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="OperationalMode" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Application" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Contact" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Responsible" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Owner" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="ManagementIP" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="AssetTag" ConvertEmptyStringToNull="true" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="ImportRequest" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="StatusID" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="Hostname" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Function" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="FunctionAlias" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Service" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Backup" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Location" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Country" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="AssignedIP" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Environment" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="OperationalMode" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Application" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Contact" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Responsible" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Owner" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="ManagementIP" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="AssetTag" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Comment" ConvertEmptyStringToNull="true" Type="string" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="ImportRequest" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="StatusID" ConvertEmptyStringToNull="true" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>

