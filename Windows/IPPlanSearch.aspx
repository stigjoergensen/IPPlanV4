<%@ Page Language="VB" AutoEventWireup="false" CodeFile="IPPlanSearch.aspx.vb" Inherits="Windows_IPPlanSearch" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="/Scripts/IPPlanSearch.js" ></script>
    <script type="text/javascript" src="/Scripts/Windows.js" ></script>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager runat="server" ID="ScriptManager" />
    <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
    <script type="text/javascript">
        function GetValue(ID, QueryString) {
            var element = $find(ID)._text;
            if ((typeof element === 'undefined' || element === null)) {
                element = $find(ID)._selectedValue;
            }
            return "&" + QueryString + "="+element
        }
        function PerformSearch(sender, args) {
            var hostname = GetValue("Hostname","Hostname");
            var func = GetValue("Func","Function");
            var environment = GetValue("Environment", "EnvironmentID");
            var application = GetValue("ApplicationID","AppSearch");
            var ipAddress = GetValue("IPAddress","IPAddress");
            var macAddress = GetValue("MACAddress","MACAddress");
            var assignedIP = GetValue("AssignedIP","AssignedIP");
            var managementIP = GetValue("ManagementIP","ManagementIP");
            var country = GetValue("Country","Country");
            var serialNumber = GetValue("SerialNumber","SerialNumber");
            var asset = GetValue("Asset","Asset");
            var osName = GetValue("OSName","OSID");
            var patchApply = GetValue("PatchApply", "PatchApply");
            var certificate = GetValue("Certificate","CertificateName");
            var terminated = GetValue("Terminated", "Terminated");
            OpenNewWindow("/Windows/IPPlan.aspx?OnlyMyList=false" + hostname + func + environment + application + ipAddress + macAddress + assignedIP + managementIP + country + serialNumber + asset + osName + patchApply + certificate + terminated, "IPPlan", 0, 0);
            CloseWindow(null);
        }
    </script>
    <div>
        <table>
            <tr>
                <td>Hostname</td>
                <td>
                    <telerik:RadComboBox ID="Hostname" AllowCustomText="true" runat="server" EmptyMessage="enter hostname" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetHostnames" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Function</td>
                <td>
                    <telerik:RadComboBox ID="Func" AllowCustomText="true" runat="server" EmptyMessage="enter function name" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetFunctions" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Environment</td>
                <td>
                    <telerik:RadDropDownList ID="Environment" runat="server" DefaultMessage="Select environment">
                        <WebServiceSettings Method="GetEnvironments" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadDropDownList>
                </td>
            </tr>
            <tr>
                <td>Application</td>
                <td>
                    <telerik:RadComboBox ID="ApplicationID" AllowCustomText="true" runat="server" EmptyMessage="enter Application name or number" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetApplications" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>IP Address</td>
                <td>
                    <telerik:RadComboBox ID="IPAddress" AllowCustomText="true" runat="server" EmptyMessage="enter IP Address" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetIPAddresses" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>MAC Address</td>
                <td>
                    <telerik:RadComboBox ID="MACAddress" AllowCustomText="true" runat="server" EmptyMessage="enter MAC Address" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetMACAddresses" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Assigned IP</td>
                <td>
                    <telerik:RadComboBox ID="AssignedIP" AllowCustomText="true" runat="server" EmptyMessage="enter Assigned IP" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetAssignedIPs" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Management IP</td>
                <td>
                    <telerik:RadComboBox ID="ManagementIP" AllowCustomText="true" runat="server" EmptyMessage="enter management IP" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetManagementIPs" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Country</td>
                <td>
                    <telerik:RadComboBox ID="Country" AllowCustomText="true" runat="server" EmptyMessage="enter Country code ot name" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetCountries" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Serial Number</td>
                <td>
                    <telerik:RadComboBox ID="SerialNumber" AllowCustomText="true" runat="server" EmptyMessage="enter Serial number" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetSerialNumbers" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Asset</td>
                <td>
                    <telerik:RadComboBox ID="Asset" AllowCustomText="true" runat="server" EmptyMessage="enter Asset Tag" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetAssets" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>OS</td>
                <td>
                    <telerik:RadComboBox ID="OSName" AllowCustomText="true" runat="server" EmptyMessage="enter name of OS" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetOperatingSystems" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Patch Day</td>
                <td>
                    <telerik:RadDropDownList ID="PatchApply" runat="server" DefaultMessage="Select patch day">
                        <WebServiceSettings Method="GetPatchDays" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadDropDownList>
                </td>
            </tr>
            <tr>
                <td>Certificate</td>
                <td>
                    <telerik:RadComboBox ID="Certificate" AllowCustomText="true" runat="server" EmptyMessage="enter name of certificate" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true">
                        <WebServiceSettings Method="GetCertificates" Path="/Providers/IPPlanSearch.asmx" />
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td>Include Terminated</td>
                <td>
                    <telerik:RadDropDownList ID="Terminated" runat="server" DefaultMessage="Select Yes or No">
                        <Items>
                            <telerik:DropDownListItem Text="Yes" Value="1" />
                            <telerik:DropDownListItem Text="No" Value="0" Selected="true" />
                        </Items>
                    </telerik:RadDropDownList>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td style="text-align:right;">
                    <telerik:RadButton ID="ipplanSearch" runat="server" ButtonType="LinkButton" CssClass="imageButton_75" Text="Search" OnClientClicked="PerformSearch" AutoPostBack="false" >
                        <Icon PrimaryIconUrl="/Images/Find_16x16.png" />
                    </telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
