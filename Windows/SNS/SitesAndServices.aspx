<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SitesAndServices.aspx.vb" Inherits="SitesAndServices" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<link href="/styles/default.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
    <div>
        <telerik:RadGrid runat="server" ID="RGADContainer" DataSourceID="SNSADContainer" AutoGenerateColumns="False" ShowFooter="True" GroupPanelPosition="Top">
            <MasterTableView  DataKeyNames="ADContainer" AutoGenerateColumns="false" AllowSorting="true">
                <Columns>
                    <telerik:GridTemplateColumn UniqueName="execute">
                        <HeaderTemplate>
                            Action
                        </HeaderTemplate>
                        <ItemTemplate>
                            <telerik:RadDropDownList runat="server" ID="Action">
                                <Items>
                                    <telerik:DropDownListItem Text="Skip" Value="Skip" />
                                    <telerik:DropDownListItem Text="Process" Value="Process" Selected="true" />
                                    <telerik:DropDownListItem Text="Delete" Value="Delete" />
                                </Items>
                            </telerik:RadDropDownList>
                        </ItemTemplate>
                        <FooterTemplate>
                            <telerik:RadButton runat="server" ID="execute" Text="Execute" CommandArgument="All" CommandName="Execute" />
                            Only rows that have been shown are processed, to make sure you know the impact
                            <asp:Label runat="server" ID="rowcount" Text="" />
                        </FooterTemplate>
                        <HeaderStyle Width="80px" />
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="ADContainer" UniqueName="ADContainer" HeaderText="Container" HeaderTooltip="">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridButtonColumn DataTextField="Submitted" UniqueName="Submitted" HeaderText="Submitted" HeaderTooltip="" CommandName="show" CommandArgument="100">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle Width="100px" />
                    </telerik:GridButtonColumn>
                    <telerik:GridButtonColumn DataTextField="Approved" UniqueName="Approved" HeaderText="Approved" HeaderTooltip="" CommandName="show" CommandArgument="500">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle Width="100px" />
                    </telerik:GridButtonColumn>
                    <telerik:GridButtonColumn DataTextField="Rejected" UniqueName="Rejected" HeaderText="Rejected" HeaderTooltip="" CommandName="show" CommandArgument="900">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle Width="100px" />
                    </telerik:GridButtonColumn>
                    <telerik:GridBoundColumn DataField="FromDate" UniqueName="FromDate" HeaderText="From" HeaderTooltip="" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle Width="180px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ToDate" UniqueName="ToDate" HeaderText="To" HeaderTooltip="" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                    </telerik:GridBoundColumn>
                </Columns>
                <DetailTables>
                    <telerik:GridTableView Name="GTWSites" DataKeyNames="CountryCode,CityCode" AutoGenerateColumns="false" Visible="false" AllowSorting="false" ShowFooter="true" AllowPaging="true" PageSize="25">
                        <Columns>
                            <telerik:GridTemplateColumn>
                                <HeaderTemplate>
                                    Action
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <telerik:RadDropDownList runat="server" ID="Action">
                                        <Items>
                                            <telerik:DropDownListItem Text="Skip" Value="Skip" />
                                            <telerik:DropDownListItem Text="Approve" Value="Approve" Selected="true"/>
                                            <telerik:DropDownListItem Text="Reject" Value="Reject" />
                                            <telerik:DropDownListItem Text="Delete" Value="Delete" />
                                        </Items>
                                    </telerik:RadDropDownList>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <telerik:RadButton runat="server" ID="execute" Text="Execute" CommandArgument="Sites" CommandName="Execute" />
                                </FooterTemplate>
                                <HeaderStyle Width="80px" />
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="OperationText" UniqueName="OperationText" HeaderText="Operation" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CountryName" UniqueName="CountryName" HeaderText="Country" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="100px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CountryCode" UniqueName="CountryCode" HeaderText="ISO" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="50px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CityCode" UniqueName="CityCode" HeaderText="City" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="100px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Description" UniqueName="Description" HeaderText="Description" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SWCreateDate" UniqueName="SWCreateDate" HeaderText="Date" HeaderTooltip="" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="180px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="StatusText" UniqueName="StatusText" HeaderText="Status" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                        </Columns>
                    </telerik:GridTableView>
                    <telerik:gridtableview Name="GTWLinks" DataKeyNames="CountryCode,CityCode" AutoGenerateColumns="false" Visible="false" AllowSorting="true" ShowFooter="true" AllowPaging="true" PageSize="25">
                        <Columns>
                            <telerik:GridTemplateColumn>
                                <HeaderTemplate>
                                    Action
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <telerik:RadDropDownList runat="server" ID="Action">
                                        <Items>
                                            <telerik:DropDownListItem Text="Skip" Value="Skip" />
                                            <telerik:DropDownListItem Text="Approve" Value="Approve" Selected="true"/>
                                            <telerik:DropDownListItem Text="Reject" Value="Reject" />
                                            <telerik:DropDownListItem Text="Delete" Value="Delete" />
                                        </Items>
                                    </telerik:RadDropDownList>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <telerik:RadButton runat="server" ID="execute" Text="Execute" CommandName="Execute" CommandArgument="Links" />
                                </FooterTemplate>
                                <HeaderStyle Width="80px" />
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="OperationText" UniqueName="OperationText" HeaderText="Operation" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CountryName" UniqueName="CountryName" HeaderText="Country" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="100px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CountryCode" UniqueName="CountryCode" HeaderText="ISO" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="50px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CityCode" UniqueName="CityCode" HeaderText="City" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="100px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="DataCenter" UniqueName="DataCenter" HeaderText="DataCenter" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="StatusText" UniqueName="StatusText" HeaderText="Status" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                        </Columns>
                    </telerik:gridtableview>
                    <Telerik:GridTableView Name="GTWSubnets" DataKeyNames="Subnet,CIDR" AutoGenerateColumns="false" Visible="false" AllowSorting="true" ShowFooter="true" AllowPaging="true" PageSize="25">
                        <Columns>
                            <telerik:GridTemplateColumn>
                                <HeaderTemplate>
                                    Action
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <telerik:RadDropDownList runat="server" ID="Action">
                                        <Items>
                                            <telerik:DropDownListItem Text="Skip" Value="Skip" />
                                            <telerik:DropDownListItem Text="Approve" Value="Approve" Selected="true"/>
                                            <telerik:DropDownListItem Text="Reject" Value="Reject" />
                                            <telerik:DropDownListItem Text="Delete" Value="Delete" />
                                        </Items>
                                    </telerik:RadDropDownList>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <telerik:RadButton runat="server" ID="execute" Text="Execute" CommandName="Execute" CommandArgument="Subnets" />
                                </FooterTemplate>
                                <HeaderStyle Width="80px" />
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="OperationText" UniqueName="OperationText" HeaderText="Operation" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CountryName" UniqueName="CountryName" HeaderText="Country" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="100px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CountryCode" UniqueName="CountryCode" HeaderText="ISO" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="50px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SubnetText" UniqueName="SubnetText" HeaderText="Subnet" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="100px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Description" UniqueName="Description" HeaderText="Description" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SWCreateDate" UniqueName="SWCreateDate" HeaderText="Date" HeaderTooltip="" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="180px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="StatusText" UniqueName="StatusText" HeaderText="Status" HeaderTooltip="">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                        </Columns>
                    </Telerik:GridTableView>
                </DetailTables>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource runat="server" ID="SNSADContainer" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="select 'Sites' AS ADContainer, SUM(CASE StatusID WHEN 100 THEN 1 ELSE 0 END) AS Submitted, SUM(CASE StatusID WHEN 500 THEN 1 ELSE 0 END) AS Approved, SUM(CASE StatusID WHEN 900 THEN 1 ELSE 0 END) AS Rejected, Min(_CreateDate) AS FromDate, Max(_createDate) AS ToDate FROM SNSSites
                           UNION ALL
                           select 'Links' AS ADContainer, SUM(CASE StatusID WHEN 100 THEN 1 ELSE 0 END) AS Submitted, SUM(CASE StatusID WHEN 500 THEN 1 ELSE 0 END) AS Approved, SUM(CASE StatusID WHEN 900 THEN 1 ELSE 0 END) AS Rejected, Min(_CreateDate) AS FromDate, Max(_createDate) AS ToDate FROM SNSSitelinks
                           UNION ALL
                           select 'Subnets' AS ADContainer, SUM(CASE StatusID WHEN 100 THEN 1 ELSE 0 END) AS Submitted, SUM(CASE StatusID WHEN 500 THEN 1 ELSE 0 END) AS Approved, SUM(CASE StatusID WHEN 900 THEN 1 ELSE 0 END) AS Rejected, Min(_CreateDate) AS FromDate, Max(_createDate) AS ToDate FROM SNSSubnets"
            InsertCommand=""
            DeleteCommand=""
            UpdateCommand="">
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="SNSSites" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT S.CountryCode, S.CityCode, S.Description, S.SWCreateDate 
                                    ,CASE WHEN C.DSVName IS NULL THEN 'unknown' ELSE C.DSVName END AS CountryName
                                    ,O.OperationText
                                    ,STS.StatusText 
                            FROM SNSSites AS S
                            INNER JOIN SNSFlagOperation AS O ON o.OpCode = S.OpCode
                            INNER JOIN SNSStatus AS STS ON STS.StatusID = S.StatusID 
                            LEFT OUTER JOIN Country AS C ON C.Iso2 = S.CountryCode
                            WHERE S.StatusID = @StatusID"
            InsertCommand="DELETE FROM SNSSites"
            DeleteCommand="DELETE FROM SNSSites WHERE CountryCode=@CountryCode AND CityCode=@CityCode"
            UpdateCommand="UPDATE SNSSites SET StatusID=@StatusID WHERE CountryCode=@CountryCode AND CityCode=@CityCode">
            <SelectParameters>
                <asp:Parameter name="StatusID" Type="Int32" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="CountryCode" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="CityCode" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="StatusID" Type="Int32" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="CountryCode" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="CityCode" Type="String" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="SNSLinks" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT S.CountryCode, S.CityCode, S.DataCenter
                                    ,CASE WHEN C.DSVName IS NULL THEN 'unknown' ELSE C.DSVName END AS CountryName
                                    ,O.OperationText
                                    ,STS.StatusText 
                            FROM SNSSiteLinks AS S
                            INNER JOIN SNSFlagOperation AS O ON o.OpCode = S.OpCode
                            INNER JOIN SNSStatus AS STS ON STS.StatusID = S.StatusID 
                            LEFT OUTER JOIN Country AS C ON C.Iso2 = S.CountryCode
                            WHERE S.StatusID =@StatusID"
            InsertCommand="DELETE FROM SNSSiteLinks"
            DeleteCommand="DELETE FROM SNSSiteLinks WHERE CountryCode=@CountryCode AND CityCode=@CityCode"
            UpdateCommand="UPDATE SNSSiteLinks SET StatusID=@StatusID WHERE CountryCode=@CountryCode AND CityCode=@CityCode">
            <SelectParameters>
                <asp:Parameter name="StatusID" Type="Int32" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="CountryCode" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="CityCode" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="StatusID" Type="Int32" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="CountryCode" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="CityCode" Type="String" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="SNSSubnets" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT S.CountryCode, S.CityCode, S.Subnet+' / ' + CAST(S.CIDR as varchar) AS SubnetText, S.Description, S.SWCreateDate, S.Subnet, S.CIDR  
                                  ,CASE WHEN C.DSVName IS NULL THEN 'unknown' ELSE C.DSVName END AS CountryName
                                  ,O.OperationText
                                  ,STS.StatusText 
                             FROM SNSSubnets AS S
                            INNER JOIN SNSFlagOperation AS O ON o.OpCode = S.OpCode
                            INNER JOIN SNSStatus AS STS ON STS.StatusID = S.StatusID 
                            LEFT OUTER JOIN Country AS C ON C.Iso2 = S.CountryCode
                            WHERE S.StatusID = @StatusID"
            InsertCommand="DELETE FROM SNSSubnets"
            DeleteCommand="DELETE FROM SNSSubnets WHERE Subnet=@Subnet AND CIDR=@CIDR"
            UpdateCommand="UPDATE SNSSubnets SET Status=@StatusID WHERE Subnet=@Subnet AND CIDR=@CIDR">
            <SelectParameters>
                <asp:Parameter name="StatusID" Type="Int32" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="Subnet" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="CIDR" Type="Int32" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="StatusID" Type="Int32" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="Subnet" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="CIDR" Type="Int32" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>
