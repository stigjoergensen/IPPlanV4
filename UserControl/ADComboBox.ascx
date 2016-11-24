<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ADComboBox.ascx.vb" Inherits="UserControl_ADComboBox" %>
<asp:Panel runat="server" ID="ADSearchPanel">
<telerik:RadComboBox runat="server" ID="ADSearch" EnableLoadOnDemand="true" OnClientItemsRequesting="OnADComboBoxItemsRequesting" OnClientItemDataBound="onADComboBoxItemDataBound" AllowCustomText="true"  >
    <WebServiceSettings Method="Search"  Path="/Providers/ActiveDirectory.asmx" /> 
</telerik:RadComboBox>
</asp:Panel>
