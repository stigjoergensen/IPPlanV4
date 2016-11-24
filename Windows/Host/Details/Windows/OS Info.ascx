<%@ Control Language="VB" AutoEventWireup="false" CodeFile="OS Info.ascx.vb" Inherits="Windows_Host_Details_Windows_OS_Info" %>
<%@ Register Src="~/UserControl/RowView.ascx" TagName="RowView" TagPrefix="userControl"  %>

<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<userControl:RowView runat="server" ID="OSView" ViewName="OperatingSystem" AccessMethod="View" DataSourceID="HostOS" ReadGroups="domain users" UpdateGroups="none" />

<asp:SqlDataSource ID="HostOS" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT TOP 1 * FROM HostOS AS H INNER JOIN MasterOS AS M ON M.ID = H.OSID  WHERE H.Hostname = @Hostname AND H._Active=1">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>