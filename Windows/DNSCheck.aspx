<%@ Page Language="VB" AutoEventWireup="false" CodeFile="DNSCheck.aspx.vb" Inherits="Windows_DNSCheck" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
    <div>
        <asp:Label runat="server" ID="PowershellResult" Text="" />
        <asp:Panel runat="server" ID="PanelDNSList" Visible="true">
            <telerik:RadGrid runat="server" ID="DNSDomainNamesView" DataSourceID="DNSDomainNames" AllowFilteringByColumn="true" AllowSorting="true" EnableLinqExpressions="false" >
                <MasterTableView runat="server" AutoGenerateColumns="false" DataKeyNames="DomainID" DataSourceID="DNSDomainNames" ShowHeader="true" Name="DomainList" FilterExpression="([Enabled] = 1)" >
                    <Columns>
                        <telerik:GridBoundColumn DataField="DomainName" HeaderText="Domain" />
                        <telerik:GridDropDownColumn DataField="DomainState" HeaderText="State" DataSourceID="DNSDomainState" ListTextField="StateName" ListValueField="StateID">
                            <FilterTemplate>
                                <telerik:RadDropDownList ID="DomainStateFilter" runat="server" DataSourceID="DNSDomainState" DataValueField="StateID" DataTextField="StateName" SelectedValue='<%# CType(Container, GridItem).OwnerTableView.GetColumn("DomainState").CurrentFilterValue%>' AppendDataBoundItems="true" OnClientSelectedIndexChanged="DomainStateIndexChanged" Width="50">
                                    <Items>
                                        <telerik:DropDownListItem Text="All" />
                                    </Items>
                                </telerik:RadDropDownList>
                                <telerik:RadScriptBlock ID="DomainStateIndexChanged" runat="server">
                                    <script type="text/javascript">
                                        function DomainStateIndexChanged(sender, args) {
                                            var tableView = $find("<%# CType(Container, GridItem).OwnerTableView.ClientID %>");
                                            tableView.filter("DomainState", sender._selectedValue, "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridBoundColumn DataField="Responsible" HeaderText="Responsible" />
                        <telerik:GridBoundColumn DataField="DNSError" HeaderText="Lookup Error" />
                        <telerik:GridBoundColumn DataField="Age" HeaderText="Age" HeaderTooltip="In hours" />
                        <telerik:GridDropDownColumn UniqueName="NameServers" DataField="NameServers" HeaderText="Name Server" DataSourceID="DNSDomainState" ListTextField="StateName" ListValueField="StateID">
                            <FilterTemplate>
                                <telerik:RadDropDownList ID="NameServersFilter" runat="server" DataSourceID="DNSDomainState" DataValueField="StateID" DataTextField="StateName" SelectedValue='<%# CType(Container, GridItem).OwnerTableView.GetColumn("NameServers").CurrentFilterValue%>' AppendDataBoundItems="true" OnClientSelectedIndexChanged="NameServersIndexChanged" Width="50">
                                    <Items>
                                        <telerik:DropDownListItem Text="All" />
                                    </Items>
                                </telerik:RadDropDownList>
                                <telerik:RadScriptBlock ID="NameServersIndexChanged" runat="server">
                                    <script type="text/javascript">
                                        function NameServersIndexChanged(sender, args) {
                                            var tableView = $find("<%# CType(Container, GridItem).OwnerTableView.ClientID %>");
                                            tableView.filter("NameServers", sender._selectedValue, "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridDropDownColumn UniqueName="MailServers" DataField="MailServers" HeaderText="Mail Server" DataSourceID="DNSDomainState" ListTextField="StateName" ListValueField="StateID">
                            <FilterTemplate>
                                <telerik:RadDropDownList ID="MailServersFilter" runat="server" DataSourceID="DNSDomainState" DataValueField="StateID" DataTextField="StateName" SelectedValue='<%# CType(Container, GridItem).OwnerTableView.GetColumn("MailServers").CurrentFilterValue%>' AppendDataBoundItems="true" OnClientSelectedIndexChanged="MailServersIndexChanged" Width="50">
                                    <Items>
                                        <telerik:DropDownListItem Text="All" />
                                    </Items>
                                </telerik:RadDropDownList>
                                <telerik:RadScriptBlock ID="MailServersIndexChanged" runat="server">
                                    <script type="text/javascript">
                                        function MailServersIndexChanged(sender, args) {
                                            var tableView = $find("<%# CType(Container, GridItem).OwnerTableView.ClientID %>");
                                            tableView.filter("MailServers", sender._selectedValue, "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridDropDownColumn UniqueName="WebServers" DataField="WebServers" HeaderText="Web Server" DataSourceID="DNSDomainState" ListTextField="StateName" ListValueField="StateID">
                            <FilterTemplate>
                                <telerik:RadDropDownList ID="WebServersFilter" runat="server" DataSourceID="DNSDomainState" DataValueField="StateID" DataTextField="StateName" SelectedValue='<%# CType(Container, GridItem).OwnerTableView.GetColumn("WebServers").CurrentFilterValue%>' AppendDataBoundItems="true" OnClientSelectedIndexChanged="WebServersIndexChanged" Width="50">
                                    <Items>
                                        <telerik:DropDownListItem Text="All" />
                                    </Items>
                                </telerik:RadDropDownList>
                                <telerik:RadScriptBlock ID="WebServersIndexChanged" runat="server">
                                    <script type="text/javascript">
                                        function WebServersIndexChanged(sender, args) {
                                            var tableView = $find("<%# CType(Container, GridItem).OwnerTableView.ClientID %>");
                                            tableView.filter("WebServers", sender._selectedValue, "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridDropDownColumn UniqueName="RootServers" DataField="RootServers" HeaderText="Root Server" DataSourceID="DNSDomainState" ListTextField="StateName" ListValueField="StateID">
                            <FilterTemplate>
                                <telerik:RadDropDownList ID="RootServersFilter" runat="server" DataSourceID="DNSDomainState" DataValueField="StateID" DataTextField="StateName" SelectedValue='<%# CType(Container, GridItem).OwnerTableView.GetColumn("RootServers").CurrentFilterValue%>' AppendDataBoundItems="true" OnClientSelectedIndexChanged="RootServersIndexChanged" Width="50">
                                    <Items>
                                        <telerik:DropDownListItem Text="All" />
                                    </Items>
                                </telerik:RadDropDownList>
                                <telerik:RadScriptBlock ID="RootServersIndexChanged" runat="server">
                                    <script type="text/javascript">
                                        function RootServersIndexChanged(sender, args) {
                                            var tableView = $find("<%# CType(Container, GridItem).OwnerTableView.ClientID %>");
                                            tableView.filter("RootServers", sender._selectedValue, "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridTemplateColumn DataField="LastCheck" AllowFiltering="false" AllowSorting="true">
                            <ItemTemplate>
                                <asp:Label runat="server" Text='<%# Eval("lastCheck", "{0:yyyy.MM.dd HH:mm}")%>' />
                                <asp:ImageButton runat="server" ID="RefreshTable" ImageUrl="~/Images/refresh_16x16.png" CommandName="Refresh" CommandArgument='<%#Eval("DomainID")%>' />
                            </ItemTemplate>
                            <HeaderTemplate>
                                <asp:Label runat="server" Text="Last Check" />
                                <asp:ImageButton runat="server" ID="RefreshTable" ImageUrl="~/Images/refresh_16x16.png" CommandName="Refresh" CommandArgument="-1" />
                            </HeaderTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderText="Enabled" UniqueName="Enabled" DataField="Enabled" CurrentFilterValue="1">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="Disable" CommandName="Disable" Text="Disable" Visible='<%# IIf((Eval("Enabled") = "1") And (Eval("DomainID") > "0"), True, False)%>' />
                                <asp:LinkButton runat="server" ID="Enable" CommandName="Enable" Text="Enable" Visible='<%# IIf((Eval("Enabled") = "0") And (Eval("DomainID") > "0"), True, False)%>' />
                            </ItemTemplate>
                            <FilterTemplate>
                                    <telerik:RadDropDownList ID="ShowDisabled" runat="server" SelectedValue='<%# CType(Container, GridItem).OwnerTableView.GetColumn("Enabled").CurrentFilterValue%>' AppendDataBoundItems="true" OnClientSelectedIndexChanged="ShowDisabledChanged" Width="80">
                                    <Items>
                                        <telerik:DropDownListItem Text="All" Value="" />
                                        <telerik:DropDownListItem Text="Enabled" Value="1" />
                                        <telerik:DropDownListItem Text="Disabled" Value="0" />
                                    </Items>
                                </telerik:RadDropDownList>
                                <telerik:RadScriptBlock ID="ShowDisabledChanged" runat="server">
                                    <script type="text/javascript">
                                        function ShowDisabledChanged(sender, args) {
                                            var tableView = $find("<%# CType(Container, GridItem).OwnerTableView.ClientID %>");
                                            tableView.filter("Enabled", sender._selectedValue, "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridTemplateColumn>
                    </Columns>
                    <DetailTables>
                        <telerik:GridTableView runat="server" DataSourceID="DNSDomainServers" AutoGenerateColumns="False" DataKeyNames="DomainID,ServerName" ShowHeadersWhenNoRecords="false" AllowFilteringByColumn="false" NoDetailRecordsText="" Name="DomainServers" >
                            <ParentTableRelation>
                                <telerik:GridRelationFields DetailKeyField="DomainID" MasterKeyField="DomainID" />
                            </ParentTableRelation>
                            <Columns>
                                <telerik:GridBoundColumn DataField="DomainID" Display="false" UniqueName="DomainID" />
                                <telerik:GridBoundColumn DataField="RecordType" HeaderText="Type" UniqueName="RecordType" />
                                <telerik:GridBoundColumn DataField="Servername" HeaderText="Server" UniqueName="ServerName" />
                                <telerik:GridCheckBoxColumn DataField="ServerOK" HeaderText="Approved" DataType="System.Int32" StringTrueValue="1" StringFalseValue="0" />
                                <telerik:GridTemplateColumn AllowFiltering="false" >
                                    <ItemTemplate>
                                        <asp:linkButton runat="server" ID="Approve" Text="Approve" CommandName="Approve" Visible='<%# IIf((Eval("LocalApproved") = "0") And (Eval("ServerOK") = "0") And (IPPlanSecurity.isInRole(Page, "DNSCheck", "Admministrators of DNSCheck")), "true", "false")%>' />
                                        <asp:linkButton runat="server" ID="Revoke" Text="Revoke" CommandName="Revoke" Visible='<%# IIf((Eval("LocalApproved") = "1" And (IPPlanSecurity.isInRole(Page, "DNSCheck", "Admministrators of DNSCheck"))), "true", "false")%>' />
                                        <asp:linkButton runat="server" ID="Promote" Text="Promote" CommandName="Promote" Visible='<%# IIf((Eval("LocalApproved") = "1" And (IPPlanSecurity.isInRole(Page, "DNSCheckGlobal", "Admministrators of DNSCheck"))), "true", "false")%>' />
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <telerik:RadButton Image-ImageUrl="~/Images/refresh_16x16.png" runat="server"  ID="Refresh" Width="16" Height="16" skin="Windows7" CommandName='<%# Telerik.Web.UI.RadGrid.RebindGridCommandName%>' />
                                    </HeaderTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                        </telerik:GridTableView>
                        <telerik:GridTableView runat="server" DataSourceID="DNSApprovedServers" AutoGenerateColumns="false" DataKeyNames="DomainID,ServerType,ServerName" ShowHeadersWhenNoRecords="false" AllowFilteringByColumn="false" NoDetailRecordsText="" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" EditMode="InPlace" Name="ApprovedServers">
                            <ParentTableRelation>
                                <telerik:GridRelationFields MasterKeyField="DomainID" DetailKeyField="DomainID" />
                            </ParentTableRelation>
                            <Columns>
                                <telerik:GridBoundColumn DataField="ServerName" HeaderText="" UniqueName="OrgServername" Display="false" />
                                <telerik:GridBoundColumn DataField="DomainName" HeaderText="Used in" UniqueName="DomainName" ReadOnly="true" />
                                <telerik:GridTemplateColumn UniqueName="ServerType" HeaderText="Type">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="ServerType" Text='<%# Bind("ServerType")%>' />
                                    </ItemTemplate>
                                    <InsertItemTemplate>
                                        <telerik:RadTextBox runat="server" ID="ServerType" Text='<%# Bind("ServerType")%>' TextMode="SingleLine" />
                                    </InsertItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="ServerName" HeaderText="Server name/adr" UniqueName="ServerName" />
                                <telerik:GridBoundColumn DataField="CreateDate" HeaderText="Created" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" ReadOnly="true" />
                                <telerik:GridBoundColumn DataField="Who" HeaderText="Creator" UniqueName="Who" ReadOnly="true" />
                                <telerik:GridTemplateColumn>
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="DeleteApprovedServer" CommandName='<%# Telerik.Web.UI.RadGrid.DeleteCommandName%>' Text="Delete"/>
                                        <asp:LinkButton runat="server" ID="UpdateApprovedServer" CommandName='<%# Telerik.Web.UI.RadGrid.EditCommandName %>' Text="Edit"/>
                                    </ItemTemplate>
                                    <InsertItemTemplate>
                                        <asp:linkbutton runat="server" ID="InsertApprovedServer" CommandName='<%# Telerik.Web.UI.RadGrid.PerformInsertCommandName%>' Text="Add"/>
                                    </InsertItemTemplate>
                                    <EditItemTemplate>
                                        <asp:linkbutton runat="server" ID="UpdateApprovedServer" CommandName='<%# Telerik.Web.UI.RadGrid.UpdateEditedCommandName%>' Text="Update"/>
                                        <asp:linkbutton runat="server" ID="CancelUpdateApprovedServer" CommandName='<%# Telerik.Web.UI.RadGrid.CancelCommandName%>' Text="Cancel"/>
                                    </EditItemTemplate>
                                    <HeaderTemplate>
                                        <asp:linkbutton runat="server" ID="AddApprovedServer" CommandName='<%# Telerik.Web.UI.RadGrid.InitInsertCommandName%>' Text="Add" Style="text-decoration:underline;"/>
                                        <telerik:RadButton Image-ImageUrl="~/Images/refresh_16x16.png" runat="server"  ID="Refresh" Width="16" Height="16" skin="Windows7" CommandName='<%# Telerik.Web.UI.RadGrid.RebindGridCommandName%>' />
                                    </HeaderTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                        </telerik:GridTableView>
                    </DetailTables>
                </MasterTableView>
            </telerik:RadGrid>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelDNSAdd" Visible="false">
            <table>
                <tr>
                    <td>
                        Enter domains, one on each line - if allready exists the domain will not be added<br />
                        Names starting with www will be truncated, only root domain is acceptable.
                    </td>
                </tr>
                <tr>
                    <td>
                        <telerik:RadTextBox runat="server" ID="DNSList" TextMode="MultiLine" Rows="40" Width="500" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right;">
                        <asp:LinkButton runat="server" ID="AddDNSDomains" Text="Add" />
                        <asp:LinkButton runat="server" ID="CloseAddDNSDomains" Text="Close" Visible="false" />
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <asp:SqlDataSource runat="server" ID="DNSApprovedServers" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" CancelSelectOnNullParameter="false"  
            SelectCommand="select DAS.*, DN.DomainName from DNSApprovedServers AS DAS JOIN DNSDomainNames AS DN ON DN.DomainID = DAS.DomainID WHERE @DomainID=0 ORDER BY DomainID,ServerType"
            InsertCommand="INSERT INTO DNSApprovedServers(DomainID,ServerType,Servername,CreateDate,Who) VALUES(0,@ServerType,@Servername,GETDATE(),@Who)"
            DeleteCommand="DELETE FROM DNSApprovedServers WHERE DomainID=0 AND ServerType=@ServerType AND Servername=@ServerName"
            UpdateCommand="UPDATE DNSApprovedServers SET ServerName=@ServerName WHERE DomainID=@DomainID AND ServerType=@ServerType AND Servername=@OrgServerName"
            >
            <SelectParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="ServerType" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Who" ConvertEmptyStringToNull="true" />
            </InsertParameters>
            <DeleteParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerType" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerType" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="OrgServerName" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
        </asp:SqlDataSource>
        

        <asp:SqlDataSource runat="server" ID="DNSDomainNames" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" CancelSelectOnNullParameter="false"  
            SelectCommand="SELECT *,DATEDIFF(HOUR,LastCheck,GETDATE()) AS Age FROM DNSDomainNames WHERE ((DomainID > 0 OR @Global='True') AND @DomainName IS NULL) OR DomainName=@DomainName ORDER BY CASE WHEN DomainID = 0 THEN 0 ELSE 1 END,DomainName"
            InsertCommand="INSERT INTO DNSDomainNames(DomainName,LastCheck) VALUES(@DomainName,'2016-01-01')"
            DeleteCommand="UPDATE DNSDOmainNames SET [Enabled]=0 WHERE DomainID=@DomainID"
            UpdateCommand="UPDATE DNSDomainNames SET [Enabled]=1 WHERE DomainID=@DomainID"
            >
            <SelectParameters>
                <asp:Parameter Name="Global" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="DomainName" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="DomainName" ConvertEmptyStringToNull="true" />
            </InsertParameters>
            <DeleteParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="DNSDomainState" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT StateID,StateName FROM DNSDomainState">
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="DNSDomainServers" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT DS.*, CASE WHEN DAS.DomainID IS NULL THEN 0 ELSE 1 END AS LocalApproved  FROM DNSDomainServers AS DS
                            LEFT OUTER JOIN DNSApprovedServers AS DAS ON DAS.ServerType = DS.RecordType AND DAS.ServerName = DS.ServerName AND DAS.DomainID = DS.DomainID
                            WHERE DS.DomainID = @DomainID ORDER BY RecordType"
            InsertCommand="INSERT INTO DNSApprovedServers(DomainID,ServerType,Servername,CreateDate,Who) VALUES(@DomainID,@ServerType,@ServerName,GETDATE(),@Who)"
            DeleteCommand="DELETE FROM DNSApprovedServers WHERE DomainID=@DomainID AND ServerType=@ServerType AND Servername=@ServerName"
            UpdateCommand="UPDATE DNSApprovedServers SET DomainID=0 WHERE DomainID=@DomainID AND ServerType=@ServerType AND Servername=@ServerName"
            >
            <SelectParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerType" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="who" ConvertEmptyStringToNull="true" />
            </InsertParameters>
            <DeleteParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerType" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="DomainID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerType" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
        </asp:SqlDataSource>

    
    </div>
    </form>
</body>
</html>
