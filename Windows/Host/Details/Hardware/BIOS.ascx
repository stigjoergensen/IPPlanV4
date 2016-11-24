<%@ Control Language="VB" AutoEventWireup="false" CodeFile="BIOS.ascx.vb" Inherits="Windows_Host_Details_Hardware_BIOS" %>
<%@ Register Src="~/UserControl/RowView.ascx" TagName="RowView" TagPrefix="userControl"  %>

<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<userControl:RowView runat="server" ID="BiosView" ViewName="Bios" AccessMethod="View" DataSourceID="HostBios" ReadGroups="domain users" UpdateGroups="none" />

<asp:SqlDataSource ID="HostBios" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT TOP 1 * FROM HostBios WHERE Hostname = @Hostname AND _Active=1">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

