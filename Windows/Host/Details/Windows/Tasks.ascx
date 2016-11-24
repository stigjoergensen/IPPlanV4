<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Tasks.ascx.vb" Inherits="Windows_Host_Details_Windows_Tasks" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<telerik:RadGrid runat="server" ID="rgHostTask" DataSourceID="HostTask" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" >
        <Columns>
            <telerik:GridCheckBoxColumn HeaderText="System" DataField="SystemTask" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridBoundColumn HeaderText="Name" DataField="Taskname" />
            <telerik:GridBoundColumn HeaderText="Logon" DataField="RunAS" />
            <telerik:GridCheckBoxColumn HeaderText="Enabled" DataField="Enabled" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridBoundColumn HeaderText="Status" DataField="StatusID" />
            <telerik:GridBoundColumn HeaderText="Status" DataField="StatusText" />
            <telerik:GridBoundColumn HeaderText="Result" DataField="Result" />
            <telerik:GridBoundColumn HeaderText="Last Run" DataField="LastRunTime" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}" />
            <telerik:GridBoundColumn HeaderText="Next Run" DataField="NextRunTime" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}" />

            <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="HostTask" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM HostTask WHERE Hostname = @Hostname AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>


