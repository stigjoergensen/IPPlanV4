<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SNSBackup.aspx.vb" Inherits="Windows_SNS_SNSBackup" %>

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

        <telerik:RadGrid runat="server" ID="RGSNSBackup" DataSourceID="SNSBackup" AutoGenerateColumns="False" GroupPanelPosition="Top" PageSize="29" AllowPaging="true" ShowFooter="true">
            <MasterTableView  DataKeyNames="Filename" AutoGenerateColumns="false" AllowSorting="true">
                <Columns>
                    <telerik:GridBoundColumn DataField="Filename" HeaderText="Filename">
                        <HeaderStyle Width="300px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Filesize" HeaderText="Size">
                        <HeaderStyle Width="30px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Timestamp" HeaderText="Timestamp" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                        <HeaderStyle Width="100px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn>
                        <ItemTemplate>
                            <asp:LinkButton Text="Restore" OnClientClick='top.OpenWindowV1("/windows/ExecutePS.aspx?APIName=SNSRestore&Filename=<%Eval(Filename) %>&Execute=1","SNSRestore");' runat="server" ID="btnRestore" />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource runat="server" ID="SNSBackup" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM SNSBackup ORDER BY Timestamp DESC"
            InsertCommand=""
            DeleteCommand=""
            UpdateCommand="">
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
