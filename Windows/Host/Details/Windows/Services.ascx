<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Services.ascx.vb" Inherits="Windows_Host_Details_Windows_Services" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<telerik:RadGrid runat="server" ID="rgHostServices" DataSourceID="HostServices" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" >
        <Columns>
            <telerik:GridBoundColumn HeaderText="Name" DataField="ServiceName" />
            <telerik:GridBoundColumn HeaderText="Display name" DataField="DisplayName" />
            <telerik:GridBoundColumn HeaderText="Logon" DataField="StartName" />
            <telerik:GridBoundColumn HeaderText="Process" DataField="ProcessID" />
            <telerik:GridBoundColumn HeaderText="Start" DataField="StartMode" />
            <telerik:GridBoundColumn HeaderText="State" DataField="State" />
            <telerik:GridBoundColumn HeaderText="Status" DataField="Status" />
            <telerik:GridBoundColumn HeaderText="Exit" DataField="ExitCode" />
            <telerik:GridBoundColumn HeaderText="Error control" DataField="Error control" />
            <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="HostServices" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM HostServices WHERE Hostname = @Hostname AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>


