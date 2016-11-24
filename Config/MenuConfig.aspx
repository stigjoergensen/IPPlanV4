<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MenuConfig.aspx.vb" Inherits="Config_MenuConfig" %>
<%@ Register TagPrefix="CustomColumns" Namespace="CustomColumns" %>
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
        <telerik:RadTreeList runat="server" ID="MenuTree" DataSourceID="IPPlanV4Menu" DataKeyNames="MenuID" ParentDataKeyNames="ParentMenuID" AutoGenerateColumns="False" EditMode="InPlace" >
            <Columns>
                <telerik:TreeListBoundColumn DataField="MenuTitle" UniqueName="MenuTitle" HeaderText="Menu Title">
                    <HeaderStyle Width="120px" />
                </telerik:TreeListBoundColumn>
                <telerik:TreeListTemplateColumn DataField="MenuTypeID" UniqueName="MenuTypeID" HeaderText="Type">
                    <ItemTemplate>
                        <telerik:RadComboBox ID="RadComboBox1" runat="server" DataSourceid="IPPlanV4MenuType" SelectedValue='<%# Bind("MenuTypeID")%>' DataTextField="MenuTypeName" DataValueField="MenuTypeID" Enabled="false"/>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <telerik:RadComboBox ID="RadComboBox1" runat="server" DataSourceid="IPPlanV4MenuType" SelectedValue='<%# Bind("MenuTypeID")%>' DataTextField="MenuTypeName" DataValueField="MenuTypeID"/>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <telerik:RadComboBox ID="RadComboBox1" runat="server" DataSourceid="IPPlanV4MenuType" SelectedValue='<%# Bind("MenuTypeID")%>' DataTextField="MenuTypeName" DataValueField="MenuTypeID"/>
                    </InsertItemTemplate>
                    <HeaderStyle Width="90px" />
                    <ItemStyle Width="80px" />
                </telerik:TreeListTemplateColumn>
                <telerik:TreeListBoundColumn DataField="ExternalReference" UniqueName="ExternalReference" HeaderText="External" HeaderTooltip="used for ?Menu= parameter for default.aspx">
                    <HeaderStyle Width="100px" />
                </telerik:TreeListBoundColumn>
                <telerik:TreeListTemplateColumn DataField="MenuFunctionID" UniqueName="MenuFunctionD" HeaderText="Function">
                    <ItemTemplate>
                        <telerik:RadComboBox ID="MenuFunctionID" runat="server" DataSourceid="IPPlanV4MenuFunction" SelectedValue='<%# Bind("MenuFunctionID")%>' DataTextField="MenuFunction" DataValueField="MenuFunctionID" ToolTip='<%# Eval("MenuHelp") %>' Enabled="false"/>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <telerik:RadComboBox ID="MenuFunctionID" runat="server" DataSourceid="IPPlanV4MenuFunction" SelectedValue='<%# Bind("MenuFunctionID")%>' DataTextField="MenuFunction" DataValueField="MenuFunctionID" ToolTip='<%# Eval("MenuHelp") %>' OnClientSelectedIndexChanged="MenuFunctionID_ClientSelectedIndexChanged"/>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <telerik:RadComboBox ID="MenuFunctionID" runat="server" DataSourceid="IPPlanV4MenuFunction" SelectedValue='<%# Bind("MenuFunctionID")%>' DataTextField="MenuFunction" DataValueField="MenuFunctionID" ToolTip='' OnClientSelectedIndexChanged="MenuFunctionID_ClientSelectedIndexChanged"/>
                    </InsertItemTemplate>
                    <HeaderStyle Width="130px" />
                    <ItemStyle Width="120px" />
                </telerik:TreeListTemplateColumn>
                <telerik:TreeListBoundColumn DataField="MenuFunction" UniqueName="MenuFunction" HeaderText="Function Parameter">
                </telerik:TreeListBoundColumn>
                <telerik:TreeListBoundColumn DataField="MenuUrl" UniqueName="MenuUrl" HeaderText="URL">
                    <HeaderStyle Width="200px" />
                </telerik:TreeListBoundColumn>
                <telerik:TreeListBoundColumn DataField="SecurityGroups" UniqueName="SecurityGroups" HeaderText="Security" DefaultInsertValue="domain users">
                    <HeaderStyle Width="200px" />
                </telerik:TreeListBoundColumn>
                <CustomColumns:ValueSetColumn ValueSet="No=0,Yes=1" UniqueName="ForceVisible" HeaderText="Force Visible" DefaultInsertValue="0" DataField="ForceVisible">
                    <HeaderStyle Width="70px" />
                    <ItemStyle Width="60px" />
                </CustomColumns:ValueSetColumn>
                <telerik:TreeListNumericColumn DataField="SortOrder" UniqueName="SortOrder" HeaderText="Sorting" DecimalDigits="0" NumericType="Number" DefaultInsertValue="5000">
                    <HeaderStyle Width="70px" />
                </telerik:TreeListNumericColumn>
                <telerik:TreeListEditCommandColumn AddRecordText="Add" CancelText="Cancel" EditText="Edit" InsertText="Insert" ShowAddButton="true" ShowEditButton="true" HeaderText="">
                    <HeaderStyle Width="70px" />
                </telerik:TreeListEditCommandColumn>
                <telerik:TreeListButtonColumn UniqueName="DeleteCommandColumn" Text="Delete" CommandName="Delete" HeaderText="">
                    <HeaderStyle Width="40px" />
                </telerik:TreeListButtonColumn>
            </Columns>
        </telerik:RadTreeList>
        <asp:SqlDataSource runat="server" ID="IPPlanV4Menu" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT A.*,B.MenuHelp FROM IPPlanV4Menu AS A JOIN IPPlanV4MenuFunction AS B ON B.MenuFunctionID=A.MenuFunctionID ORDER BY A.ParentMenuID, A.SortOrder"
            InsertCommand="INSERT INTO IPPlanV4Menu (MenuTitle,ParentMenuID,MenuTypeID,MenuFunctionID,MenuFunction,MenuURL,SecurityGroups,SortOrder,ForceVisible,ExternalReference) VALUES(@MenuTitle,@ParentMenuID,@MenuTypeID,@MenuFunctionID,@MenuFunction,@MenuURL,@SecurityGroups,@SortOrder,@ForceVisible,@ExternalReference)"
            DeleteCommand="DELETE FROM IPPlanV4Menu WHERE MenuID=@MenuID"
            UpdateCommand="UPDATE IPPlanV4Menu SET MenuTitle=@MenuTitle,MenuTypeID=@MenuTypeID,MenuFunctionID=@MenuFunctionID,MenuFunction=@MenuFunction,MenuURL=@MenuURL,SecurityGroups=@SecurityGroups,SortOrder=@SortOrder,ForceVisible=@ForceVisible,ExternalReference=@ExternalReference WHERE MenuID=@MenuID">
            <InsertParameters>
                <asp:Parameter Name="MenuTitle" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ExternalReference" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ParentMenuID" Type="Int32" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MenuTypeID" Type="Int32" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MenuFunctionID" Type="Int32" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MenuFunction" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="SecurityGroups" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="SortOrder" Type="Int32" ConvertEmptyStringToNull="True" />
                <asp:Parameter Name="ForceVisible" Type="Int32" ConvertEmptyStringToNull="True" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="MenuTitle" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ExternalReference" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MenuTypeID" Type="Int32" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MenuFunctionID" Type="Int32" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MenuFunction" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="SecurityGroups" Type="String" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="SortOrder" Type="Int32" ConvertEmptyStringToNull="True" />
                <asp:Parameter Name="MenuID" Type="Int64" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ForceVisible" Type="Int32" ConvertEmptyStringToNull="True" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="MenuID" Type="Int64" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="IPPlanV4MenuType" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" SelectCommand="SELECT * FROM IPPlanV4MenuType"/>
        <asp:SqlDataSource runat="server" ID="IPPlanV4MenuFunction" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" CancelSelectOnNullParameter="false"  
            SelectCommand="SELECT * FROM IPPlanV4MenuFunction WHERE MenuFunctionID=@MenuFunctionID OR @MenuFunctionID IS NULL">
            <SelectParameters>
                <asp:Parameter Name="MenuFunctionID" Type="Int32" ConvertEmptyStringToNull="true" />
            </SelectParameters>
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
