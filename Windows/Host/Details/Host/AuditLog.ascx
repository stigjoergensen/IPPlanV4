<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AuditLog.ascx.vb" Inherits="Windows_Host_Details_Host_AuditLog" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<telerik:RadGrid runat="server" ID="rgHostExtraDataHistory" DataSourceID="HostExtraDataHistory" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false">
        <Columns>
            <telerik:GridBoundColumn HeaderText="When" DataField="CreateDate" DataFormatString="{0:yyyy.MM.dd hh:mm}" />
            <telerik:GridBoundColumn HeaderText="Who" DataField="Who" />
            <telerik:GridBoundColumn HeaderText="Event" DataField="Description" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="HostExtraDataHistory" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM HostExtraDataHistory WHERE Hostname=@Hostname ORDER BY CreateDate DESC">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>