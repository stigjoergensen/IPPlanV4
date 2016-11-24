<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CPUs.ascx.vb" Inherits="Windows_Host_Details_Hardware_CPUs" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />


<telerik:RadGrid runat="server" ID="rgHHostCpu" DataSourceID="HostCpu" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" >
        <Columns>
            <telerik:GridBoundColumn HeaderText="Device" DataField="DeviceID" />
            <telerik:GridBoundColumn HeaderText="Address Width" DataField="AddressWidth" />
            <telerik:GridBoundColumn HeaderText="Data Width" DataField="DataWidth" />
            <telerik:GridBoundColumn HeaderText="Name" DataField="Caption" />
            <telerik:GridBoundColumn HeaderText="Clock" DataField="ClockSpeed" />
            <telerik:GridBoundColumn HeaderText="Cores" DataField="NumberOfCores" />
            <telerik:GridBoundColumn HeaderText="Sockets" DataField="Processors" />
            <telerik:GridBoundColumn HeaderText="Architecture" DataField="Architecture" />
            <telerik:GridBoundColumn HeaderText="Availability" DataField="Availability" />
            <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="HostCpu" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM HostCpu WHERE Hostname = @Hostname AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>


