<%@ Page Language="VB" AutoEventWireup="false" CodeFile="BaseData.aspx.vb" Inherits="Config_BaseData" %>

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
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <asp:Panel runat="server" ID="treePanel" Visible="true">
                        <telerik:RadPanelBar runat="server" ID="SelectPanel" ExpandMode="SingleExpandedItem" />
                    </asp:Panel>
                </td>
                <td style="vertical-align:top;">
                    <telerik:RadTabStrip runat="server" ID="Tabs" MultiPageID="TabPages" Skin="Windows7" SelectedIndex="0">
                        <Tabs>
                            <telerik:RadTab Text="Data" />
                            <telerik:RadTab Text="Table def" />
                            <telerik:RadTab Text="History" />
                            <telerik:RadTab Text="Debuginfo" />
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage runat="server" ID="TabPages" SelectedIndex="0">
                        <telerik:RadPageView runat="server" ID="DataEditPage">
                            <asp:Panel ID="panelAffectedTables" runat="server" Visible="false">
                                <span class="textred">Warning, the following tables is affected by any changes your are making:</span>
                                <telerik:RadGrid runat="server" ID="rgAffectedTables" DataSourceID="AffectedTables" ShowHeader="false">
                                    <MasterTableView runat="server" AutoGenerateColumns="false">
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="Name" HeaderText="Affected Tables" />
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <p />
                            </asp:Panel>
                            <telerik:RadWindow RenderMode="Lightweight" ID="modalPopup" runat="server" Width="450px" Height="360px" Modal="true" OffsetElementID="main" Skin="Windows7" Behaviors="Close" Title="Table filter" >
                                <ContentTemplate>
                                    <asp:UpdatePanel runat="server" ID="filterpanel">
                                        <ContentTemplate>
                                            <telerik:RadFilter ID="TableEditFilter" runat="server" FilterContainerID="rgTableEdit" ExpressionPreviewPosition="Bottom" ShowApplyButton="false" />
                                            <span style="float:right; margin-right:20px;">
                                                <telerik:RadButton runat="server" ID="ApplyFilter" Text="Apply" />
                                            </span>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </ContentTemplate>
                            </telerik:RadWindow>
                            <script type="text/javascript">
                                //<![CDATA[

                                function ShowFilterPopup(sender, args) {
                                    $find("<%=modalPopup.ClientID%>").show();
                                    return false;
                                }
                                function CloseFilterPopup() {
                                    $find("<%=modalPopup.ClientID%>").close();
                                    return false;
                                }
                                //]]>
                            </script>
                            <telerik:RadGrid runat="server" ID="rgTableEdit" DataSourceID="TableEdit" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
                                <MasterTableView runat="server" AutoGenerateColumns="true" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" EditMode="InPlace" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false">
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" UniqueName="ExportColumn" Exportable="false" AllowSorting="False" ShowFilterIcon="false" >
                                            <HeaderStyle Width="40px" VerticalAlign="Middle" />
                                            <HeaderTemplate>
                                                <telerik:RadButton Image-ImageUrl="~/Images/Excel_16x16.png" runat="server" ID="ExportExcel" Width="16" Height="16" skin="Windows7" CommandName="Export" CommandArgument="" />
                                                <telerik:RadButton Image-ImageUrl="~/Images/filter_16x16.png" runat="server" ID="FilterButton" Width="16" Height="16" skin="Windows7" OnClientClicked="ShowFilterPopup" AutoPostBack="false"  />
                                            </HeaderTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridEditCommandColumn UniqueName="EditColumn" Visible="false" Exportable="false" ShowFilterIcon="false"/>
                                        <telerik:GridButtonColumn Text="Delete" HeaderText="" CommandName="Delete" Visible="false" UniqueName="DeleteColumn" Exportable="false" />
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="TableDefPage">
                            <telerik:RadGrid runat="server" ID="RadGrid1" DataSourceID="AffectedTables" >
                                <MasterTableView runat="server" AutoGenerateColumns="false">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="Name" HeaderText="Affected Tables" />
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                            <telerik:RadGrid runat="server" ID="rgTableInfo" DataSourceID="TableInfo">
                                <MasterTableView runat="server" Name="TableInfo" DataSourceID="TableInfo" AutoGenerateColumns="false">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="name" HeaderText="Column" ReadOnly="true"/>
                                        <telerik:GridBoundColumn DataField="DataType" HeaderText="Datatype" ReadOnly="true" />
                                        <telerik:GridCheckBoxColumn DataField="is_nullable" HeaderText="Null" ReadOnly="true" StringTrueValue="1" />
                                        <telerik:GridCheckBoxColumn DataField="is_computed" HeaderText="Computed" ReadOnly="true" StringTrueValue="1" />
                                        <telerik:GridCheckBoxColumn DataField="is_identity" HeaderText="Identity" ReadOnly="true" StringTrueValue="1" />
                                        <telerik:GridCheckBoxColumn Datafield="is_primarykey" HeaderText="PrimaryKey" ReadOnly="true" StringTrueValue="1" />
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                            <telerik:RadGrid runat="server" ID="rgBaseData" DataSourceID="TableGroup">
                                <MasterTableView runat="server" Name="TableGroup" DataSourceID="TableGroup" AutoGenerateColumns="false" DataKeyNames="BaseDataID">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="BaseDataID" HeaderText="BaseGroupID" ReadOnly="true" Display="false" />
                                        <telerik:GridBoundColumn DataField="Description" HeaderText="Description" />
                                        <telerik:GridBoundColumn DataField="GroupName" HeaderText="GroupName" ReadOnly="true" />
                                        <telerik:GridBoundColumn DataField="BaseGroupID" HeaderText="GroupID" />
                                        <telerik:GridBoundColumn DataField="EditADGroup" HeaderText="AD Group" />
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>

                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="HistoryPage">
                            <telerik:RadGrid runat="server" ID="rgHistory" DataSourceID="BaseDataHistory" AllowPaging="true" PageSize="25" >
                                <MasterTableView runat="server" AutoGenerateColumns="false" DataKeyNames="HistoryID">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="Method" HeaderText="Operation" />
                                        <telerik:GridBoundColumn DataField="When" HeaderText="Date" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}" />
                                        <telerik:GridBoundColumn DataField="Who" HeaderText="Who" />
                                    </Columns>
                                    <DetailTables>
                                        <telerik:GridTableView runat="server" DataSourceID="BaseDataHistoryItem" AutoGenerateColumns="false">
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="HistoryID" MasterKeyField="HistoryID" />
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="name" HeaderText="Fieldname" />
                                                <telerik:GridBoundColumn DataField="OldValue" HeaderText="Old Value" />
                                                <telerik:GridBoundColumn DataField="NewValue" HeaderText="New Value" />
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>
                                </MasterTableView>
                            </telerik:RadGrid>

                        </telerik:RadPageView>
                        <telerik:RadPageView ID="Debug" runat="server">
                            <asp:Label runat="server" ID="TableName" text="" /><br /><!-- use Powershell / TestTable for testing -->
                            <asp:Label runat="server" ID="EditADGroup" Text="" /><br />
                            <asp:Label runat="server" ID="selectcmd" /><br />
                            <asp:Label runat="server" ID="updatecmd" /><br />
                            <asp:Label runat="server" ID="insertcmd" /><br />
                            <asp:Label runat="server" ID="deletecmd" /><br />
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </td>
            </tr>
        </table>

        <asp:SqlDataSource runat="server" ID="TableGroup" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="false" 
            SelectCommand="SELECT T.Name, BD.Description, BD.EditADGroup, BD.BaseDataID, BD.EditADGroup 
                            , CASE 
                                WHEN BDG.BaseName IS NOT NULL THEN BDG.BaseName
	                            WHEN TBDG.BaseName IS NOT NULL THEN TBDG.BaseName
	                            WHEN TBDG.BaseName IS NULL THEN 'Unknown'
                              END AS GroupName
                            , CASE
                                WHEN BDG.BaseGroupID IS NOT NULL THEN BDG.BaseGroupID
                                WHEN TBDG.BaseGroupID IS NOT NULL THEN TBDG.BaseGroupID
                                WHEN TBDG.BaseGroupID IS NULL THEN NULL
                              END AS BaseGroupID
                            FROM sys.tables AS T
                            LEFT OUTER JOIN BaseData AS BD ON BD.TableName = T.name 
                            LEFT OUTER JOIN BaseDataGroup AS BDG ON BDG.BaseGroupID = BD.BaseGroupID
                            LEFT OUTER JOIN BaseDataGroup AS TBDG ON TBDG.TablePrefix = SUBSTRING(T.name,1,len(TBDG.TablePrefix))
                            WHERE T.type = 'U' AND Substring(t.Name,1,1) <> '_' AND (T.Name = @TableName OR @TableName IS NULL)
                            ORDER BY GroupName, Name">
            <SelectParameters>
                <asp:ControlParameter Name="TableName" ControlID="TableName" PropertyName="Text" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="BaseData" ConnectionString="<%$ ConnectionStrings:DSVAsset %>"
            SelectCommand="SELECT * FROM BaseData AS BD  INNER JOIN BaseDataGroup AS BDG ON BDG.BaseGroupID = BD.BaseGroupID INNER JOIN sys.tables AS T ON T.name = BD.TableName AND T.type = 'U'"
            UpdateCommand="UPDATE BaseData SET BaseGroupID=@BaseGroupID, TableName=@TableName,Description=@Description, EditADGroup=@EditADGroup WHERE BaseDataID=@BaseDataID"
            InsertCommand="INSERT INTO BaseData(BaseGroupID,Tablename,Description,EditADGroup) VALUES (@BaseGroupID,@Tablename,@Description,@EditADGroup)"
            >
            <UpdateParameters>
                <asp:ControlParameter Name="TableName" ControlID="Tablename" PropertyName="Text" />
                <asp:Parameter Name="BaseGroupID" ConvertEmptyStringToNull="true" DbType="Int32" />
                <asp:Parameter Name="Description" ConvertEmptyStringToNull="true" DbType="String" />
                <asp:Parameter Name="EditADGroup" ConvertEmptyStringToNull="true" DbType="String" />
                <asp:Parameter Name="BaseDataID" ConvertEmptyStringToNull="true" DbType="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:ControlParameter Name="TableName" ControlID="Tablename" PropertyName="Text" />
                <asp:Parameter Name="BaseGroupID" ConvertEmptyStringToNull="true" DbType="Int32" />
                <asp:Parameter Name="Description" ConvertEmptyStringToNull="true" DbType="String" />
                <asp:Parameter Name="EditADGroup" ConvertEmptyStringToNull="true" DbType="String" />
            </InsertParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="TableInfo" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT c.name,y.name AS DataType ,c.is_nullable,c.is_computed,c.is_identity 
                            ,(SELECT count(1) FROM sys.index_columns AS IC INNER JOIN SYS.indexes AS I ON i.object_id = IC.object_id AND I.is_primary_key = 1 and i.index_id = ic.index_id  WHERE IC.object_id = T.object_id AND IC.column_id = C.column_id) AS is_primarykey
                            FROM SYS.tables AS T
                            INNER JOIN SYS.columns AS C ON C.object_id = T.object_id 
                            INNER JOIN SYS.types AS Y ON Y.user_type_id = C.user_type_id 
                            WHERE T.Name=@TableName">
            <SelectParameters>
                <asp:ControlParameter Name="TableName" ControlID="TableName" PropertyName="Text" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="TableEdit" ConnectionString="<%$ ConnectionStrings:DSVAsset %>"/>
        <asp:SqlDataSource runat="server" ID="AffectedTables" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT RT.* FROM sys.foreign_keys AS FK JOIN sys.tables AS PT ON PT.object_id = FK.referenced_object_id AND PT.Name = @Tablename JOIN Sys.tables AS RT ON RT.object_id = FK.parent_object_id ">
            <SelectParameters>
                <asp:ControlParameter Name="TableName" ControlID="TableName" PropertyName="Text" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="BaseDataHistory" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT [TableName],[HistoryID],[Method],[Who],[When] FROM [BaseDataHistory] Where [TableName]=@Tablename ORDER BY [When] DESC">
            <SelectParameters>
                <asp:ControlParameter Name="TableName" ControlID="TableName" PropertyName="Text" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="BaseDataHistoryItem" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            SelectCommand="SELECT [HistoryID],[Name],[OldValue],[NewValue] FROM [BaseDataHistoryItem] Where [HistoryID]=@HistoryID">
            <SelectParameters>
                <asp:Parameter Name="HistoryID" Type="Int64" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        
    </div>
    </form>
</body>
</html>
