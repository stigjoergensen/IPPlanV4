<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditPowershell.aspx.vb" Inherits="Config_EditPowershell" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<link href="/styles/Default.css" rel="stylesheet" />

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />

        <telerik:RadGrid runat="server" ID="RGpowershell" DataSourceID="sdsPowerShell" AutoGenerateColumns="False" MasterTableView-EditMode="InPlace" GroupPanelPosition="Top" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" >
            <MasterTableView DataSourceID="sdsPowerShell" DataKeyNames="PSID" AutoGenerateColumns="False" AllowSorting="true" CommandItemDisplay="Bottom" Name="PowershellScrips">
                <Columns>
                    <telerik:GridBoundColumn DataField="PSID" HeaderText="ID" ReadOnly="true" />
                    <telerik:GridBoundColumn DataField="Title" HeaderText="Title" />
                    <telerik:GridBoundColumn DataField="Hostname" HeaderText="Host" />
                    <telerik:GridBoundColumn DataField="Location" HeaderText="Path" />
                    <telerik:GridBoundColumn DataField="ScriptName" HeaderText="Script" />
                    <telerik:GridDropDownColumn DataField="MenuLocationID" HeaderText="Menu" DataSourceID="sdsPowershellMenuLocation" ListTextField="name" ListValueField="MenuLocationID" />
                    <telerik:GridCheckBoxColumn DataField="Enabled" DataType="System.Int32" HeaderText="Enabled" StringFalseValue="0" StringTrueValue="1" />
                    <telerik:GridBoundColumn DataField="Username" HeaderText="User" />
                    <telerik:GridBoundColumn DataField="Password" HeaderText="Password" />
                    <telerik:GridBoundColumn DataField="APIName" HeaderText="API" HeaderTooltip="Must be global unique" />
                    <telerik:GridDropDownColumn DataField="ExecModeID" HeaderText="Exec" DataSourceID="sdsPowershellExecMode" ListTextField="Name" ListValueField="ExecModeID" />
                    <telerik:GridEditCommandColumn CancelText="Cancel" EditText="Edit" ButtonType="LinkButton" UpdateText="Update" UniqueName="EditCommand" />
                    <telerik:GridButtonColumn UniqueName="DeleteCommand" Text="Delete" CommandName="Delete" HeaderText="" />
                </Columns>
                <GroupByExpressions>
                    <telerik:GridGroupByExpression>
                        <GroupByFields>
                            <telerik:GridGroupByField FieldName="MenuLocationID" HeaderText="Menu" HeaderValueSeparator="Menu: " FormatString="{0}" />
                        </GroupByFields>
                        <SelectFields>
                            <telerik:GridGroupByField FieldName="MenuName" />
                        </SelectFields>
                    </telerik:GridGroupByExpression>
                </GroupByExpressions>
                <CommandItemSettings AddNewRecordText="Add" />
                <DetailTables>
                    <telerik:GridTableView runat="server" DataSourceID="sdsPowershellArgs" AutoGenerateColumns="false" EditMode="InPlace" DataKeyNames="PSID,ArgID" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" CommandItemDisplay="Bottom" Name="Arguments" >
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="PSID" MasterKeyField="PSID" />
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="Name" HeaderText="FieldName" UniqueName="FieldName" />
                            <telerik:GridBoundColumn DataField="ParamName" HeaderText="Parameter name" UniqueName="ParamName" />
                            <telerik:GridDropDownColumn DataField="DataTypeID" HeaderText="Datatype" DataSourceID="sdsPowershellDataType" ListTextField="name" ListValueField="DataTypeID" UniqueName="DataTypeID" />
                            <telerik:GridCheckBoxColumn DataField="Mandatory" HeaderText="Mandatory" DataType="System.Int32" StringFalseValue="0" StringTrueValue="1" UniqueName="Mandatory" />
                            <telerik:GridBoundColumn DataField="Values" HeaderText="Values" UniqueName="Values" />
                            <telerik:GridBoundColumn DataField="Comment" HeaderText="Comment" UniqueName="Comment" />
                            <telerik:GridBoundColumn DataField="SortOrder" HeaderText="Order" UniqueName="Order" />
                            <telerik:GridEditCommandColumn CancelText="Cancel" EditText="Edit" ButtonType="LinkButton" UpdateText="Update" UniqueName="EditCommand" />
                            <telerik:GridButtonColumn UniqueName="DeleteCommand" Text="Delete" CommandName="Delete" HeaderText="" />
                        </Columns>
                        <CommandItemSettings AddNewRecordText="Add" />
                    </telerik:GridTableView>
                    <telerik:GridTableView runat="server" DataSourceID="sdsPowershellSecurity" AutoGenerateColumns="false" EditMode="InPlace" DataKeyNames="PSID,ADGroup" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" CommandItemDisplay="Bottom" >
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="PSID" MasterKeyField="PSID" />
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="ADGroup" HeaderText="Security Group" />
                        </Columns>
                        <CommandItemSettings AddNewRecordText="Add" />
                    </telerik:GridTableView>
                </DetailTables>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource runat="server" ID="sdspowershell" ConnectionString="<%$ ConnectionStrings:DSVAsset %>"  CancelSelectOnNullParameter="false"
            SelectCommand="SELECT PS.PSID, PS.Title, PS.Hostname, PS.Location, PS.ScriptName, PS.MenuLocationID, PS.Enabled, PS.Username, PS.Password, PS.ExecModeID, PS.APIName, CASE WHEN PSID = 1 THEN 1 ELSE 0 END AS Locked, PM.Name AS MenuName
                            FROM   Powershell AS PS INNER JOIN PowershellMenuLocation AS PM ON PS.MenuLocationID = PM.MenuLocationID
                            WHERE  (PS.PSID = @PSID) OR (@PSID IS NULL)"
            InsertCommand="INSERT INTO PowerShell(Title,Hostname,Location,ScriptName,MenuLocationID,Enabled,Username,Password,ExecModeID,APIName) VALUES (@Title,@Hostname,@Location,@ScriptName,@MenuLocationID,@Enabled,@Username,@Password,@ExecModeID,@APIName)"
            UpdateCommand="UPDATE PowerShell SET Title=@Title,Hostname=@Hostname,Location=@Location,ScriptName=@ScriptName,MenuLocationID=@MenuLocationID,Enabled=@Enabled,Username=@Username,Password=@Password,ExecModeID=@ExecModeID,APIName=@APIname WHERE PSID=@PSID"
            DeleteCommand="DELETE FROM Powershell WHERE PSID=@PSID"
            >
            <SelectParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="Title" ConvertEmptyStringToNull="true" Type="string" />
                <asp:Parameter Name="Hostname" ConvertEmptyStringToNull="true" Type="string" />
                <asp:Parameter Name="Location" ConvertEmptyStringToNull="true" Type="string" />
                <asp:Parameter Name="ScriptName" ConvertEmptyStringToNull="true" Type="string" />
                <asp:Parameter Name="MenuLocationID" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="Enabled" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="APIName" ConvertEmptyStringToNull="true" Type="String" />
                <asp:Parameter Name="Username" ConvertEmptyStringToNull="false" Type="string" />
                <asp:Parameter Name="Password" ConvertEmptyStringToNull="false" Type="string" />
                <asp:Parameter Name="ExecModeID" ConvertEmptyStringToNull="true" Type="Int32" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="Title" ConvertEmptyStringToNull="true" Type="string" />
                <asp:Parameter Name="Hostname" ConvertEmptyStringToNull="true" Type="string" />
                <asp:Parameter Name="Location" ConvertEmptyStringToNull="false" Type="string" />
                <asp:Parameter Name="ScriptName" ConvertEmptyStringToNull="true" Type="string" />
                <asp:Parameter Name="MenuLocationID" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="Enabled" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="Username" ConvertEmptyStringToNull="false" Type="string" />
                <asp:Parameter Name="Password" ConvertEmptyStringToNull="false" Type="string" />
                <asp:Parameter Name="ExecModeID" ConvertEmptyStringToNull="true" Type="Int32" />
                <asp:Parameter Name="APIName" ConvertEmptyStringToNull="true" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="sdsPowershellMenuLocation" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" SelectCommand="SELECT MenuLocationID,Name FROM PowershellMenuLocation"/>
        <asp:SqlDataSource runat="server" ID="sdsPowershellExecMode" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" SelectCommand="SELECT ExecModeID,Name FROM PowershellExecMode"/>
        <asp:SqlDataSource runat="server" ID="sdsPowershellArgs" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" 
            SelectCommand="SELECT PSID,ArgID,Name,ParamName,DataTypeID,DefaultValue,Mandatory,[Values], Comment, CASE PSID WHEN @PSID THEN 0 ELSE 1 END AS Locked, SortOrder FROM PowershellArgs AS PA  WHERE PA.PSID=@PSID OR PA.PSID=1 ORDER BY PA.PSID DESC, PA.SortOrder, PA.Name"
            InsertCommand="INSERT INTO PowershellArgs (PSID,Name,ParamName,DataTypeID,DefaultValue,Mandatory,[Values],Comment,SortOrder) VALUES(@PSID,@Name,@ParamName,@DatatypeID,@DefaultValue,@Mandatory,@Values,@Comment,@SortOrder)"
            UpdateCommand="UPDATE PowershellArgs SET ParamName=@ParamName, DatatypeID=@DatatypeID,DefaultValue=@DefaultValue,Mandatory=@Mandatory,[Values]=@Values,Name=@Name,Comment=@Comment,SortOrder=@SortOrder WHERE PSID=@PSID AND ArgID=@ArgID"
            DeleteCommand="DELETE FROM PowershellArgs WHERE PSID=@PSID AND ArgID=@ArgID"
            >
            <SelectParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ArgID" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Name" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="ParamName" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="DataTypeID" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="DefaultValue" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="Mandatory" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="Values" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="Comment" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="SortOrder" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="5000" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Name" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="ParamName" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="DataTypeID" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="DefaultValue" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="Mandatory" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="Values" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="ArgID" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="Comment" Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                <asp:Parameter Name="SortOrder" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="5000" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="sdsPowershellDataType" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" 
            SelectCommand="SELECT DataTypeID,Name FROM PowershellDatatype">
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="sdsPowershellSecurity" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" 
            SelectCommand="SELECT PSID, ADGroup FROM PowershellSecurity WHERE PSID=@PSID"
            InsertCommand="INSERT INTO PowershellSecurity (PSID,ADGroup) VALUES(@PSID,@ADGroup)"
            DeleteCommand="DELETE FROM PowershellSecurity WHERE PSID=@PSID AND ADGroup=@ADGroup"
            >
            <SelectParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ADGroup" ConvertEmptyStringToNull="true" Type="String" />
            </InsertParameters>
            <DeleteParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ADGroup" ConvertEmptyStringToNull="true" Type="String" />
            </DeleteParameters>
            </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="sdsPowershellHistory" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" 
            SelectCommand="SELECT TOP 20 PH.[When], Ph.Who, PH.Params, (SELECT Name FROM PowershellResultCode AS PRC WHERE PRC.ResultCodeID= PH.ResultCodeID) AS ResultText from PowershellHistory AS PH WHERE PH.PSID=@PSID ORDER BY PH.[When] DESC"
            >
            <SelectParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
