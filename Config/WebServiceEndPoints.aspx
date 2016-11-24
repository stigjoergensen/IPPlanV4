<%@ Page Language="VB" AutoEventWireup="false" CodeFile="WebServiceEndPoints.aspx.vb" Inherits="Config_WebServiceEndPoints" %>

<!DOCTYPE html>

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
        <telerik:RadGrid runat="server" ID="WebServiceEndPointsView" DataSourceID="WebServiceEndPoints" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" >
            <MasterTableView runat="server" AutoGenerateColumns="False" DataKeyNames="EndPointID" DataSourceID="WebServiceEndPoints" ShowHeader="true" EditMode="InPlace">
                <Columns>
                    <telerik:GridBoundColumn DataField="EndPointID" Display="false" />
                    <telerik:GridBoundColumn DataField="EndPointName" HeaderText="End Point" />
                    <telerik:GridDropDownColumn DataField="EndPointTypeID" HeaderText="Type" ListValueField="EndPointTypeID" ListTextField="EndPointTypeName" DataSourceID="WebServiceEndPointType" />
                    <telerik:GridTemplateColumn>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" ID="EditCommand" CommandName='<%# Telerik.Web.UI.RadGrid.EditCommandName%>' Text="Edit" />
                            <asp:LinkButton runat="server" ID="DeleteCommand" CommandName='<%# Telerik.Web.UI.RadGrid.DeleteCommandName%>' Text="Delete" />
                            <asp:LinkButton runat="server" ID="AddServerCommand" CommandName='AddServer' Text="Add Server" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton runat="server" ID="UpdateCommand" CommandName='<%# Telerik.Web.UI.RadGrid.UpdateEditedCommandName%>' Text="Update" />
                            <asp:LinkButton runat="server" ID="CancelCommand" CommandName='<%# Telerik.Web.UI.RadGrid.CancelCommandName %>' Text="Cancel" />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:LinkButton runat="server" ID="InsertCommandDone" CommandName='<%# Telerik.Web.UI.RadGrid.PerformInsertCommandName%>' Text="Insert" />
                            <asp:LinkButton runat="server" ID="CancelCommand" CommandName='<%# Telerik.Web.UI.RadGrid.CancelCommandName %>' Text="Cancel" />
                        </InsertItemTemplate>
                        <HeaderTemplate>
                            <asp:LinkButton runat="server" ID="InsertCommand" CommandName='<%# Telerik.Web.UI.RadGrid.InitInsertCommandName%>' Text="New" Font-Underline="true"  />
                        </HeaderTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
                <DetailTables>
                    <telerik:GridTableView runat="server" DataSourceID="WebServiceEndPointsServers" AutoGenerateColumns="False" DataKeyNames="EndPointID,EnvironmentID" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" EditMode="InPlace">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="EndPointID" MasterKeyField="EndPointID" />
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="EndPointID" Display="false" />
                            <telerik:GridDropDownColumn DataField="EnvironmentID" HeaderText="Environment" ListValueField="EnvironmentID" ListTextField="EnvironmentName" DataSourceID="IPPlanEnvironment" />
                            <telerik:GridBoundColumn DataField="ServerName" HeaderText="Server" />
                            <telerik:GridBoundColumn DataField="Port" HeaderText="Port" DataType="System.Int32"/>
                            <telerik:GridBoundColumn DataField="Path" HeaderText="Path" />
                            <telerik:GridBoundColumn DataField="Service" HeaderText="Service" />
                            <telerik:GridDropDownColumn DataField="AuthType" HeaderText="Authentication" ListValueField="AuthTypeID" ListTextField="AuthMethod" DataSourceID="WebServiceEndPointsAuthType" />
                            <telerik:GridBoundColumn DataField="Username" HeaderText="username" />
                            <telerik:GridBoundColumn DataField="password" HeaderText="Password" />
                            <telerik:GridTemplateColumn>
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ID="EditCommand" CommandName=<%# Telerik.Web.UI.RadGrid.EditCommandName%> Text="Edit" />
                                    <asp:LinkButton runat="server" ID="DeleteCommand" CommandName=<%# Telerik.Web.UI.RadGrid.DeleteCommandName%> Text="Delete" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton runat="server" ID="UpdateCommand" CommandName=<%# Telerik.Web.UI.RadGrid.UpdateEditedCommandName%> Text="Update" />
                                    <asp:LinkButton runat="server" ID="CancelCommand" CommandName=<%# Telerik.Web.UI.RadGrid.CancelCommandName %> Text="Cancel" />
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:LinkButton runat="server" ID="InsertCommandDone" CommandName=<%# Telerik.Web.UI.RadGrid.PerformInsertCommandName%> Text="Insert" />
                                    <asp:LinkButton runat="server" ID="CancelCommand" CommandName=<%# Telerik.Web.UI.RadGrid.CancelCommandName %> Text="Cancel" />
                                </InsertItemTemplate>
                                <HeaderTemplate>
                                    <asp:LinkButton runat="server" ID="InsertCommand" CommandName=<%# Telerik.Web.UI.RadGrid.InitInsertCommandName%> Text="New" Font-Underline="true"  />
                                </HeaderTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                        <DetailTables>
                            <telerik:GridTableView runat="server" DataSourceID="WebServiceEndPointMethods" AutoGenerateColumns="False" DataKeyNames="EndPointID, EnvironmentID,Name">
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="EndPointID" MasterKeyField="EndPointID" />
                                    <telerik:GridRelationFields DetailKeyField="EnvironmentID" MasterKeyField="EnvironmentID" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="EndPointID" Display="false" />
                                    <telerik:GridBoundColumn DataField="EnvironmentID" Display="false" />
                                    <telerik:GridBoundColumn DataField="Name" HeaderText="Name" />
                                    <telerik:GridBoundColumn DataField="ID" HeaderText="ID" />
                                    <telerik:GridBoundColumn DataField="URL" HeaderText="URL" />
                                    <telerik:GridBoundColumn DataField="Published" HeaderText="Published" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
                                    <telerik:GridBoundColumn DataField="Updated" HeaderText="Updated" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
                                    <telerik:GridBoundColumn DataField="Author" HeaderText="Author" />
                                    <telerik:GridTemplateColumn>
                                        <HeaderTemplate>
                                            <asp:LinkButton runat="server" ID="RefreshCommand" CommandName="RefreshServices" Text="Refresh" Font-Underline="true"  />
                                        </HeaderTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                                <DetailTables>
                                    <telerik:GridTableView runat="server" DataSourceID="WebServiceEndPointMethodParameters" AutoGenerateColumns="false" DataKeyNames="EndPointId,EnvironmentID,Name,parameterName">
                                        <ParentTableRelation>
                                            <telerik:GridRelationFields DetailKeyField="EndPointID" MasterKeyField="EndPointID" />
                                            <telerik:GridRelationFields DetailKeyField="EnvironmentID" MasterKeyField="EnvironmentID" />
                                            <telerik:GridRelationFields DetailKeyField="Name" MasterKeyField="Name" />
                                        </ParentTableRelation>
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="ParameterName" HeaderText="Name" />
                                            <telerik:GridBoundColumn DataField="ParameterType" HeaderText="Type" />
                                            <telerik:GridBoundColumn DataField="Direction" HeaderText="Direction" />
                                            <telerik:GridBoundColumn DataField="Description" HeaderText="Description" />
                                            <telerik:GridBoundColumn DataField="ParameterID" HeaderText="parameter ID" />
                                        </Columns>
                                    </telerik:GridTableView>
                                </DetailTables>
                            </telerik:GridTableView>
                            <telerik:GridTableView runat="server" DataSourceID="WebServiceEndPointsMap" AutoGenerateColumns="False" DataKeyNames="EndPointID, EnvironmentID" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" EditMode="InPlace">
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="EndPointID" MasterKeyField="EndPointID" />
                                    <telerik:GridRelationFields DetailKeyField="MappedEnvironmentID" MasterKeyField="EnvironmentID" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="EndPointID" Display="false" />
                                    <telerik:GridBoundColumn DataField="MappedEnvironmentID" Display="false" />
                                    <telerik:GridDropDownColumn DataField="EnvironmentID" HeaderText="From Environment" ListValueField="EnvironmentID" ListTextField="EnvironmentName" DataSourceID="IPPlanEnvironment" />
                                    <telerik:GridTemplateColumn>
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" ID="DeleteCommand" CommandName=<%# Telerik.Web.UI.RadGrid.DeleteCommandName%> Text="Delete" />
                                        </ItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:LinkButton runat="server" ID="InsertCommandDone" CommandName=<%# Telerik.Web.UI.RadGrid.PerformInsertCommandName%> Text="Insert" />
                                            <asp:LinkButton runat="server" ID="CancelCommand" CommandName=<%# Telerik.Web.UI.RadGrid.CancelCommandName %> Text="Cancel" />
                                        </InsertItemTemplate>
                                        <HeaderTemplate>
                                            <asp:LinkButton runat="server" ID="InsertCommand" CommandName=<%# Telerik.Web.UI.RadGrid.InitInsertCommandName%> Text="New" Font-Underline="true"  />
                                        </HeaderTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                            </telerik:GridTableView>
                        </DetailTables>
                    </telerik:GridTableView>
                </DetailTables>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:SqlDataSource runat="server" ID="WebServiceEndPointType" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM WebServiceEndPointType">
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="IPPlanEnvironment" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM IPPlanEnvironment">
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="WebServiceEndPointsAuthType" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM WebServiceEndPointsAuthType">
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="WebServiceEndPoints" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM WebServiceEndPoints"
            InsertCommand="INSERT INTO WebServiceEndPoints(EndPointTypeID,EndPointName) VALUES(@EndPointTypeID,@EndPointName);SELECT @EndPointID=SCOPE_IDENTITY()"
            UpdateCommand="UPDATE WebServiceEndPoints SET EndPointType=@EndPointType, EndPointName=@EndPointName WHERE EndPointID=@EndPointID"
            DeleteCommand="DELETE FROM WebServiceEndPoints WHERE EndPointID=@EndPointID">
            <InsertParameters>
                <asp:Parameter Name="EndPointTypeID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EndPointName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EndPointID" Direction="Output" Type="Int32" />
            </InsertParameters>
            <DeleteParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="EndPointTypeID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EndPointName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
        </asp:SqlDataSource>
    
        <asp:SqlDataSource runat="server" ID="WebServiceEndPointsServers" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM WebServiceEndPointsServers WHERE EndPointID=@EndPointID"
            UpdateCommand="UPDATE WebServiceEndPointsServers SET ServerName=@ServerName, Path=@Path, Service=@Service, Username=@Username, Password=@Password, AuthType=@AuthType, Port=@Port WHERE EndPointID=@EndPointID AND EnvironmentID=@EnvironmentID"
            InsertCommand="INSERT INTO WebServiceEndPointsServers(EndPointID,EnvironmentID,Servername,Path,Service,Username,Password,AuthType,Port) VALUES(@EndPointID,@EnvironmentID,@Servername,@Path,@Service,@Username,@Password,@AuthType,@Port)"
            DeleteCommand="DELETE FROM WebServiceEndPointsServers WHERE EndPointID=@EndPointID AND EnvironmentID=@EnvironmentID">
            <SelectParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EnvironmentID" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EnvironmentID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Path" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Service" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Username" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Password" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="AuthType" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Port" ConvertEmptyStringToNull="true" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EnvironmentID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="ServerName" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Path" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Service" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Username" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Password" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="AuthType" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Port" ConvertEmptyStringToNull="true" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="WebServiceEndPointMethods" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM WebServiceEndPointMethods WHERE EndPointID=@EndPointID">
            <SelectParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="WebServiceEndPointMethodParameters" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM WebServiceEndPointMethodParameters WHERE EndPointID=@EndPointID AND EnvironmentID=@EnvironmentID AND Name=@Name">
            <SelectParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EnvironmentID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Name" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource runat="server" ID="WebServiceEndPointsMap" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM WebServiceEndPointsMap WHERE EndPointID=@EndPointID AND MappedEnvironmentID=@MappedEnvironmentID"
            DeleteCommand="DELETE FROM WebServiceEndPointsMap WHERE EndPointID=@EndPointID AND EnvironmentID=@EnvironmentID"
            InsertCommand="INSERT INTO WebServiceEndPointsMap(EndpointID,EnvironmentID,MappedEnvironmentID) VALUES(@EndpointID,@EnvironmentID,@MappedEnvironmentID)">
            <SelectParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MappedEnvironmentID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EnvironmentID" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="EndPointID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EnvironmentID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="MappedEnvironmentID" ConvertEmptyStringToNull="true" />
            </InsertParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>
