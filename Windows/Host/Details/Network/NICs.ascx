<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NICs.ascx.vb" Inherits="Windows_Host_Details_Network_NICs" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<telerik:RadGrid runat="server" ID="rgHostnetwork" DataSourceID="HostNetwork" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false">
        <Columns>
            <telerik:GridBoundColumn HeaderText="Name" DataField="NetworkName" />
            <telerik:GridBoundColumn HeaderText="IP Address" DataField="IPAddress" />
            <telerik:GridBoundColumn HeaderText="Netmask" DataField="Netmask" />
            <telerik:GridBoundColumn HeaderText="Gateway" DataField="Gateway" />
            <telerik:GridBoundColumn HeaderText="MACAddress" DataField="MACAddress" />
            <telerik:GridBoundColumn HeaderText="Vendor" DataField="Vendor" />
            <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="HostNetwork" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT HN.*, MNV.Vendor from HostNetwork AS HN LEFT OUTER JOIN MasterNicVendor AS MNV ON MNV.MAC2 = SUBSTRING(HN.MACAddress,3,6) WHERE HN.Hostname = @Hostname AND (HN._Active=1 or @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

