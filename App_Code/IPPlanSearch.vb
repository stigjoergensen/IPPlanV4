Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports Telerik.Web.UI

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class IPPlanSearch
    Inherits System.Web.Services.WebService


    Private Function GetData(SQLString As String, Optional MaxRows As Integer = 999999999) As DataTable
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand(SQLString, connection)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        connection.Close()
        connection.Dispose()
        If products.Rows.Count = MaxRows Then
            Dim MaxRow As DataRow = products.NewRow()
            For i = 0 To products.Columns.Count - 1
                MaxRow(i) = "[Please narrow search]"
            Next
            products.Rows.InsertAt(MaxRow, 0)
        End If
        Return products
    End Function

    Private Function GetData(SQLString As String, ParamNames As String(), Values As String(), Optional MaxRows As Integer = 999999999) As DataTable
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand(SQLString, connection)
        For i = 0 To ParamNames.Count - 1
            selectCommand.Parameters.AddWithValue(ParamNames(i), Values(i))
        Next
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        connection.Close()
        connection.Dispose()
        If products.Rows.Count = MaxRows Then
            Dim MaxRow As DataRow = products.NewRow()
            For i = 0 To products.Columns.Count - 1
                MaxRow(i) = "[Please narrow search]"
            Next
            products.Rows.InsertAt(MaxRow, 0)
        End If
        Return products
    End Function


    <WebMethod()>
    Public Function GetHostnames(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim Hostnames As DataTable = GetData("SELECT DISTINCT TOP 30 Hostname FROM HostExtraData WHERE Hostname LIKE 'i%" + filterString + "%' OR Hostname LIKE '" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(Hostnames.Rows.Count)
        For Each row As DataRow In Hostnames.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("Hostname").ToString()
            itemData.Value = row("Hostname").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetFunctions(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim Functions As DataTable = GetData("SELECT DISTINCT TOP 30 * FROM (SELECT [Function] AS SearchText FROM HostExtraData WHERE [function] LIKE '%" + filterString + "%' UNION ALL SELECT [FunctionAlias] AS SearchText FROM HostExtraData WHERE [FunctionAlias] LIKE '%" + filterString + "%') AS X", 30)
        Dim result As New List(Of RadComboBoxItemData)(Functions.Rows.Count)
        For Each row As DataRow In Functions.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("SearchText").ToString()
            itemData.Value = row("SearchText").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetEnvironments(ByVal context As Object) As Object()
        Dim Environments As DataTable = GetData("SELECT EnvironmentID, EnvironmentName FROM IPPlanEnvironment")
        Dim result As New List(Of DropDownListItemData)(Environments.Rows.Count)
        For Each row As DataRow In Environments.Rows
            Dim itemData As New DropDownListItemData()
            itemData.Text = row("EnvironmentName").ToString()
            itemData.Value = row("EnvironmentID").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetIPAddresses(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim IPAddresses As DataTable = GetData("SELECT DISTINCT TOP 30 IPAddress FROM HostNetwork WHERE [IPAddress] LIKE '%" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(IPAddresses.Rows.Count)
        For Each row As DataRow In IPAddresses.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("IPAddress").ToString()
            itemData.Value = row("IPAddress").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetApplications(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim Names As DataTable = GetData("SELECT DISTINCT TOP 30 Name FROM EAP1ApplicationView WHERE (((CAST(ID AS VARCHAR) = @Search AND ISNUMERIC(@Search)=1) OR (Name LIKE '%'+@Search+'%' AND ISNUMERIC(@Search)=0)))", {"@Search"}, {filterString}, 30)
        Dim result As New List(Of RadComboBoxItemData)(Names.Rows.Count)
        For Each row As DataRow In Names.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("Name").ToString()
            itemData.Value = row("Name").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetMACAddresses(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim MACAddresses As DataTable = GetData("SELECT DISTINCT TOP 30 MACAddress from hostNetwork WHERE MACAddress <> '' AND _active = 1 AND MACAddress LIKE 'i%" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(MACAddresses.Rows.Count)
        For Each row As DataRow In MACAddresses.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("MACAddress").ToString()
            itemData.Value = row("MACAddress").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetAssignedIPs(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim AssignedIPS As DataTable = GetData("SELECT DISTINCT TOP 30 AssignedIP FROM HostExtraData WHERE AssignedIP LIKE 'i%" + filterString + "%' OR AssignedIP LIKE '" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(AssignedIPS.Rows.Count)
        For Each row As DataRow In AssignedIPS.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("AssignedIP").ToString()
            itemData.Value = row("AssignedIP").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetManagementIPs(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim ManagementIPs As DataTable = GetData("SELECT DISTINCT TOP 30 ManagementIP FROM HostExtraData WHERE ManagementIP LIKE 'i%" + filterString + "%' OR ManagementIP LIKE '" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(ManagementIPs.Rows.Count)
        For Each row As DataRow In ManagementIPs.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("ManagementIP").ToString()
            itemData.Value = row("ManagementIP").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetCountries(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim Countries As DataTable = GetData("select Name,ISO2 from Country where ArsEnabled=1 AND (Name LIKE '" + filterString + "%' OR ISO2 LIKE '" + filterString + "%')", 30)
        Dim result As New List(Of RadComboBoxItemData)(Countries.Rows.Count)
        For Each row As DataRow In Countries.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("Name").ToString()
            itemData.Value = row("ISO2").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetSerialNumbers(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim SerialNumbers As DataTable = GetData("select DISTINCT TOP 30 SerialNumber FROM HostBios WHERE SerialNumber LIKE '%" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(SerialNumbers.Rows.Count)
        For Each row As DataRow In SerialNumbers.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("SerialNumber").ToString()
            itemData.Value = row("SerialNumber").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetAssets(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim Assets As DataTable = GetData("select DISTINCT TOP 30 Asset FROM HostExtraData WHERE Asset LIKE '%" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(Assets.Rows.Count)
        For Each row As DataRow In Assets.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("Asset").ToString()
            itemData.Value = row("Asset").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetOperatingSystems(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim OSs As DataTable = GetData("SELECT DISTINCT TOP 30 OSName FROM MasterOS WHERE OSName  Like '%" + filterString + "%' AND Unavailable=0", 30)
        Dim result As New List(Of RadComboBoxItemData)(OSs.Rows.Count)
        For Each row As DataRow In OSs.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("OSName").ToString()
            itemData.Value = row("OSName").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetPatchDays(ByVal context As Object) As Object
        Dim PatchDays As DataTable = GetData("select Name, DateID FROM PatchApply WHERE Visible=1")
        Dim result As New List(Of DropDownListItemData)(PatchDays.Rows.Count)
        For Each row As DataRow In PatchDays.Rows
            Dim itemData As New DropDownListItemData()
            itemData.Text = row("Name").ToString()
            itemData.Value = row("DateID").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

    <WebMethod()>
    Public Function GetCertificates(ByVal context As Object) As Object()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim Assets As DataTable = GetData("SELECT TOP 30 CASE WHEN LEN(C.FriendlyName) > 0 THEN C.FriendlyName ELSE CASE WHEN LEN(C.Subject) > 0 THEN C.Subject ELSE CE.ExtensionValue END END AS Name from Certificates AS C JOIN CertificateExtension AS CE ON CE.Thumbprint = C.Thumbprint WHERE C.FriendlyName Like '%" + filterString + "%' OR C.Subject like 'CN=%" + filterString + "%' OR CE.ExtensionValue Like '%" + filterString + "%'", 30)
        Dim result As New List(Of RadComboBoxItemData)(Assets.Rows.Count)
        For Each row As DataRow In Assets.Rows
            Dim itemData As New RadComboBoxItemData()
            itemData.Text = row("Name").ToString()
            itemData.Value = row("Name").ToString()
            result.Add(itemData)
        Next
        Return result.ToArray()
    End Function

End Class