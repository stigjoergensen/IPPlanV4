<%@ Page Language="VB" AutoEventWireup="false" CodeFile="IPPlan.aspx.vb" Inherits="Windows_IPPlan" %>
<%@ Register Src="~/UserControl/ServerState.ascx"  TagPrefix="UC" TagName="ServerState" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="/Scripts/IPPlanSearch.js" ></script>
    <script type="text/javascript" src="/Scripts/Windows.js" ></script>
    <script type="text/javascript" src="/Scripts/Menu.js" ></script>
    <script>
    function StateImageLoad(img, hostname,EnvironmentID) {
        IPPlan.ServerStateService.GetServerState(img.id, hostname, EnvironmentID, SetServerState);
    }

    function SetServerState(result) {
        img = document.getElementById(result.Element);
        img.src = result.ImagePath;
        img.title = result.ToolTip;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <telerik:RadScriptManager runat="server" ID="ScriptManager">
    </telerik:RadScriptManager>
    <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
        <asp:ScriptManagerProxy runat="server" ID="ScriptmanagerProxy">
            <Services>
                <asp:ServiceReference Path="~/Providers/ServerStateService.asmx" />
            </Services>
        </asp:ScriptManagerProxy>
    <asp:Label runat="server" ID="username" Visible="false" />
    <asp:Label runat="server" ID="DisplayLimit" Text="50" Visible="false" />

    <telerik:RadGrid runat="server" ID="rgIPPlan" DataSourceID="IPPlan" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
        <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false">
            <Columns>
                <telerik:GridTemplateColumn>
                    <ItemTemplate>
                        <UC:ServerState runat="server" ID="ServerState" Hostname='<%# Eval("Hostname")%>' EnvironmentID='<%# Eval("EnvironmentID")%>'   />
                        <telerik:RadContextMenu ID="HostMenu" CssClass="mainMenu" runat="server" EnableRoundedCorners="true" EnableShadows="true" OnClientItemClicked="MenuItemClicked" >
                            <Targets>
                                <telerik:ContextMenuElementTarget ElementID="" />
                            </Targets>
                            <WebServiceSettings Method="GetMenu" Path="/Providers/MenuProvider.asmx" />
                            <Items>
                                <telerik:RadMenuItem Text="Hostmenu" ExpandMode="WebService" Value="Menu:2" />
                            </Items>
                        </telerik:RadContextMenu>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="Hostname" HeaderText="Hostname" UniqueName="Hostname" />
                <telerik:GridBoundColumn DataField="Term" HeaderText="Terminated" />
                <telerik:GridBoundColumn DataField="Function" HeaderText="Function" />
                <telerik:GridBoundColumn DataField="Environment" HeaderText="Environment" />
                <telerik:GridBoundColumn DataField="Service" HeaderText="Service" />
                <telerik:GridBoundColumn DataField="AppID" HeaderText="Apps" />
                <telerik:GridBoundColumn DataField="Patch" HeaderText="Patch" />
                <telerik:GridBoundColumn DataField="TimeName" HeaderText="Time" />
                <telerik:GridBoundColumn DataField="SCOM" HeaderText="SCOM" />
                <telerik:GridBoundColumn DataField="location" HeaderText="location" />
                <telerik:GridBoundColumn DataField="Country" HeaderText="Country" />
                <telerik:GridBoundColumn DataField="Responsible" HeaderText="Responsible" />
                <telerik:GridBoundColumn DataField="Owner" HeaderText="Owner" />
                <telerik:GridBoundColumn DataField="Contact" HeaderText="Contact" />
                <telerik:GridBoundColumn DataField="ManagementID" HeaderText="ManagementIP" />
                <telerik:GridBoundColumn DataField="Days" HeaderText="Days" />
                <telerik:GridBoundColumn DataField="Approved" HeaderText="Approved" />
                <telerik:GridBoundColumn DataField="ApprovalRequired" HeaderText="Required" />
                <telerik:GridTemplateColumn UniqueName="HiddenData" Visible="false" >
                    <ItemTemplate>
                        <asp:TextBox runat="server" ID="HiddenData" />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    <telerik:RadContextMenu runat="server" ID="HostMenu" />

    <asp:SqlDataSource ID="IPPlan" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
        SelectCommand="SELECT DISTINCT TOP (@DisplayLimit) HED.Hostname,
                                       CAST((CASE WHEN HED.EndOfLife IS NULL THEN 0 ELSE 1 END) AS Bit) AS Term,
                                       HED.[Function], IPE.EnvironmentName AS [Environment], HED.EnvironmentID,
                                       MasterService.ServiceShortName AS [Service],
        		                		STUFF((SELECT ', '+ CAST(ID AS VARCHAR) FROM HostEAPLink WITH (NOLOCK) WHERE RecordType = 'APP' and Hostname = [HED].[Hostname] FOR XML PATH('')), 1, 2, '') AS AppID,
		        		                [PA].[Name] as [Patch], TimeName,[OperationalMode] as [SCOM],[Location],[Country],[Responsible],[Owner],[Contact],[ManagementIP],
                                       CASE WHEN PS.Value IS NULL THEN 0 ELSE 1 END AS MyList,
									   SPS.Days, SPS.Approved, SPS.ApprovalRequired
                      FROM HostExtraData AS HED WITH (NOLOCK)
                      LEFT OUTER JOIN PatchServiceWindowHostname AS PSWH WITH (NOLOCK) ON PSWH.Hostname = HED.Hostname AND PSWH.ServiceWindowID = 1 
                      LEFT OUTER JOIN PatchApply AS PA WITH (NOLOCK) ON PA.DateID = PSWH.DateID
                      LEFT OUTER JOIN PatchTimeHostname AS PTH WITH (NOLOCK) ON PTH.hostname = HED.Hostname 
                      LEFT OUTER JOIN PatchTime AS PT WITH (NOLOCK) ON PT.TimeID = PTH.Timeid
                      LEFT OUTER JOIN IPPlanOperationMode AS IPOM WITH (NOLOCK) ON IPOM.ID = HED.OperationMode
                      LEFT OUTER JOIN HostBios AS HB WITH (NOLOCK) ON HB.Hostname = HED.Hostname
                      LEFT OUTER JOIN HostNetwork AS HN WITH (NOLOCK) ON HN.Hostname = HED.Hostname AND HN._active = 1
                      LEFT OUTER JOIN HostOS AS HO WITH (NOLOCK) ON Ho.Hostname = HED.Hostname
                      LEFT OUTER JOIN IPPlanEnvironment AS IPE WITH (NOLOCK) ON IPE.EnvironmentID = HED.EnvironmentID
                      LEFT OUTER JOIN MasterService WITH (NOLOCK) ON MasterService.ServiceID = HED.ServiceID
                      LEFT OUTER JOIN HostCertificate AS HC WITH (NOLOCK) ON HC.Hostname = HED.Hostname 
                      LEFT OUTER JOIN HostEAPLink AS HEL WITH (NOLOCK) ON HEL.Hostname = HED.Hostname AND RecordType='APP'
                      LEFT OUTER JOIN CertificateExtension AS CE WITH (NOLOCK) ON CE.Thumbprint = HC.Thumbprint AND CE.ExtensionType = 1 AND (CE.ExtensionValue = @CertificateName OR CE.ExtensionValue = @CertificateName+'.dsv.com' OR @CertificateName IS NULL)
                      LEFT OUTER JOIN PersonalSetting AS PS WITH (NOLOCK) ON PS.Value = HED.Hostname AND PS.Username=@Username AND PS.GroupName='MyList' AND PS.KeyName ='Hostname'
   					  CROSS APPLY(SELECT TOP 1 [Days],[ApprovalRequired],[Approved] FROM SCCMPatchSchedule_Cache AS SPS WITH (NOLOCK) WHERE SPS.Hostname = HED.Hostname) SPS
                       WHERE ((@QAppID IS NOT NULL) AND (HEL.ID in (@QAppID)))
                         OR ((@QAppID IS NULL )
                            AND ((HED.EndOfLife IS NULL) OR (@IncludeTerminated='true'))
                            AND ((HED.Hostname = @hostname) OR (@Hostname IS NULL) OR (HED.Hostname like '%' + @Hostname + '%'))
                            AND ((HED.Asset like '%'+@Asset+'%') OR (@Asset IS NULL))
                            AND ((HED.[Function] like '%'+@Function+'%') OR (HED.[FunctionAlias] like '%'+@Function+'%') OR (@Function IS NULL))
                            AND ((HED.Country = @Country) OR (@Country IS NULL))
                            AND ((HED.AssignedIP like '%'+@AssignedIP+'%') OR (@AssignedIP IS NULL))
                            AND ((HED.ManagementIP like '%'+@ManagementIP+'%') OR (@ManagementIP IS NULL))
                            AND ((HED.EnvironmentID = @EnvironmentID) OR (@EnvironmentID IS NULL))
                            AND ((HB.SerialNumber like '%'+@SerialNumber+'%') OR (@SerialNumber IS NULL))
                            AND ((HN.IPAddress like '%'+@IPAddress+'%') OR (@IPAddress IS NULL))
                            AND ((HN.MACAddress = @MACAddress) OR (@MACAddress IS NULL))
                            AND ((PSWH.DateID = @DateID) OR (@DateID IS NULL))
                            AND ((HEL.ID IN (@AppID)) OR (@AppID IS NULL))
                            AND ((HO.OSID in (@OSID)) OR (@OSID IS NULL))
                            AND ((MasterService.ServiceID = @ServiceID) OR (@ServiceID IS NULL))
                            AND ((PS.Value IS NOT NULL) OR (@OnlyMyList = 'false'))
   							AND ((CE.ExtensionValue IS NOT NULL) OR (@CertificateName IS NULL))
                          )

            ">
        <SelectParameters>
            <asp:ControlParameter Name="Username" ControlID="Username" PropertyName="text" ConvertEmptyStringToNull="true" />
            <asp:ControlParameter Name="DisplayLimit" ControlID="DisplayLimit" PropertyName="Text" DefaultValue="50" DbType="Int32" /> 
            <asp:QueryStringParameter Name="IncludeTerminated" QueryStringField="Terminated" DefaultValue="false" /> 
            <asp:QueryStringParameter Name="Hostname" QueryStringField="Hostname" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="Asset" QueryStringField="Asset" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="SerialNumber" QueryStringField="Serial" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="Function" QueryStringField="Function" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="Country" QueryStringField="Country" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="AssignedIP" QueryStringField="AssignedIP" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="ManagementIP" QueryStringField="ManagementIP" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="EnvironmentID" QueryStringField="EnvironmentID" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="IPAddress" QueryStringField="IPAddress" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="MACAddress" QueryStringField="MACAddress" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="DateID" QueryStringField="PatchApply" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="AppID" QueryStringField="APPSearch" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="OSID" QueryStringField="OS" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="CertificateName" QueryStringField="CertificateName" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="ServiceID" QueryStringField="Service" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter Name="OnlyMyList" QueryStringField="OnlyMyList" DefaultValue="true" />
            <asp:QueryStringParameter QueryStringField="AppID" Name="QAppID" ConvertEmptyStringToNull="true" />
        </SelectParameters>
    </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>
