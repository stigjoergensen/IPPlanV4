<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SPN.ascx.vb" Inherits="Windows_Host_Details_Windows_SPN" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />

<telerik:RadGrid runat="server" ID="rgHostSPN" DataSourceID="HostSPN" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" >
        <Columns>
            <telerik:GridBoundColumn DataField="SPN" HeaderText="SPN" />
            <telerik:GridBoundColumn DataField="ServiceName" HeaderText="Service name" />
            <telerik:GridBoundColumn DataField="AccountName" HeaderText="Service Account" />
            <telerik:GridBoundColumn DataField="Port" HeaderText="Port" />

            <telerik:GridCheckBoxColumn DataField="_Active" HeaderText="Active" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridBoundColumn DataField="_LastUpdate" HeaderText="Last Updated" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="HostSPN" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM HostSPN WHERE Hostname=@Hostname AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

