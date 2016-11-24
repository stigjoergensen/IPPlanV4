<%@ Page Language="VB" AutoEventWireup="false" CodeFile="StorageReport.aspx.vb" Inherits="StorageReport" %>
<%@ Register TagPrefix="CustomColumns" Namespace="CustomColumns" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<link href="/styles/StorageReport.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
    <div>
                <telerik:RadGrid runat="server" ID="RGStorage" DataSourceID="ReportCountry" AutoGenerateColumns="false" MasterTableView-EditMode="InPlace" ShowFooter="true" >
                    <ExportSettings UseItemStyles="false">
                    </ExportSettings>
                    <GroupingSettings CaseSensitive="false" />
                    <MasterTableView DataSourceID="ReportCountry" DataKeyNames="ISO2" AutoGenerateColumns="false" AllowSorting="true">
                        <SortExpressions>
                            <telerik:GridSortExpression FieldName="DSVName" SortOrder="Ascending" />
                        </SortExpressions>
                        <ColumnGroups>
                            <telerik:GridColumnGroup Name="UserInfo" HeaderText="User Information" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="BorderRL"/>
                            <telerik:GridColumnGroup Name="UserSpace" HeaderText="User Space" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="BorderRL"/>
                            <telerik:GridColumnGroup Name="MailInfo" HeaderText="Mail usage" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="BorderRL"/>
                            <telerik:GridColumnGroup Name="GlobalServerInfo" HeaderText="Global Servers" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="BorderRL"/>
                            <telerik:GridColumnGroup Name="LocalServerInfo" HeaderText="Local Servers" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="BorderRL"/>
                            <telerik:GridColumnGroup Name="HostingServerInfo" HeaderText="Hosting Servers" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="BorderRL"/>
                            <telerik:GridColumnGroup Name="HousingServerInfo" HeaderText="Housing Servers" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="BorderRL"/>
                        </ColumnGroups>
                        <Columns>
                            <telerik:GridBoundColumn DataField="DSVName" UniqueName="DSVName" HeaderText="Country" HeaderStyle-VerticalAlign="Bottom" HeaderTooltip="">
                                <HeaderStyle Width="100px" HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <FooterStyle HorizontalAlign="left" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn UniqueName="ISO2" DataField="ISO2" HeaderText="ISO" ReadOnly="true" HeaderStyle-CssClass="BorderR" ItemStyle-CssClass="BorderR" HeaderStyle-VerticalAlign="Bottom"  FooterText="Totals:"  HeaderTooltip="DSV Country Code">
                                <HeaderStyle Width="20px" HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <FooterStyle HorizontalAlign="left" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Users" HeaderText="Users" ReadOnly="true" ColumnGroupName="UserInfo" HeaderStyle-CssClass="BorderL" ItemStyle-CssClass="BorderL" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="Number of users in Active Directory">
                                <HeaderStyle Width="50px" HorizontalAlign="Right" />
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="MailboxEnabled" HeaderText="Mailboxes" ReadOnly="true"  ColumnGroupName="UserInfo" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="Number of mail enabled users">
                                <HeaderStyle Width="50px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="LyncEnabled" HeaderText="Lync" ReadOnly="true"  ColumnGroupName="UserInfo" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="Number of Lync/Skype enabled users">
                                <HeaderStyle Width="50px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="VideoEnabled" HeaderText="Video" ReadOnly="true"  ColumnGroupName="UserInfo"  HeaderStyle-CssClass="BorderR"  ItemStyle-CssClass="BorderR" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="Number of users that are video enabled in Lync/Skype">
                                <HeaderStyle Width="50px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="File Size (GB)" HeaderText="Total (GB)" ReadOnly="true"  ColumnGroupName="UserSpace" HeaderStyle-CssClass="BorderL" ItemStyle-CssClass="BorderL" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How much User storage are used in total">
                                <HeaderStyle Width="70px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="HNAS Size (GB)" HeaderText="Online (GB)" ReadOnly="true"  ColumnGroupName="UserSpace" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How much User storage is available online">
                                <HeaderStyle Width="70px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Archive Size (GB)" HeaderText="Archive (GB)" ReadOnly="true"  ColumnGroupName="UserSpace"  HeaderStyle-CssClass="BorderR"  ItemStyle-CssClass="BorderR" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How much user storage is available in the file archive">
                                <HeaderStyle Width="70px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Mailbox Size (GB)" HeaderText="Mailbox (GB)" ReadOnly="true" ColumnGroupName="MailInfo" HeaderStyle-CssClass="BorderL" ItemStyle-CssClass="BorderL" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How much storage is used by exchange">
                                <HeaderStyle Width="80px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Avg Mailbox size (MB)" HeaderText="Avg Mailbox (MB)" ReadOnly="true" ColumnGroupName="MailInfo" HeaderStyle-CssClass="" ItemStyle-CssClass="" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="Average mailbox size per mailbox enabled user">
                                <HeaderStyle Width="80px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArchiveWarnings" HeaderText="Policy breach" ReadOnly="true" ColumnGroupName="MailInfo"  HeaderStyle-CssClass="BorderR"  ItemStyle-CssClass="BorderR" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="Users that breach our archive policy (bigger mailbox but not the right archive policy for the size)">
                                <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Global Servers" HeaderText="Servers" ReadOnly="true" ColumnGroupName="GlobalServerInfo" HeaderStyle-CssClass="BorderL" ItemStyle-CssClass="BorderL" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How many servers are operated by Global IT">
                                <HeaderStyle Width="50px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Global Size (GB)" HeaderText="Size (GB)" ReadOnly="true" ColumnGroupName="GlobalServerInfo"  HeaderStyle-CssClass="BorderR"  ItemStyle-CssClass="BorderR" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="And the total size of these servers">
                                <HeaderStyle Width="70px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Local Servers" HeaderText="Servers" ReadOnly="true" ColumnGroupName="LocalServerInfo" HeaderStyle-CssClass="BorderL" ItemStyle-CssClass="BorderL" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How many servers exists locally">
                                <HeaderStyle Width="50px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Local Size (GB)" HeaderText="Size (GB)" ReadOnly="true" ColumnGroupName="LocalServerInfo"  HeaderStyle-CssClass="BorderR"  ItemStyle-CssClass="BorderR" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="And the total size of these">
                                <HeaderStyle Width="70px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Hosting Servers" HeaderText="Servers" ReadOnly="true" ColumnGroupName="HostingServerInfo" HeaderStyle-CssClass="BorderL" ItemStyle-CssClass="BorderL" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How manu servers are oprated by Group IT for the country">
                                <HeaderStyle Width="50px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Hosting Size (GB)" HeaderText="Size (GB)" ReadOnly="true" ColumnGroupName="HostingServerInfo"  HeaderStyle-CssClass="BorderR"  ItemStyle-CssClass="BorderR" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="And the size of these">
                                <HeaderStyle Width="70px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Housing Servers" HeaderText="Servers" ReadOnly="true" ColumnGroupName="HousingServerInfo" HeaderStyle-CssClass="BorderL" ItemStyle-CssClass="BorderL" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="How many local servers exists in our Datacenters, but are operated by local it">
                                <HeaderStyle Width="50px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Housing Size (GB)" HeaderText="Size (GB)" ReadOnly="true" ColumnGroupName="HousingServerInfo"  HeaderStyle-CssClass="BorderR"  ItemStyle-CssClass="BorderR" Aggregate="Sum" FooterAggregateFormatString="{0}"  HeaderTooltip="And the size of these">
                                <HeaderStyle Width="70px" HorizontalAlign="Right"/>
                                <ItemStyle HorizontalAlign="right" />
                                <FooterStyle HorizontalAlign="Right" />
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" >
                                <HeaderStyle Width="20px" VerticalAlign="Middle"/>
                                <HeaderTemplate>
                                    <telerik:RadButton Image-ImageUrl="~/Images/Excel_16x16.png" runat="server" ID="ExportExcel" Width="16" Height="16" skin="Windows7" CommandName="Export" CommandArgument="StorageExcel" /><br /><br />
                                    <telerik:RadButton Image-ImageUrl="~/Images/PDF_16x16.png" runat="server"  ID="ExportPDF" Width="16" Height="16" skin="Windows7" CommandName="Export" CommandArgument="StoragePDF" />
                                </HeaderTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                        <DetailTables>
                            <telerik:GridTableView Name="GTWUsersCountry" DataSourceID="ReportUsersCountry" DataKeyNames="Country" AutoGenerateColumns="false" ShowFooter="false" >
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="Country" MasterKeyField="ISO2" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="Users" HeaderText="Users">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="MailboxEnabled" HeaderText="Mailboxes">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="LyncEnabled" HeaderText="Lync">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="VideoEnabled" HeaderText="Video">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="FileSize" HeaderText="Total (GB)">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                   <telerik:GridBoundColumn DataField="HNASSize" HeaderText="Online Files (GB)">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArchiveSize" HeaderText="Archive Files (GB)">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="AvgMailBoxSize" HeaderText="Avg Mailbox size (MB)">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="MailboxSize" HeaderText="Mailbox size (GB)">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArchiveWarnings" HeaderText="Policy breach">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="WhiteCollar" HeaderText="White Collar">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="BlueCollar" HeaderText="Blue Collar">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="IllegalType" HeaderText="Illegal Type">
                                        <HeaderStyle Width="100px" HorizontalAlign="Right"/>
                                        <ItemStyle HorizontalAlign="right" />
                                    </telerik:GridBoundColumn>
                                </Columns>
                                <DetailTables>
                                    <telerik:GridTableView Name="GTWUsers" DataSourceID="ReportUsers" DataKeyNames="Country" AutoGenerateColumns="false" ShowFooter="false" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true">
                                        <SortExpressions>
                                            <telerik:GridSortExpression FieldName="Username" SortOrder="Ascending" />
                                        </SortExpressions>
                                        <ParentTableRelation>
                                            <telerik:GridRelationFields DetailKeyField="Country" MasterKeyField="Country" />
                                        </ParentTableRelation>
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="Username" HeaderText="Username" />
                                            <telerik:GridBoundColumn DataField="EmployeeType" HeaderText="Type" />
                                            <telerik:GridCheckBoxColumn DataField="MailboxEnabled" HeaderText="Mailbox" StringFalseValue="0" StringTrueValue="1" />
                                            <telerik:GridCheckBoxColumn DataField="LyncEnabled" HeaderText="Lync" StringFalseValue="0" StringTrueValue="1" />
                                            <telerik:GridCheckBoxColumn DataField="VideoEnabled" HeaderText="Video" StringFalseValue="0" StringTrueValue="1" />
                                            <telerik:GridBoundColumn DataField="HNASSize" HeaderText="Online (MB)" />
                                            <telerik:GridBoundColumn DataField="ArchiveSize" HeaderText="Archive (MB)" />
                                            <telerik:GridBoundColumn DataField="FileSize" HeaderText="Total (MB)" />
                                            <telerik:GridCheckBoxColumn DataField="CustomQuota" HeaderText="Expanded" StringFalseValue="0" StringTrueValue="1" />
                                            <telerik:GridBoundColumn DataField="MailBoxSizeLimitMB" HeaderText="Mail Limit (MB)" />
                                            <telerik:GridBoundColumn DataField="MailBoxSizeMB" HeaderText="Mailbox Size (MB)" />
                                            <telerik:GridBoundColumn DataField="MailboxFillPCT" HeaderText="Fill" />
                                            <telerik:GridBoundColumn DataField="ArchiveInstance" HeaderText="Archive Inst" />
                                            <telerik:GridBoundColumn DataField="ArchivePolicy" HeaderText="Policy" />
                                            <telerik:GridCheckboxColumn DataField="ArchiveWarning" HeaderText="Policy breach" />
                                            <telerik:GridTemplateColumn AllowFiltering="false" >
                                                <HeaderStyle Width="20px" VerticalAlign="Middle"/>
                                                <HeaderTemplate>
                                                    <telerik:RadButton CommandName="Export" CommandArgument="CountryUser" Image-ImageUrl="~/Images/Excel_16x16.png" runat="server" ID="ExportUsersExcel" Width="16" Height="16" skin="Windows7" />
                                                </HeaderTemplate>
                                            </telerik:GridTemplateColumn>
                                        </Columns>
                                    </telerik:GridTableView>
                                </DetailTables>
                            </telerik:GridTableView>
                            <telerik:GridTableView Name="GTWHostsCountry" DataSourceID="ReportHostsCountry" DataKeyNames="Country,ServerType" AutoGenerateColumns="false" ShowFooter="false" >
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="Country" MasterKeyField="ISO2" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="ServerType" HeaderText="Type" />
                                    <telerik:GridBoundColumn DataField="Servers" HeaderText="Servers" />
                                    <telerik:GridBoundColumn DataField="VirtualServers" HeaderText="Virtual" />
                                    <telerik:GridBoundColumn DataField="HostSize" HeaderText="Size (GB)" />
                                </Columns>
                                <DetailTables>
                                    <telerik:GridTableView Name="GTWHosts" DataSourceID="ReportHosts" DataKeyNames="Country,ServerType" AutoGenerateColumns="false" ShowFooter="false" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true">
                                        <ParentTableRelation>
                                            <telerik:GridRelationFields DetailKeyField="Country" MasterKeyField="Country" />
                                            <telerik:GridRelationFields DetailKeyField="ServerType" MasterKeyField="ServerType" />
                                        </ParentTableRelation>
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="Hostname" HeaderText="Hostname" />
                                            <telerik:GridCheckBoxColumn DataField="VirtualServer" HeaderText="Virtual" StringFalseValue="0" StringTrueValue="1" />
                                            <telerik:GridBoundColumn DataField="HostsizeGB" HeaderText="Size (GB)" />
                                            <telerik:GridBoundColumn DataField="Function" HeaderText="Function" />
                                            <telerik:GridBoundColumn DataField="Owner" HeaderText="Owner" />
                                            <telerik:GridBoundColumn DataField="Responsible" HeaderText="Responsible" />
                                            <telerik:GridBoundColumn DataField="Contact" HeaderText="Contact" />
                                            <telerik:GridBoundColumn DataField="OperationalMode" HeaderText="Operation" />
                                            <telerik:GridBoundColumn DataField="EnvironmentName" HeaderText="Environment" />
                                        </Columns>
                                    </telerik:GridTableView>
                                </DetailTables>
                            </telerik:GridTableView>
                        </DetailTables>
                    </MasterTableView>
                </telerik:RadGrid>

                <asp:SqlDataSource runat="server" ID="ReportCountry" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
                    SelectCommand="SELECT * FROM Report_Country ORDER BY DSVName"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ReportUsersCountry" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
                    SelectCommand="SELECT Country,Users,MailboxEnabled,LyncEnabled,VideoEnabled,FileSize / 1024 / 1024 / 1024 AS FileSize, HNASSize / 1024 / 1024 / 1024 AS HNASSize, ArchiveSize / 1024 / 1024 / 1024 AS ArchiveSize, MailBoxSize / 1024 / 1024 / 1024 AS MailboxSize, ArchiveWarnings,WhiteCollar,BlueCollar,IllegalType, AvgMailBoxSize / 1024 / 1024 AS AvgMailboxSize FROM Report_Users_Country WHERE [Country]=@Country"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                    <SelectParameters>
                        <asp:Parameter Name="Country" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ReportUsers" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
                    SelectCommand="SELECT Username,Country,MailboxEnabled,LyncEnabled,VideoEnabled,FileSize/ 1024 / 1024 AS FileSize,HNASSize/ 1024 / 1024 AS HNASSize,ArchiveSize/ 1024 / 1024 AS ArchiveSize,MailboxSize/ 1024 / 1024 AS MailboxSize,ArchiveInstance,ArchivePolicy,CustomQuota,MailBoxSizeLimitMB / 1024 / 1024 AS MailBoxSizeLimitMB,MailBoxSizeMB,MailboxFillPCT,ArchiveWarning,EmployeeTypeID,EmployeeType  FROM Report_Users WHERE [Country]=@Country"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                    <SelectParameters>
                        <asp:Parameter Name="Country" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ReportHostsCountry" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
                    SelectCommand="SELECT Country,ServerType,Servers,VirtualServers,Hostsize / 1024 / 1024 / 1024 AS HostSize FROM Report_Hosts_Country WHERE [Country]=@Country"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                    <SelectParameters>
                        <asp:Parameter Name="Country" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ReportHosts" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
                    SelectCommand="SELECT *, Hostsize / 1024 / 1024 / 1024 AS HostSizeGB FROM Report_Hosts WHERE [Country]=@Country AND ServerType=@ServerType"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                    <SelectParameters>
                        <asp:Parameter Name="Country" Type="String" />
                        <asp:Parameter Name="ServerType" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
