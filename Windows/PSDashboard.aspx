<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PSDashboard.aspx.vb" Inherits="Windows_PSDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="/styles/PSDashboard.css" rel="stylesheet" />
    <script src="/Scripts/Windows.js"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
        <script type="text/javascript">
            function ShowPSResult(type, id) {
                OpenNewDialog('/windows/PSDashboardResult.aspx?Type=' + type + '&id=' + id, 'Powershell ' + type);
                return false;
            }
        </script>
    <div>
        <telerik:RadGrid runat="server" ID="RGPSScript" DataSourceID="PSScriptDefList" AutoGenerateColumns="False">
            <MasterTableView  DataKeyNames="PSID" AutoGenerateColumns="false" AllowSorting="true" Name="PSScriptDefList">
                <Columns>
                    <telerik:GridBoundColumn DataField="PSID" HeaderText="PSID" Display="false"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridBoundColumn DataField="Host" HeaderText="Hostname" UniqueName="Hostname"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridTemplateColumn HeaderText="Script" UniqueName="Script">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# "<nobr>" + System.IO.Path.GetFileName(Eval("ScriptName")) + "</nobr>"%>' ToolTip='<%# Eval("Description").ToString()%>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="NameExt"  HeaderText="Instance" UniqueName="instance"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridTemplateColumn HeaderText="Path" UniqueName="Path">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# "<nobr>" + System.IO.Path.GetDirectoryName(Eval("ScriptName")) + "</nobr>"%>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="Domain" HeaderText="Domain" UniqueName="Domain"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridBoundColumn DataField="VersionText" HeaderText="Version"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridBoundColumn DataField="Started" HeaderText="Start Time" UniqueName="StartTime" DataFormatString="<nobr>{0:yyyy-MM-dd HH:mm}</nobr>" />
                    <telerik:GridTemplateColumn HeaderText="Time Taken" UniqueName="TimeTaken">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# "<nobr>" + TimeTaken(Eval("Completed"), Eval("Started")) + "</nobr>"%>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="Avg Time" UniqueName="AvgTime" >
                        <ItemTemplate>
                            <asp:label runat="server" Text='<%# "<nobr>" + TimeTaken(Eval("AvgTime2")) + "</nobr>"%>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="Completed" Display="false"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridTemplateColumn HeaderText="Completed" UniqueName="Completed">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# "<nobr>" + IIf(Eval("Completed").ToString() = "", ETA(Eval("Started"), Eval("AvgTime2")), Eval("Completed", "{0:yyyy-MM-dd HH:mm}")) + "</nobr>"%>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="StateName" HeaderText="State" UniqueName="State"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridBoundColumn DataField="ErrorCount" HeaderText="Errors" UniqueName="Errors"  DataFormatString="<nobr>{0}</nobr>"/>
                    <telerik:GridCheckBoxColumn DataField="LogExists" HeaderText="Log" UniqueName="Log" StringFalseValue="0" StringTrueValue="1" DataType="System.Int32" />
                    <telerik:GridCheckBoxColumn DataField="TranscriptExists" HeaderText="Transcript" UniqueName="Transcript" StringFalseValue="0" StringTrueValue="1" DataType="System.Int32" />
                    <telerik:GridBoundColumn DataField="ResultText" HeaderText="Comment" UniqueName="Comment" DataFormatString="<nobr>{0}</nobr>" />
                </Columns>
                <DetailTables>
                    <telerik:GridTableView runat="server" DataSourceID="PSScriptDef" Name="PSScriptDef">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="PSID" MasterKeyField="PSID" />
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="Owner" HeaderText="Owner"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridBoundColumn DataField="CreateDate" HeaderText="Create Date" DataFormatString="<nobr>{0:yyyy-MM-dd HH:mm}</nobr>"/>
                            <telerik:GridBoundColumn DataField="ModifiedDate" HeaderText="Modified Date" DataFormatString="<nobr>{0:yyyy-MM-dd HH:mm}</nobr>"/>
                            <telerik:GridBoundColumn DataField="EstExecTime" HeaderText="Exec Time"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridBoundColumn DataField="MaxExecTimeDiffPct" HeaderText="Exec diff pct"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridBoundColumn DataField="TimeBetweenExec" HeaderText="Exec Freq"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridBoundColumn DataField="MaxErrors" HeaderText="Max Error"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridCheckBoxColumn DataField="MustHaveResult" HeaderText="Must have result" StringFalseValue="0" StringTrueValue="1" DataType="System.Int32"/>
                        </Columns>
                    </telerik:GridTableView>
                    <telerik:GridTableView runat="server" DataSourceID="PSScriptLog" Name="PSScriptLog">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="PSID" MasterKeyField="PSID" />
                            <telerik:GridRelationFields DetailKeyField="NameExt" MasterKeyField="NameExt" />
                            <telerik:GridRelationFields DetailKeyField="StartDate" MasterKeyField="Started" />
                            <telerik:GridRelationFields DetailKeyField="EndDate" MasterKeyField="Completed" />
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="NameExt" HeaderText="Instance"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridBoundColumn DataField="Started" HeaderText="Start Time" DataFormatString="<nobr>{0:yyyy-MM-dd HH:mm}</nobr>"/>
                            <telerik:GridBoundColumn DataField="Completed" HeaderText="End Time" DataFormatString="<nobr>{0:yyyy-MM-dd HH:mm}</nobr>"/>
                            <telerik:GridTemplateColumn HeaderText="Time Taken" UniqueName="TimeTaken">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# "<nobr>" + TimeTaken(Eval("Completed"), Eval("Started")) + "</nobr>"%>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="Username" HeaderText="Username"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridCheckBoxColumn DataField="is64BitProcess" HeaderText="64bit" StringFalseValue="0" StringTrueValue="1" DataType="System.Int32"/>
                            <telerik:GridBoundColumn DataField="StateName" HeaderText="State"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridBoundColumn DataField="ErrorCount" HeaderText="Errors"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridBoundColumn DataField="ResultText" HeaderText="Comment"  DataFormatString="<nobr>{0}</nobr>"/>
                            <telerik:GridTemplateColumn>
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Errors"  OnClientClick='<%# "ShowPSResult(""Error""," + Eval("ID").ToString() + ");return false;"%>' Visible='<%# Eval("ErrorCount") > 0 %>' />&nbsp;
                                    <asp:LinkButton runat="server" Text="Log" OnClientClick='<%# "ShowPSResult(""Log""," + Eval("ID").ToString() + ");return false;"%>' Visible='<%# Eval("LogExists").ToString() > "0"%>' />&nbsp;
                                    <asp:LinkButton runat="server" Text="Transcript" OnClientClick='<%# "ShowPSResult(""Transcript""," + Eval("ID").ToString() + ");return false;"%>' Visible='<%# Eval("TranscriptExists").ToString() > "0"%>' />&nbsp;
                                    <asp:LinkButton runat="server" Text="Result" OnClientClick='<%# "ShowPSResult(""Result""," + Eval("ID").ToString() + ");return false;"%>' Visible='<%# Eval("ResultExists").ToString() > "0"%>' />&nbsp;
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                    </telerik:GridTableView>
                </DetailTables>
            </MasterTableView>
        </telerik:RadGrid>


        <asp:SqlDataSource runat="server" ID="PSScriptDefList" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False"
            SelectCommand="SELECT *
                        , CAST(PSVersionMajor AS VARCHAR) + '.' + CAST(PSVersionMinor AS VARCHAR) AS VersionText
                        , (SELECT Count(*) FROM PSScriptError AS PSE WHERE PSE.ID=PS.ID) AS ErrorCount
                        , (SELECT TOP 1 1 FROM PSScriptLog AS PSL WHERE PSL.ID=PS.ID) AS LogExists
                        , (SELECT TOP 1 1 FROM PSScriptTranscript AS PST WHERE PST.ID =PS.ID) AS TranscriptExists
                        , (SELECT AVG((DATEDIFF(SECOND,[Started],[Completed]))) FROM PSScript AS PSA WHERE PSA.PSID=PSD.PSID AND PSA.NameExt = PSX.NameExt) AS AvgTime2
                        FROM PSScriptDef AS PSD 
				        CROSS APPLY (SELECT DISTINCT PSID,NameExt FROM PSScript AS PSS WHERE PSS.PSID = PSD.PSID) AS PSX
                        CROSS APPLY (SELECT TOP 1 * FROM PSScript AS PS WHERE PS.PSID = PSD.PSID AND PS.NameExt = PSX.NameExt ORDER BY ID DESC) AS PS
                        LEFT OUTER JOIN PSScriptState AS PSS ON PSS.StateID=PS.StateID
                        LEFT OUTER JOIN PSScriptResultCode AS PSR ON PSR.ResultCode = PS.ResultCode
                        WHERE (PS.Started > DATEADD(day,-35,GETDATE()) AND @PSID IS NULL) OR (PSD.PSID=@PSID)
                        ORDER BY PS.Started DESC">
            <SelectParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="PSScriptDef" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true"
            SelectCommand="SELECT * FROM PSScriptDef WHERE PSID=@PSID">
            <SelectParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="PSScriptLog" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False"
            SelectCommand="SELECT TOP (20) * 
                        , (SELECT Count(*) FROM PSScriptError AS PSE WHERE PSE.ID=PS.ID) AS ErrorCount
                        , (SELECT TOP 1 1 FROM PSScriptLog AS PSL WHERE PSL.ID=PS.ID) AS LogExists
                        , (SELECT TOP 1 1 FROM PSScriptTranscript AS PST WHERE PST.ID =PS.ID) AS TranscriptExists
                        , (SELECT TOP 1 1 FROM PSScriptResult AS PSR WHERE PSR.ID =PS.ID) AS ResultExists
                        FROM PSScript AS PS
                        LEFT OUTER JOIN PSScriptState AS PSS ON PSS.StateID=PS.StateID
                        LEFT OUTER JOIN PSScriptResultCode AS PSR ON PSR.ResultCode = PS.ResultCode
                        WHERE PSID=@PSID AND (NameExt=@NameExt OR @NameExt IS NULL) AND ([Started] > @StartDate OR @StartDate IS NULL) AND ([Started] <@EndDate OR @EndDate IS NULL) ORDER BY [Started] DESC">
            <SelectParameters>
                <asp:Parameter Name="PSID" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="NameExt" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="StartDate" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="EndDate" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>
