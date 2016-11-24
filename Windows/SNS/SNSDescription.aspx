<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SNSDescription.aspx.vb" Inherits="Windows_SNS_SNSDescription" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />

        <telerik:RadGrid runat="server" ID="RGSNSDescription" DataSourceID="SNSDescription" AutoGenerateColumns="False" PageSize="29" AllowPaging="true" AllowAutomaticUpdates="true">
            <MasterTableView  DataKeyNames="DescriptionID" AutoGenerateColumns="false" AllowSorting="true" EditMode="InPlace" >
                <Columns>
                    <telerik:GridBoundColumn DataField="DescriptionID" Display="false" />
                    <telerik:GridBoundColumn DataField="DescriptionType" HeaderText="Type" AllowSorting="true" ReadOnly="true"/>
                    <telerik:GridBoundColumn DataField="DescriptionKey" HeaderText="Key" AllowSorting="true" ReadOnly="true"/>
                    <telerik:GridBoundColumn DataField="DescriptionValue" HeaderText="Value" AllowSorting="true" />
                    <telerik:GridCheckBoxColumn DataField="Modified" HeaderText="Modified" StringFalseValue="0" StringTrueValue="1" ReadOnly="true" />
                    <telerik:GridCheckBoxColumn DataField="Active" HeaderText="Active" StringFalseValue="0" StringTrueValue="1" ReadOnly="true" />
                    <telerik:GridEditCommandColumn />
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource runat="server" ID="SNSDescription" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM SNSDescription WHERE Active=1 ORDER BY DescriptionType, DescriptionKey"
            InsertCommand=""
            DeleteCommand=""
            UpdateCommand="UPDATE SNSDescription SET Modified=1, DescriptionValue=@DescriptionValue WHERE DescriptionID=@DescriptionID">
        <UpdateParameters>
            <asp:Parameter Name="DescriptionID" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="DescriptionValue" ConvertEmptyStringToNull="true" />
        </UpdateParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
