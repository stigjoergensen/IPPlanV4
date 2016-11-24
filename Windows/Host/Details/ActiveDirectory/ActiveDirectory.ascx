<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ActiveDirectory.ascx.vb" Inherits="Windows_Host_Details_ActiveDirectory_ActiveDirectory" %>
<%@ Register Src="~/UserControl/RowView.ascx" TagName="RowView" TagPrefix="userControl"  %>

<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<table>
    <tr valign="top">
        <td>
            <userControl:RowView runat="server" ID="ADComputerView" ViewName="ADComputers" AccessMethod="View" DataSourceID="ADComputers" ReadGroups="domain users" UpdateGroups="none" />
        </td>
        <td>
            <telerik:RadTreeView runat="server" ID="ADPathTree" DataFieldID="ID" DataFieldParentID="ParentID" DataTextField="Name" />
        </td>
    </tr>
</table>

<asp:SqlDataSource ID="ADComputers" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM ADComputers WHERE CN=@Hostname">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

