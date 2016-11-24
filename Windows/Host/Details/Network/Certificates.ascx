<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Certificates.ascx.vb" Inherits="Windows_Host_Details_Network_Certificates" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<telerik:RadGrid runat="server" ID="rgHostCertificates" DataSourceID="HostCertificates" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" DataKeyNames="Thumbprint" >
        <Columns>
            <telerik:GridBoundColumn HeaderText="Thumbprint" DataField="Thumbprint" Display="false" />
            <telerik:GridBoundColumn HeaderText="Serial" DataField="SerialNumber" />
            <telerik:GridBoundColumn HeaderText="Friendly Name" DataField="FriendlyName" />
            <telerik:GridCheckBoxColumn HeaderText="Privatekey" DataField="HasPrivateKey" StringTrueValue="1" StringFalseValue="0" />
            <telerik:GridBoundColumn HeaderText="Expires" DataField="NotAfter" DataFormatString="{0:yyyy.MM.dd}" />
            <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
        <DetailTables>
            <telerik:GridTableView runat="server" AutoGenerateColumns="false" DataSourceID="CertificatesDB" AllowFilteringByColumn="false">
                <ParentTableRelation>
                    <telerik:GridRelationFields DetailKeyField="Thumbprint" MasterKeyField="Thumbprint" />
                </ParentTableRelation>
                <Columns>
                    <telerik:GridBoundColumn HeaderText="ThumbPrint" DataField="Thumbprint" />
                    <telerik:GridBoundColumn HeaderText="Issuer" DataField="Issuer" />
                    <telerik:GridBoundColumn HeaderText="Subject" DataField="Subject" />
                    <telerik:GridBoundColumn HeaderText="Created" DataField="NotBefore" DataFormatString="{0:yyyy.MM.dd}" />
                </Columns>
            </telerik:GridTableView>
            <telerik:GridTableView runat="server" AutoGenerateColumns="false" DataSourceID="CertificateExtension" AllowFilteringByColumn="false">
                <ParentTableRelation>
                    <telerik:GridRelationFields DetailKeyField="Thumbprint" MasterKeyField="Thumbprint" />
                </ParentTableRelation>
                <Columns>
                    <telerik:GridBoundColumn HeaderText="Type" DataField="ExtensionType" />
                    <telerik:GridBoundColumn HeaderText="Name" DataField="ExtensionName" />
                    <telerik:GridBoundColumn HeaderText="Value" DataField="ExtensionValue" />
                </Columns>
            </telerik:GridTableView>
        </DetailTables>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="HostCertificates" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT C.*, HC._LastUpdate FROM HostCertificate AS HC INNER JOIN Certificates AS C ON C.Thumbprint = HC.Thumbprint WHERE HC.Hostname = @Hostname AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="CertificatesDB" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM Certificates WHERE Thumbprint = @Thumbprint">
    <SelectParameters>
        <asp:Parameter Name="Thumbprint" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="CertificateExtension" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT * FROM CertificateExtension AS CE INNER JOIN CertificateExtensionTypes CET ON CET.ExtensionType = CE.ExtensionType WHERE CE.Thumbprint = @Thumbprint">
    <SelectParameters>
        <asp:Parameter Name="Thumbprint" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

