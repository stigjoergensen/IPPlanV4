<%@ Page Language="VB" AutoEventWireup="false" CodeFile="HostInfo.aspx.vb" Inherits="Windows_HostInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="/UserControl/ADComboBox.js"> </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label runat="server" ID="Hostname" Visible="false"/>
        <asp:Label runat="server" ID="EditMode" Visible="false" />
        <asp:Label runat="server" ID="ControlPath" Visible="false" />
        <asp:Label runat="server" ID="debugLabel" />
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />

        <table>
            <tr valign="top">
                <td>
                    <telerik:RadGrid runat="server" ID="rgHostExtraData" AllowPaging="false" ShowFooter="true" ShowHeader="false" AutoGenerateColumns="false">
                        <MasterTableView runat="server" AutoGenerateColumns="false">
                            <Columns>
                                <telerik:GridTemplateColumn HeaderText="Field Title" UniqueName="FieldTitle">
                                    <ItemTemplate>
                                        <asp:Label runat="server" Text='<%# Eval("FieldTitle") %>' />
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <telerik:RadButton runat="server" ID="Terminate" CommandName="Terminate" Text="Terminate" Visible="false" Width="130px" OnClick="Terminate_Click" />
                                        <telerik:RadButton runat="server" ID="TerminateReq" CommandName="TerminateReq" Text="Request Terminate" Visible="false" Width="130px" OnClick="TerminateReq_Click" />
                                        <telerik:RadButton runat="server" ID="Update" CommandName="Update" Text="Update" Visible="false"  Width="130px" OnClick="Update_Click"/>
                                        <telerik:RadButton runat="server" ID="Create" CommandName="Create" Text="Create" Visible="false" Width="130px" />
                                    </FooterTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="FieldName" HeaderText="FieldName" Display="false" />
                                <telerik:GridBoundColumn DataField="FieldValue" HeaderText="OriginalValue" Display="false" />
                                <telerik:GridBoundColumn DataField="Editable" HeaderText="Editable" Display="false" />
                                <telerik:GridTemplateColumn UniqueName="FieldValue">
                                    <ItemTemplate>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                    </FooterTemplate>
                                    <FooterStyle HorizontalAlign="Right" />
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn UniqueName="ExtraValues" Display="false">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="OriginalValue" />
                                        <asp:Label runat="server" ID="ValueType" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                    <asp:Panel runat="server" ID="PanelTerminateReq" Visible="false">
                        <telerik:RadTextBox runat="server" ID="TerminateReason" EmptyMessage="Please enter reason for termination" Width="260px"/><br />
                        <telerik:RadButton runat="server" ID="TerminateReqExec" Text="Submit request" />
                    </asp:Panel>
                    <asp:Label runat="server" ID="ErrorLabel" />
                </td>
                <td>
                    <asp:UpdatePanel runat="server" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Conditional" ID="InfoPanel" >
                        <ContentTemplate>
                            <table>
                                <tr valign="top">
                                    <td>
                                        <telerik:RadPanelBar runat="server" ID="PanelMenu" DataFieldID="Folder" DataTextField="Title" DataFieldParentID="ParentFolder" DataValueField="Filename" renderMode="Lightweight" Width="250" />
                                        <telerik:RadComboBox runat="server" ID="IncludeHistory" Width="250">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="Only show active data" Value="0" Selected="true" />
                                                <telerik:RadComboBoxItem Text="Include Historical data" Value="1" />
                                            </Items>
                                        </telerik:RadComboBox>
                                    </td>
                                    <td>
                                        <asp:UpdatePanel runat="server" ID="ControlPanel" ChildrenAsTriggers="true" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
    


        <asp:SqlDataSource ID="HostExtraData" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="false" 
            SelectCommand="SELECT *, CASE WHEN Substring(Hostname,1,1) = 'i' THEN substring(Hostname,2,1) ELSE 0 END AS NetworkType FROM HostExtraData WHERE HostName=@Hostname"
            DeleteCommand="UPDATE HostExtraData SET EndOfLife=GetDate(), LastUpdate=GetDate() WHERE Hostname=@Hostname">
            <SelectParameters>
                <asp:ControlParameter Name="Hostname" ControlID="Hostname" PropertyName="Text" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="HostExtraDataHistory" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            InsertCommand="INSERT INTO HostExtraDataHistory([Hostname],[CreateDate],[Description],[who]) VALUES(@Hostname,GETDATE(),@Description,@Who)">
            <InsertParameters>
                <asp:ControlParameter Name="Hostname" ControlID="Hostname" PropertyName="Text" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Description" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Who" ConvertEmptyStringToNull="true" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="IPPlanV4ViewSecurity" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT * FROM IPPlanV4ViewSecurity  AS V INNER JOIN IPPlanV4ViewSecurityGroup as G ON G.SecurityID = V.SecurityID WHERE V.ViewName = @ViewName AND G.AccessMethod = @AccessMethod"
            InsertCommand="INSERT INTO IPPlanV4ViewSecurity(ViewName,KeyName,KeyTitle,Formating,Defaultvalue,SortOrder) VALUES(@ViewName,@KeyName,@KeyTitle,@Formating,@DefaultValue,@SortOrder); SELECT @SecurityID=scope_identity()">
            <SelectParameters>
                <asp:Parameter Name="ViewName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="AccessMethod" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="ViewName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="KeyName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="KeyTitle" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Formating" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="DefaultValue" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="SortOrder" DefaultValue="5000" />
                <asp:Parameter Name="SecurityID" Direction="Output" DbType="Int64" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="IPPlanV4ViewSecurityAccessMethod" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="True" 
            SelectCommand="SELECT DISTINCT G.AccessMethod FROM IPPlanV4ViewSecurity  AS V INNER JOIN IPPlanV4ViewSecurityGroup as G ON G.SecurityID = V.SecurityID WHERE V.ViewName = @ViewName"
            InsertCommand="INSERT INTO IPPlanV4ViewSecurityGroup(SecurityID,AccessMethod,ReadGroups,WriteGroups) VALUES(@SecurityID,@AccessMethod,@ReadGroups,@WriteGroups)">
            <SelectParameters>
                <asp:Parameter Name="ViewName" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="SecurityID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="AccessMethod" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ReadGroups" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="WriteGroups" ConvertEmptyStringToNull="true" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="EnvironmentID" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT EnvironmentID AS Value, EnvironmentName AS Text FROM IPPlanEnvironment" />
        <asp:SqlDataSource ID="Backup" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT BackupMode AS Value, Name AS Text FROM IPPlanBackupModes" />
        <asp:SqlDataSource ID="Country" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT ISO2 AS Value, DSVName AS Text FROM Country WHERE ArsEnabled=1" />
        <asp:SqlDataSource ID="OperationMode" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT ID AS Value, OperationalMode AS Text FROM IPPlanOperationMode WHERE visible=1" />
        <asp:SqlDataSource ID="TierID" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT TierID AS Value, TierName AS Text FROM IPPlanV4Tier" />
        <asp:SqlDataSource ID="ServiceID" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT ServiceID AS Value, ServiceShortName AS Text FROM MasterService" />
        <asp:SqlDataSource ID="PatchEnabled" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT YesNo AS Value, Description AS Text FROM MasterYesNo" />
        <asp:SqlDataSource ID="AppID" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT ID AS Value, Description AS Text FROM EAP1Application Where _Active=1" />
        <asp:SqlDataSource ID="NetworkType" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT ZoneID AS Value, ZoneName AS Text FROM MasterNetworkZone" />

    </div>
    </form>
</body>
</html>
