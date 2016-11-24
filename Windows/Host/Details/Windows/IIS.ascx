<%@ Control Language="VB" AutoEventWireup="false" CodeFile="IIS.ascx.vb" Inherits="Windows_Host_Details_Windows_IIS" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<telerik:RadGrid runat="server" ID="rgIISSites" DataSourceID="IISSite" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" DataKeyNames="ID" >
        <Columns>
            <telerik:GridBoundColumn DataField="ID" Display="false" />
            <telerik:GridBoundColumn DataField="Sitename" HeaderText="Sitename" />
            <telerik:GridBoundColumn DataField="IISInstance" HeaderText="Instance" />
            <telerik:GridBoundColumn DataField="LogFolder" HeaderText="LogFolder" />
            <telerik:GridBoundColumn DataField="ApplicationName" HeaderText="Application Pool" />
            <telerik:GridBoundColumn DataField="RuntimeVersion" HeaderText="Version" />
            <telerik:GridCheckBoxColumn DataField="Enable128Bit" HeaderText="128b" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridCheckBoxColumn DataField="_active" HeaderText="Active" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
        <DetailTables>
            <telerik:GridTableView runat="server" AutoGenerateColumns="false" DataSourceID="IISSiteBinding" AllowFilteringByColumn="false">
                <ParentTableRelation>
                    <telerik:GridRelationFields DetailKeyField="ID" MasterKeyField="ID" />
                </ParentTableRelation>
                <Columns>
                    <telerik:GridBoundColumn DataField="Protocol" HeaderText="Protocol" />
                    <telerik:GridBoundColumn DataField="Host" HeaderText="Hostname" />
                    <telerik:GridBoundColumn DataField="EndPoint" HeaderText="Endpoint" />
                    <telerik:GridCheckBoxColumn DataField="_active" HeaderText="Active" StringTrueValue="1" StringFalseValue="0" />
                    <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
                </Columns>
            </telerik:GridTableView>
        </DetailTables>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="IISSite" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM IISSite WHERE Hostname = @Hostname AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="IISSiteBinding" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM IISSiteBinding WHERE ID=@ID">
    <SelectParameters>
        <asp:Parameter Name="ID" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

