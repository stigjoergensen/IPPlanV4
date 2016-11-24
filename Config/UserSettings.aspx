<%@ Page Language="VB" AutoEventWireup="false" CodeFile="UserSettings.aspx.vb" Inherits="Config_UserSettings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager runat="server" ID="ScriptManager" EnablePartialRendering="true"/>
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
        <div style="width:100%;">
            settings for <telerik:RadTextBox runat="server" ID="Username" Text="" TextMode="SingleLine" ReadOnly="true"/><telerik:RadButton runat="server" ID="find" Text="Find" />
            <telerik:RadGrid runat="server" ID="rgIPPlanV4Config" DataSourceID="IPPlanV4Config" ShowFooter="false" >
                <MasterTableView runat="server" AutoGenerateColumns="false" >
                    <Columns>
                        <telerik:GridBoundColumn DataField="KeyName" HeaderText="Name" ReadOnly="true" UniqueName="KeyNameColumn"/>
                        <telerik:GridTemplateColumn HeaderText="Value" UniqueName="ValueColumn">
                            <ItemTemplate>
                                <telerik:RadTextBox runat="server" ID="NewValue" Text='<%# eval("Keyvalue") %>' TextMode="SingleLine" />
                                <telerik:RadTextBox runat="server" ID="OldValue" Text='<%# eval("Keyvalue") %>' TextMode="SingleLine" Display="false"/>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="Description" HeaderText="Description" ReadOnly="true"/>
                        <telerik:GridBoundColumn DataField="ValueSet" HeaderText="Possible values" ReadOnly="true"/>
                        <telerik:GridBoundColumn DataField="EditADGroup" Display="false" />
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            <div style="width:100%;text-align:right;">
                <telerik:RadButton runat="server" ID="Save" Text="Save" ButtonType="StandardButton" />
            </div>
        </div>

    <asp:SqlDataSource ID="IPPlanV4Config" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
        SelectCommand="SELECT K.KeyName, K.Description, K.EditADGroup, C.KeyValue, K.ValueSet FROM IPPlanV4Config AS C
                        RIGHT OUTER JOIN IPPlanV4ConfigKeys AS K ON K.Keyname = C.KeyName AND K.Groupname = 'PersonalConfig'
                        WHERE C.Username = @Username OR C.Username IS NULL AND C.GroupName = 'PersonalConfig'
                        ORDER BY K.KeyName"
        UpdateCommand="UPDATE IPPlanV4Config SET KeyValue=@KeyValue WHERE Username=@Username AND KeyName=@KeyName AND GroupName = 'PersonalConfig'"
        InsertCommand="INSERT INTO IPPlanV4Config(Username,GroupName,KeyName,KeyValue) VALUES(@Username,'PersonalConfig',@Keyname,@Keyvalue)"
        >
        <SelectParameters>
            <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
        </SelectParameters>
        <UpdateParameters>
            <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="KeyName" Type="String" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="KeyValue" Type="String" ConvertEmptyStringToNull="true" />
        </UpdateParameters>
        <InsertParameters>
            <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="KeyName" Type="String" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="KeyValue" Type="String" ConvertEmptyStringToNull="true" />
        </InsertParameters>
    </asp:SqlDataSource>

    </form>
</body>
</html>
