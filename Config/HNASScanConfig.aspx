<%@ Page Language="VB" AutoEventWireup="false" CodeFile="HNASScanConfig.aspx.vb" Inherits="Config_MenuConfig" %>
<%@ Register TagPrefix="CustomColumns" Namespace="CustomColumns" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<link href="styles/Default.css" rel="stylesheet" />
	<link href="styles/Menu.css" rel="stylesheet" />
</head>
<body>
    <!-- Threads, Config, Log -->
    <form id="form2" runat="server" class="full">
        <telerik:RadScriptManager runat="server" ID="ScriptManager" EnablePartialRendering="true" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
    <div>
        <telerik:RadTabStrip runat="server" MultiPageID="MultiPage1">
            <Tabs>
                <telerik:RadTab Text="Threads"/>
                <telerik:RadTab Text="Configuration" />
                <telerik:RadTab Text="Log" />
            </Tabs>
        </telerik:RadTabStrip>
        <telerik:RadMultiPage runat="server" ID="MultiPage1" SelectedIndex="0">
            <telerik:RadPageView runat="server" ID="RPVThreads">
                <telerik:RadGrid runat="server" ID="RGThreads" DataSourceID="HNASFileScanThreads" AutoGenerateColumns="false" PageSize="10" AllowPaging="true" EnableLinqExpressions="false" >
                    <MasterTableView DataSourceID="HNASFileScanThreads" DataKeyNames="SessionID,InstanceID,StateID,ThreadName" >
                        <PagerStyle AlwaysVisible="true" />
                        <Columns>
                            <telerik:GridBoundColumn DataField="StateID" Display="False" />
                            <telerik:GridImageColumn DataType="System.String" DataImageUrlFields="ImgColor" DataImageUrlFormatString="/images/bullet2_{0}.png" AlternateText="Customer image" DataAlternateTextField="imgColor" ImageAlign="Middle" HeaderText="" AllowFiltering="false" >
                                <HeaderStyle Width="20px" />
                            </telerik:GridImageColumn> 
                            <telerik:GridBoundColumn DataField="InstanceID" HeaderText="Inst">
                                <HeaderStyle Width="30px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ThreadName" HeaderText="Thread Name">
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Cnt" HeaderText="Count">
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Statename" HeaderText="State">
                                <HeaderStyle Width="70px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridButtonColumn HeaderText="Session" DataTextField="SessionID" CommandName="ShowLog"/>
                            <telerik:GridTemplateColumn AllowFiltering="false" >
                                <HeaderStyle Width="20px" />
                                <HeaderTemplate>
                                    <telerik:RadButton Image-ImageUrl="../Images/refresh_16x16.png" runat="server" AutoPostBack="true" ID="Refresh" Width="16" Height="16" OnClick="Refresh_Click1" skin="Windows7" />
                                </HeaderTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                        <DetailTables>
                            <telerik:GridTableView Name="Setup" DataSourceID="HNASFileScanThreadsDetails" DataKeyNames="InstanceID,StateID,ThreadName" AutoGenerateColumns="false" >
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="InstanceID" MasterKeyField="InstanceID" />
                                    <telerik:GridRelationFields DetailKeyField="StateID" MasterKeyField="StateID" />
                                    <telerik:GridRelationFields DetailKeyField="ThreadName" MasterKeyField="ThreadName" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="SubThreadID" HeaderText="Sub">
                                        <HeaderStyle Width="30px" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDateTimeColumn DataField="ChangeDate" HeaderText="Last change" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                                        <HeaderStyle Width="180px" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn DataField="Stage" HeaderText="Stage">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </telerik:GridTableView>
                        </DetailTables>
                    </MasterTableView>
                </telerik:RadGrid>
                <p/>
                <asp:UpdatePanel runat="server" ID="PanelTimer" UpdateMode="Conditional" >
                    <ContentTemplate>
                        <asp:Timer ID="Timer1" runat="server" Interval="30000"/>
                        <telerik:RadGrid runat="server" ID="rgHNASFileScanQueueProgress" DataSourceID="HNASFileScanQueueProgress">
                            <MasterTableView DataSourceID="HNASFileScanQueueProgress" AutoGenerateColumns="false">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="LastUpdate" HeaderText="Last Updated" DataFormatString="{0:yyyy.MM.dd HH:mm}"/>
                                    <telerik:GridBoundColumn DataField="Total" HeaderText="Total Folders" />
                                    <telerik:GridBoundColumn DataField="Completed" HeaderText="Completed folders" />
                                    <telerik:GridBoundColumn DataField="Processed" HeaderText="Processed folders" />
                                    <telerik:GridBoundColumn DataField="Remaining" HeaderText="Remaining folders" />
                                    <telerik:GridBoundColumn DataField="InProgress" HeaderText="Folders in progress" />
                                    <telerik:GridBoundColumn DataField="StartTime" HeaderText="Start Time" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}" />
                                    <telerik:GridBoundColumn DataField="EndDate" HeaderText="End Date" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}" />
                                    <telerik:GridBoundColumn DataField="FinishedPCT" HeaderText="Finished" DataFormatString="{0:F} %" />
                                    <telerik:GridBoundColumn DataField="TimeTakenHour" HeaderText="Time taken (Hour)" />
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <asp:SqlDataSource runat="server" ID="HNASFileScanQueueProgress" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                            SelectCommand="SELECT GETDATE() as LastUpdate
                                            , COUNT(*) AS Total ,Count(Completed) AS Completed ,Count(ProcessDate) AS Processed
                                            , COUNT(*) - COUNT(Completed) AS Remaining
                                            , (CAST(COUNT(Completed) AS Float) * 100) / Count(*) AS FinishedPCT, COUNT(ProcessDate) - Count(Completed) AS InProgress
                                            , MIN(ProcessDate) AS StartTime, MAX(Completed) As EndDate
                                            , CAST(DATEDIFF(minute,MIN(ProcessDate),MAX(Completed)) AS FLOAT) / 60 AS TimeTakenHour
                                            , (MAX(Completed) - MIN(ProcessDate)) AS TimeTaken
                                          FROM HNASFileScanQueue" />
                    </ContentTemplate>
                </asp:UpdatePanel>
                <asp:SqlDataSource runat="server" ID="HNASFileScanThreads" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                    SelectCommand="SELECT InstanceID,ThreadName,T.StateID,SessionID,StateName,ImgColor,Count(*) AS Cnt FROM HNASFileScanThreads AS T WITH (NOLOCK) JOIN HNASFileScanThreadState AS S ON S.StateID = T.StateID GROUP BY InstanceID,ThreadName,T.StateID,SessionID,StateName,ImgColor ORDER BY T.StateID DESC, InstanceID"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="HNASFileScanThreadsDetails" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                    SelectCommand="SELECT * FROM HNASFileScanThreads AS T WITH (NOLOCK) JOIN HNASFileScanThreadState AS S ON S.StateID = T.StateID WHERE InstanceID=@InstanceID AND T.StateID=@StateID AND ThreadName=@ThreadName ORDER BY T.StateID DESC, InstanceID, ChangeDate DESC "
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                    <SelectParameters>
                        <asp:Parameter Name="InstanceID" Type="Int32" />
                        <asp:Parameter Name="StateID" Type="Int32" />
                        <asp:Parameter Name="ThreadName" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </telerik:RadPageView>
            <telerik:RadPageView runat="server" ID="RPVConfig">
                <telerik:RadGrid runat="server" ID="RGConfig" DataSourceID="HNASFileScan" AutoGenerateColumns="false" MasterTableView-EditMode="InPlace" >
                    <MasterTableView DataSourceID="HNASFileScan" DataKeyNames="DirID" AutoGenerateColumns="false" CommandItemDisplay="Bottom" InsertItemDisplay="Bottom" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" AllowAutomaticInserts="true">
                        <Columns>
                            <telerik:GridBoundColumn DataField="DirID" Visible="false" ReadOnly="true" />
                            <telerik:GridBoundColumn HeaderText="Folder" DataField="RootFolder">
                                <HeaderStyle Width="250px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn HeaderText="Description" DataField="Description" />
                            <telerik:GridButtonColumn HeaderText="Config" DataTextField="Example" CommandName="ShowConfig"/>
                            <telerik:GridButtonColumn HeaderText="Queue" DataTextField="QueueLength" CommandName="ShowQueue">
                                <HeaderStyle Width="50px" />
                            </telerik:GridButtonColumn>
                            <telerik:GridboundColumn HeaderText="Max" DataField="MaxQueueLength">
                                <HeaderStyle Width="50px" />
                            </telerik:GridboundColumn>
                            <telerik:GridBoundColumn HeaderText="Enabled" DataField="Enabled">
                                <HeaderStyle Width="30px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn HeaderText="Level" DataField="ThreadStartLevel">
                                <HeaderStyle Width="30px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridEditCommandColumn EditText="Edit" CancelText="Cancel">
                                <HeaderStyle Width="70px" />
                            </telerik:GridEditCommandColumn>
                            <telerik:GridClientDeleteColumn>
                                <HeaderStyle Width="40px" />
                            </telerik:GridClientDeleteColumn>
                        </Columns>
                        <DetailTables>
                            <telerik:GridTableView Name="Setup" DataSourceID="HNASFileScanGroups" DataKeyNames="GroupID, DirID" AutoGenerateColumns="false" CommandItemDisplay="Bottom" EditMode="InPlace" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" InsertItemDisplay="Bottom" Visible="false" >
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="DirID" MasterKeyField="DirID" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="DirID" Visible="false" ReadOnly="true"  />
                                    <telerik:GridBoundColumn DataField="GroupID" Visible="false" ReadOnly="true" />
                                    <telerik:GridBoundColumn HeaderText="Part" DataField="Part">
                                        <HeaderStyle Width="30" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Description" DataField="PartDescription" />
                                    <telerik:GridEditCommandColumn EditText="Edit" CancelText="Cancel">
                                        <HeaderStyle Width="70px" />
                                    </telerik:GridEditCommandColumn>
                                    <telerik:GridClientDeleteColumn>
                                        <HeaderStyle Width="40px" />
                                    </telerik:GridClientDeleteColumn>
                                </Columns>
                            </telerik:GridTableView>
                            <telerik:GridTableView Name="Queue" DataSourceID="HNASFileScanQueue" DataKeyNames="QueueID, DirID" AutoGenerateColumns="false" PageSize="15" AllowPaging="true" Visible="false" AllowSorting="true" >
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="DirID" MasterKeyField="DirID" />
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="DirID" Visible="false" ReadOnly="true"  />
                                    <telerik:GridBoundColumn DataField="QueueID" Visible="false" ReadOnly="true" />
                                    <telerik:GridBoundColumn HeaderText="Instance" DataField="InstanceID">
                                        <HeaderStyle Width="30px" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Command" DataField="CmdName">
                                        <HeaderStyle Width="90px" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Parameter" DataField="CommandParam" />
                                    <telerik:GridBoundColumn HeaderText="Level" DataField="StartLevel">
                                        <HeaderStyle Width="30px" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Process" DataField="ProcessedBy">
                                        <HeaderStyle Width="90px" />
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDateTimeColumn HeaderText="Start" DataField="ProcessDate" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                                        <HeaderStyle Width="130px" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridDateTimeColumn HeaderText="Finished" DataField="Completed" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                                        <HeaderStyle Width="130px" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn HeaderText="Time taken" DataField="TimeTaken">
                                        <HeaderStyle Width="80px" />
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </telerik:GridTableView>
                        </DetailTables>
                    </MasterTableView>
                </telerik:RadGrid>
                <!-- SELECT '\' + CASE WHEN G.PartDescription IS NULL THEN '?' ELSE G.PartDescription END FROM HNASFileScanGroups AS G RIGHT OUTER JOIN (SELECT @DirID AS DirID, Counter AS C FROM Counter WHERE Counter < 10 AND Counter > 1) AS X ON X.C = G.Part AND X.DirID = G.DirId WHERE X.DirID=@DirID-->
                <asp:SqlDataSource runat="server" ID="HNASFileScan" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                    SelectCommand="SELECT S.*,'\\' + STUFF((SELECT '\' + G.PartDescription  FROM HNASFileScanGroups AS G WITH (NOLOCK) WHERE G.DirId = S.DirID FOR XML PATH ('')),1,1,'') AS Example, (SELECT Count(*) FROM HNASFileScanQueue AS Q WITH (NOLOCK) WHERE Q.DirID = S.DirId) AS MaxQueueLength, (SELECT Count(*) FROM HNASFileScanQueue AS Q WITH (NOLOCK) WHERE Q.DirID = S.DirId AND Q.Completed IS NULL) AS QueueLength FROM HNASFileScan AS S WITH (NOLOCK)"
                    InsertCommand="INSERT INTO HNASFileScan(RootFolder,Description,Enabled,ThreadStartLevel) VALUES(@RootFolder,@Description,@Enabled,@ThreadStartLevel)"
                    DeleteCommand="DELETE FROM HNASFileScan WHERE DirID=@DirID"
                    UpdateCommand="UPDATE HNASFileScan SET RootFolder=@RootFolder, Description=@Description, Enabled=@Enabled, ThreadStartLevel=@ThreadStartLevel WHERE DirID=@DirID">
                    <InsertParameters>
                        <asp:Parameter Name="RootFolder" />
                        <asp:Parameter Name="Description" />
                        <asp:Parameter Name="Enabled" />
                        <asp:Parameter Name="ThreadStartLevel" />
                    </InsertParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="DirID" />
                    </DeleteParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="RootFolder" />
                        <asp:Parameter Name="Description" />
                        <asp:Parameter Name="Enabled" />
                        <asp:Parameter Name="ThreadStartLevel" />
                        <asp:Parameter Name="DirID" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="HNASFileScanGroups" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                    SelectCommand="SELECT * FROM HNASFileScanGroups WITH (NOLOCK) WHERE DirID=@DirID"
                    InsertCommand="INSERT INTO HNASFileScanGroups (DirID,Part,PartDescription) VALUES (@DirID,@Part,@PartDescription)"
                    DeleteCommand="DELETE FROM HNASFileScanGroups WHERE DirID=@DirID AND GroupID=@GroupID"
                    UpdateCommand="UPDATE HNASFileScanGroups SET Part=@Part, Description=@Description WHERE DirID=@DirID AND GroupID=@GroupID">
                    <SelectParameters>
                        <asp:Parameter Name="DirID" Type="Int32" />
                    </SelectParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="DirID" Type="Int32" />
                        <asp:Parameter Name="GroupID" Type="Int32" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="DirID" Type="Int32" />
                        <asp:Parameter Name="Part" />
                        <asp:Parameter Name="partDescription" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="DirID" Type="Int32" />
                        <asp:Parameter Name="GroupID" Type="Int32" />
                        <asp:Parameter Name="Part" />
                        <asp:Parameter Name="partDescription" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="HNASFileScanQueue" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                    SelectCommand="SELECT * FROM HNASFileScanQueue AS Q WITH (NOLOCK) JOIN HNASFileScanQueueCmd AS C ON C.CmdID = Q.CmdID WHERE Q.DirID=@DirID ORDER BY Completed"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                    <SelectParameters>
                        <asp:Parameter Name="DirID" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </telerik:RadPageView>
            <telerik:RadPageView runat="server" ID="RPVLog">
                <telerik:RadGrid runat="server" ID="RGLog" DataSourceID="Log" AutoGenerateColumns="false" PageSize="25" AllowPaging="true" AllowFilteringByColumn="true" EnableLinqExpressions="false" >
                    <MasterTableView DataSourceID="Log" FilterExpression="([Severity] >= 2)" EditMode="EditForms" >
                        <EditFormSettings CaptionFormatString="Exception" EditFormType="Template">
                            <FormTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("Stack").ToString().Replace(vbCr, "<br>").Replace(" ", "&nbsp;")%>'/>
                            </FormTemplate>
                        </EditFormSettings>
                        <Columns>
                            <telerik:GridImageColumn DataType="System.String" DataImageUrlFields="ImgColor" DataImageUrlFormatString="/images/bullet2_{0}.png" AlternateText="Customer image" DataAlternateTextField="imgColor" ImageAlign="Middle" HeaderText="" AllowFiltering="false">
                                <HeaderStyle Width="20px" />
                            </telerik:GridImageColumn> 
                            <telerik:GridBoundColumn DataField="InstanceName" HeaderText="Instance" AllowFiltering="true">
                                <HeaderStyle Width="130px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Severity" HeaderText="" AllowFiltering="true" display="false"  UniqueName="Severity" CurrentFilterFunction="GreaterThanOrEqualTo" CurrentFilterValue="2"/>
                            <telerik:GridTemplateColumn DataField="Name" HeaderText="Severity" UniqueName="Stack" >
                                <ItemTemplate>
                                    <asp:LinkButton ID="linkbutton" runat="server" Text='<%# eval("Name") %>' CommandName="edit" />
                                    <asp:Label ID="label" runat="server" Text='<%# eval("Name") %>' />
                                </ItemTemplate>
                                <HeaderStyle Width="90px" />
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="rcbSeverity" DataSourceID="LogSeverity" DataTextField="Name"
                                        DataValueField="Severity" Height="200px" SelectedValue='<%# TryCast(Container, GridItem).OwnerTableView.GetColumn("Severity").CurrentFilterValue%>'
                                        runat="server" OnClientSelectedIndexChanged="SeverityIndexChanged">
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                        <script type="text/javascript">
                                            function SeverityIndexChanged(sender, args) {
                                                var tableView = $find("<%# TryCast(Container,GridItem).OwnerTableView.ClientID %>");
                                                tableView.filter("Severity", args.get_item().get_value(), "GreaterThanOrEqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="SessionID" HeaderText="Session">
                                <HeaderStyle Width="130px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="When" HeaderText="Date" DataFormatString="{0:yyyy.MM.dd HH:mm:ss}">
                                <HeaderStyle Width="180px" />
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn DataField="Message" HeaderText="Message"  AllowFiltering="false"/>
                            <telerik:GridTemplateColumn AllowFiltering="false">
                                <HeaderStyle Width="20px" />
                                <HeaderTemplate>
                                    <telerik:RadButton Image-ImageUrl="../Images/refresh_16x16.png" runat="server" AutoPostBack="true" ID="Refresh" Width="16" Height="16" OnClick="Refresh_Click" />
                                </HeaderTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
                <asp:SqlDataSource runat="server" ID="Log" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                    SelectCommand="SELECT L.LogID,l.InstanceName,l.Severity,l.SessionID,l.[When],l.Message,l.Stack,S.Name,S.imgColor FROM Log AS L WITH (NOLOCK) JOIN LogSeverity AS S ON S.Severity = L.Severity ORDER BY L.SessionID DESC, L.[when] DESC"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="LogSeverity" ConnectionString="<%$ ConnectionStrings:DSVHNAS%>" 
                    SelectCommand="SELECT * FROM LogSeverity"
                    InsertCommand=""
                    DeleteCommand=""
                    UpdateCommand="">
                </asp:SqlDataSource>
            </telerik:RadPageView>
        </telerik:RadMultiPage>
        

    </div>
    </form>
</body>
</html>
