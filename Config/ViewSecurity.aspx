<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ViewSecurity.aspx.vb" Inherits="Config_ViewSecurity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<link href="styles/Default.css" rel="stylesheet" />
	<link href="styles/Menu.css" rel="stylesheet" />
</head>
<body>
    <form id="form2" runat="server" class="full">
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
    <div>
        <telerik:RadGrid runat="server" ID="SecurityView" DataSourceID="IPPlanV4ViewSecurityViews">
            <MasterTableView runat="server" AutoGenerateColumns="false" DataKeyNames="Viewname" DataSourceID="IPPlanV4ViewSecurityViews" ShowHeader="false">
                <Columns>
                    <telerik:GridBoundColumn DataField="Viewname"/>
                </Columns>
                <DetailTables>
                    <telerik:GridTableView runat="server" DataSourceID="IPPlanV4ViewSecurity" AutoGenerateColumns="false" DataKeyNames="SecurityID" AllowAutomaticUpdates="true" EditMode="InPlace" >
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="Viewname" MasterKeyField="Viewname" />
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="SecurityID" Display="false" />
                            <telerik:GridBoundColumn DataField="Viewname" Display="false" />
                            <telerik:GridBoundColumn DataField="KeyName" HeaderText="Field" ReadOnly="true" />
                            <telerik:GridBoundColumn DataField="KeyTitle" HeaderText="Title" />
                            <telerik:GridBoundColumn DataField="Formating" HeaderText="Format" />
                            <telerik:GridBoundColumn DataField="DefaultValue" HeaderText="Default Value" />
                            <telerik:GridNumericColumn DataField="SortOrder" HeaderText="Sort Order" MinValue="0" MaxValue="9999" />
                            <telerik:GridEditCommandColumn/>
                        </Columns>
                        <DetailTables>
                            <telerik:GridTableView runat="server" DataSourceID="IPPlanV4ViewSecurityGroup" AutoGenerateColumns="false" DataKeyNames="SecurityID" AllowAutomaticUpdates="True" EditMode="InPlace">
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="SecurityID" MasterKeyField="SecurityID" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="SecurityGroupsID" Display="false" />
                                    <telerik:GridBoundColumn DataField="SecurityID" Display="false" />
                                    <telerik:GridBoundColumn DataField="AccessMethod" HeaderText="Access type" ReadOnly="true" />
                                    <telerik:GridBoundColumn DataField="ReadGroups" HeaderText="Read Groups" />
                                    <telerik:GridBoundColumn DataField="WriteGroups" HeaderText="Write Groups" />
                                    <telerik:GridEditCommandColumn/>
                                </Columns>
                            </telerik:GridTableView>
                        </DetailTables>
                    </telerik:GridTableView>
                </DetailTables>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource runat="server" ID="IPPlanV4ViewSecurityViews" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT DISTINCT Viewname FROM IPPlanV4ViewSecurity ORDER BY ViewName">
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="IPPlanV4ViewSecurity" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM IPPlanV4ViewSecurity WHERE ViewName=@ViewName ORDER BY SortOrder"
            UpdateCommand="UPDATE IPPlanV4ViewSecurity SET KeyTitle=@KeyTitle, Formating=@Formating,DefaultValue=@DefaultValue,SortOrder=@SortOrder WHERE SecurityID=@SecurityID">
            <SelectParameters>
                <asp:Parameter Name="Viewname" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="KeyTitle" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Formating" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="DefaultValue" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Sortorder" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="SecurityID" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="IPPlanV4ViewSecurityGroup" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM IPPlanV4ViewSecurityGroup WHERE SecurityID=@SecurityID ORDER BY AccessMethod"
            UpdateCommand="UPDATE IPPlanV4ViewSecurityGroup SET ReadGroups=@ReadGroups, WriteGroups=@WriteGroups WHERE SecurityGroupID=@SecurityGroupID">
            <SelectParameters>
                <asp:Parameter Name="SecurityID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ReadGroups" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="WriteGroups" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="SecurityGroupID" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>

    <script>
        function MenuFunctionID_ClientSelectedIndexChanged(sender, eventArgs) {
            var value = eventArgs.get_item().get_value();
            //$(sender).attr("title", "I Have changed");
            //sender.get_selectedItem().get_element().title = " i have changed";
            //eventArgs.get_item().title = " i have changed";
            //debugger;
            //alert(MenuHelpArray[value-1]);
        }
    </script>
    </form>
</body>
</html>
