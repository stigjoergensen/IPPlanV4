<%@ Control Language="VB" AutoEventWireup="false" CodeFile="VMWare.ascx.vb" Inherits="Windows_Host_Details_VMWare_VMWare" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />

<telerik:RadGrid runat="server" ID="rgVMWare" DataSourceID="VMWareGuest" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" DataKeyNames="ESXHost" >
        <Columns>
            <telerik:GridBoundColumn  DataField="ESXHost" HeaderText="Host" />
            <telerik:GridBoundColumn DataField="ConfigLun" HeaderText="Lun" />
            <telerik:GridCheckBoxColumn DataField="Housing" HeaderText="Housing" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridBoundColumn DataField="HousingCountry" HeaderText="Housing Country" />
            <telerik:GridBoundColumn DataField="VMPath" HeaderText="VMpath" />
            <telerik:GridBoundColumn DataField="ConfigPath" HeaderText="Config Path" />
            <telerik:GridBoundColumn DataField="WorkingLocation" HeaderText="Working Location" />
            <telerik:GridCheckBoxColumn DataField="_Active" HeaderText="Active" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridBoundColumn DataField="_LastUpdate" HeaderText="Last Updated" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
        <DetailTables>
            <telerik:GridTableView runat="server" AutoGenerateColumns="false" DataSourceID="VMWareHost" AllowFilteringByColumn="false">
                <ParentTableRelation>
                    <telerik:GridRelationFields DetailKeyField="ESXHost" MasterKeyField="ESXHost" />
                </ParentTableRelation>
                <Columns>
                    <telerik:GridBoundColumn DataField="vCenter" HeaderText="vCenter" />
                    <telerik:GridBoundColumn DataField="vCluster" HeaderText="Cluster" />
                    <telerik:GridBoundColumn DataField="vmDatacenter" HeaderText="vmDatacenter" />
                    <telerik:GridBoundColumn DataField="_LastUpdate" HeaderText="Last Updated" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
                    <telerik:GridCheckBoxColumn DataField="_Active" HeaderText="Active" StringTrueValue="1" StringFalseValue="0" />
                </Columns>
            </telerik:GridTableView>
        </DetailTables>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="VMWareGuest" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM VMWareGuest WHERE Hostname LIKE @Hostname+'%' AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="VMwareHost" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM VMWareHost WHERE ESXHost = @ESXHost">
    <SelectParameters>
        <asp:Parameter Name="ESXHost" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

