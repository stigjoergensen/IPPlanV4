<%@ Control Language="VB" AutoEventWireup="false" CodeFile="RowView.ascx.vb" Inherits="UserControl_RowView" %>

<telerik:RadGrid runat="server" ID="rgRowView" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" ShowHeader="false" >
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" >
        <Columns>
            <telerik:GridBoundColumn DataField="FieldTitle" HeaderText="Name" />
            <telerik:GridBoundColumn DataField="FieldValue" HeaderText="Value"/>
        </Columns>
    </MasterTableView>
</telerik:RadGrid>


<asp:SqlDataSource ID="IPPlanV4ViewSecurity" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
    SelectCommand="SELECT * FROM IPPlanV4ViewSecurity  AS V INNER JOIN IPPlanV4ViewSecurityGroup as G ON G.SecurityID = V.SecurityID WHERE V.ViewName = @ViewName AND G.AccessMethod = @AccessMethod"
    InsertCommand="INSERT INTO IPPlanV4ViewSecurity(ViewName,KeyName,KeyTitle) VALUES(@ViewName,@KeyName,@KeyTitle); SELECT @SecurityID=SCOPE_IDENTITY()">
    <SelectParameters>
        <asp:Parameter Name="ViewName" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="AccessMethod" ConvertEmptyStringToNull="true" />
    </SelectParameters>
    <InsertParameters>
        <asp:Parameter Name="ViewName" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="KeyName" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="KeyTitle" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="SecurityID" Direction="Output" DbType="Int64" />
    </InsertParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="IPPlanV4ViewSecurityGroup" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true"
    selectCommand="SELECT DISTINCT G.AccessMethod FROM IPPlanV4ViewSecurity  AS V INNER JOIN IPPlanV4ViewSecurityGroup as G ON G.SecurityID = V.SecurityID WHERE V.ViewName = @ViewName"
    InsertCommand="INSERT INTO IPPlanV4ViewSecurityGroup(SecurityID,AccessMethod,ReadGroups,WriteGroups) VALUES(@SecurityID,@AccessMethod,@ReadGroups,@WriteGroups)">
    <InsertParameters>
        <asp:Parameter Name="ViewName" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="SecurityID" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="AccessMethod" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="ReadGroups" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="WriteGroups" ConvertEmptyStringToNull="true" />
    </InsertParameters>
</asp:SqlDataSource>
