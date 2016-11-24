<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ExecutePS.aspx.vb" Inherits="Windows_ExecutePS" %>

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
        <asp:Label ID="PSID" runat="server" Text="" Visible="false" />
        <asp:Panel ID="pnlSetup" runat="server" Visible="true">
            <telerik:RadGrid runat="server" ID="RGpowershell" DataSourceID="sdsPowershell" AllowAutomaticDeletes="false" AllowAutomaticInserts="False" AllowAutomaticUpdates="False" ShowHeader="false">
                <MasterTableView DataSourceID="sdsPowershell" DataKeyNames="PSID" AutoGenerateColumns="False" Name="PowershellScrips">
                    <Columns>
                        <telerik:GridTemplateColumn>
                            <ItemTemplate>
                                <asp:Label runat="server" text='<%#Convert.ToString(Eval("name"))%>' ToolTip='<%#Convert.ToString(Eval("ParamName"))%>' />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="ParamName" HeaderText="" ReadOnly="true" Display="false" UniqueName="ParamName" />
                        <telerik:GridBoundColumn DataField="DataTypeID" HeaderText="" ReadOnly="true" Display="false" />
                        <telerik:GridBoundColumn DataField="Values" HeaderText="" ReadOnly="true" Display="false" />
                        <telerik:GridTemplateColumn UniqueName="Field">
                            <ItemTemplate>
                                <asp:label ID="Mandatory" runat="server">
                                    <telerik:RadTextBox ID="Field_1" runat="server" Visible="false" />
                                    <telerik:RadNumericTextBox ID="Field_2" runat="server" Visible="false" />
                                    <telerik:RadDatePicker ID="Field_3" runat="server" Visible="false" />
                                    <telerik:RadDropDownList ID="Field_4" runat="server" Visible="false" />
                                    <telerik:RadDropDownList ID="Field_5" runat="server" Visible="false" />
                                </asp:label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="Comment" HeaderText="" ReadOnly="true" />
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            <asp:Panel runat="server" CssClass="dialogPanel" >
                <telerik:RadButton runat="server" ID="Execute" Text="Execute"/>
            </asp:Panel>
            <asp:SqlDataSource runat="server" ID="sdsPowershell" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" 
                SelectCommand="SELECT PSID,ArgID,Name,ParamName,DataTypeID,DefaultValue,Mandatory,[Values], Comment, CASE PSID WHEN @PSID THEN 0 ELSE 1 END AS Locked FROM PowershellArgs AS PA  WHERE PA.PSID=@PSID OR PA.PSID=1 ORDER BY PA.PSID DESC, PA.SortOrder, PA.Name"
                InsertCommand="INSERT INTO PowershellHistory(Who,PSID,Params,ResultCodeID) VALUES(@Who,@PSID,@Params,@ResultCode)"
                UpdateCommand=""
                DeleteCommand=""
                >
                <SelectParameters>
                    <asp:ControlParameter Name="PSID" ControlID="PSID" PropertyName="Text"/>
                </SelectParameters>
                <DeleteParameters>
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="who" Type="String" ConvertEmptyStringToNull="true" />
                    <asp:Parameter Name="PSID" Type="Int32" ConvertEmptyStringToNull="true" />
                    <asp:Parameter Name="params" Type="String" ConvertEmptyStringToNull="true" />
                    <asp:Parameter Name="ResultCode" Type="Int32" ConvertEmptyStringToNull="true" />
                </InsertParameters>
                <UpdateParameters>
                </UpdateParameters>
            </asp:SqlDataSource>
        </asp:Panel>
        <asp:Panel ID="pnlResult" runat="server" Visible="false">
            <asp:Panel ID="exceptionPanel" runat="server" Visible="false" >
                <pre>
                    <asp:Label runat="server" ID="Exception" />
                </pre>
            </asp:Panel>
            <telerik:RadTabStrip runat="server" ID="TabStrip" RenderMode="Lightweight" MultiPageID="Multipage" Skin="Windows7">
                <Tabs>
                    <telerik:RadTab Text="Output" />
                    <telerik:RadTab Text="Messages" />
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage runat="server" ID="Multipage" SelectedIndex="0" Width="100%">
                <telerik:RadPageView runat="server" ID="View1" Width="100%">
                    <telerik:RadGrid runat="server" ID="PSOutput" AllowAutomaticDeletes="false" AllowAutomaticInserts="False" AllowAutomaticUpdates="False">
                        <MasterTableView DataKeyNames="RowID" AutoGenerateColumns="False" Name="PSOutput">
                            <Columns>
                                <telerik:GridTemplateColumn HeaderText="Text">
                                    <HeaderStyle Width="60px" />
                                    <ItemStyle VerticalAlign="Top" />
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="RowID" Text='<%#Convert.ToString(Eval("RowID"))%>' ToolTip='<%#Convert.ToString(Eval("ToolTip"))%>'/>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn UniqueName="Field" HeaderText="Result">
                                    <ItemStyle VerticalAlign="Top" />
                                    <ItemTemplate>
                                        <asp:label ID="Text" runat="server"/>
                                        <telerik:RadGrid runat="server" ID="Dataset" ShowHeader="true" AutoGenerateColumns="true">
                                            <MasterTableView AutoGenerateColumns="True" Name="DataSet">
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </telerik:RadPageView>
                <telerik:RadPageView runat="server" ID="View2" Width="100%">
                    <telerik:RadGrid runat="server" ID="PSMessage" AllowAutomaticDeletes="false" AllowAutomaticInserts="False" AllowAutomaticUpdates="False">
                        <MasterTableView DataKeyNames="Line" AutoGenerateColumns="False" Name="PSOutput">
                            <SortExpressions>
                                <telerik:GridSortExpression FieldName="Script" SortOrder="Ascending" />
                                <telerik:GridSortExpression FieldName="Line" SortOrder="Ascending" />
                            </SortExpressions>
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Type" DataField="Type" />
                                <telerik:GridBoundColumn HeaderText="Script" DataField="Script" />
                                <telerik:GridBoundColumn HeaderText="line" DataField="Line" />
                                <telerik:GridBoundColumn HeaderText="Message" DataField="Message" />
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </telerik:RadPageView>
            </telerik:RadMultiPage>
            <asp:Panel runat="server" >
                <table width="100%">
                    <tr>
                        <td colspan="2" width="100%">
                            <table>
                                <tr>
                                    <td width="32"><asp:Image runat="server" ID="ConfirmImg" ImageUrl="/Images/Question_32x32.png" /></td>
                                    <td width="*"><asp:Label runat="server" ID="ConfirmText" /></td> 
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" width="50%">
                            <telerik:RadButton runat="server" ID="Confirm" Text="Confirm" Visible="false" />
                        </td>
                        <td align="center" width="50%">
                            <telerik:RadButton runat="server" ID="Close" Text="Close"/>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </asp:Panel>
    </div>
    </form>
</body>
</html>
