<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Backup.ascx.vb" Inherits="Windows_Host_Details_Host_Backup" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<telerik:RadGrid runat="server" ID="rgBackup" DataSourceID="TSMScheduleStatus" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" >
        <Columns>
            <telerik:GridBoundColumn DataField="TSMinstance" HeaderText="TSM" />
            <telerik:GridBoundColumn DataField="PolicyDomain" HeaderText="Policy" />
            <telerik:GridBoundColumn DataField="ScheduleStart" HeaderText="Scheduled Start" />
            <telerik:GridBoundColumn DataField="ActualStart" HeaderText="Actual Start" />
            <telerik:GridBoundColumn DataField="Completed" HeaderText="Completed" />
            <telerik:GridBoundColumn DataField="Status" HeaderText="Status" />
            <telerik:GridBoundColumn DataField="Reason" HeaderText="Reason" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>

<asp:SqlDataSource ID="TSMScheduleStatus" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM TSMScheduleStatus WHERE Hostname = @Hostname ORDER BY ScheduleStart DESC">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>


