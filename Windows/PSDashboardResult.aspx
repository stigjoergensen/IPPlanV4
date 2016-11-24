<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PSDashboardResult.aspx.vb" Inherits="Windows_PSDashboardResult" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Panel runat="server" ID="PanelError" Visible="false">

        </asp:Panel>
        <asp:Panel runat="server" ID="PanelLog" Visible="false">

        </asp:Panel>
        <asp:Panel runat="server" ID="PanelTranscript" Visible="false">

        </asp:Panel>
        <asp:Panel runat="server" ID="PanelResult" Visible="false">

        </asp:Panel>
        <asp:Label runat="server" ID="LogID" Text="" />
    </div>
    </form>
</body>
</html>
