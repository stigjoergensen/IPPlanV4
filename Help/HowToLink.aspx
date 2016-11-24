<%@ Page Language="VB" AutoEventWireup="false" CodeFile="HowToLink.aspx.vb" Inherits="Help_HowToLink" %>

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
        <telerik:RadGrid runat="server" ID="rglinks" DataSourceID="IPPlanV4Menu" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
            <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false">
                <Columns>
                    <telerik:GridBoundColumn DataField="MenuLocation" HeaderText="Location" DataFormatString="<nobr>{0}</nobr>" />
                    <telerik:GridBoundColumn DataField="ExternalReference" HeaderText="Reference" />
                    <telerik:GridTemplateColumn HeaderText="URL" UniqueName="URL" >
                        <ItemTemplate>
                            <nobr><asp:Label ID="SiteName" runat="server" Text='<%# eval("SiteName") %>' /><asp:Label ID="ExternalReference" runat="server" Text='<%# Eval("ExternalReference")%>' /><asp:Label ID="Parameters" runat="server" Text="as" /></nobr>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <telerik:RadContextMenu runat="server" ID="HostMenu" />

        <asp:SqlDataSource ID="IPPlanV4Menu" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT @SiteName AS SiteName, [dbo].[get-IPPlanV4MenuLocation](MenuID) AS MenuLocation , * FROM IPPlanV4Menu WHERE ExternalReference IS NOT NULL ORDER BY ParentMenuID">
            <SelectParameters>
                <asp:Parameter Name="SiteName" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
