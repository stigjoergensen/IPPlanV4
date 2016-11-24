<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SNSLog.aspx.vb" Inherits="Windows_SNS_SNSLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />

        <telerik:RadGrid runat="server" ID="RGSNSLog" DataSourceID="SNSLog" AutoGenerateColumns="False" GroupPanelPosition="Top" PageSize="29" AllowFilteringByColumn="true" AllowPaging="true">
            <MasterTableView  DataKeyNames="ROWID" AutoGenerateColumns="false" AllowSorting="true">
                <Columns>
                    <telerik:GridBoundColumn DataField="CountryCode" HeaderText="Country">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CityCode" HeaderText="City">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Text" HeaderText="Text">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="DataCenter" HeaderText="Datacenter">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="StatusText" HeaderText="Status">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="OperationText" HeaderText="Operation">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Subnet" HeaderText="Subnet">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CIDR" HeaderText="CIDR">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SWCreateDate" HeaderText="SWDate" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="_createDate" HeaderText="CreateDate" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource runat="server" ID="SNSLog" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT H.RowID,H.CountryCode,H.CityCode,H.Text,H.DataCenter,S.StatusText,O.OperationText,H.Subnet,H.CIDR,H.SWCreateDate,H._CreateDate FROM SNSHistory AS H
                            INNER JOIN SNSFlagOperation AS O ON O.OpCode = H.OpCode 
                            INNER JOIN SNSStatus AS S ON S.StatusID = H.StatusID  ORDER BY _CreateDate DESC"
            InsertCommand=""
            DeleteCommand=""
            UpdateCommand="">
            <UpdateParameters>
            </UpdateParameters>
            <DeleteParameters>
            </DeleteParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>
