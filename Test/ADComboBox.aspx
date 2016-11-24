<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ADComboBox.aspx.vb" Inherits="Test_ADComboBox" %>
<%@ Register Src="~/UserControl/ADComboBox.ascx" TagPrefix="uc"  TagName="ADSearch" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <telerik:RadScriptManager runat="server" ID="ScriptManager">
        </telerik:RadScriptManager>
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
        <uc:ADSearch runat="server" Width="300" SearchClasses="group,person" ReturnAttribute="cn"  />
    </div>
    </form>
</body>
</html>
