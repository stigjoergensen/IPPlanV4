Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports Telerik.Web.UI
Imports System.DirectoryServices

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class ActiveDirectory
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function HelloWorld() As String
        Return "Hello World"
    End Function

    Private Function GetADInfo(SearchString As String, ReturnName() As String, SearchType() As String) As List(Of RadComboBoxItemData)
        Dim result As New List(Of RadComboBoxItemData)
        If SearchString.Length > 2 Then
            Dim rootEntry As DirectoryEntry = New DirectoryEntry("LDAP://OU=DSV.COM,DC=DSV,DC=COM")
            Dim Searcher As DirectorySearcher = New DirectorySearcher(rootEntry)
            Searcher.SizeLimit = 100
            For Each Str As String In ReturnName
                Searcher.PropertiesToLoad.Add(Str)
            Next
            Searcher.PropertiesToLoad.Add("objectClass")


            Dim ObjectCategory As String = ""
            For Each Str As String In SearchType
                ObjectCategory = String.Format("{0}(objectCategory={1})", ObjectCategory, Str)
            Next
            If SearchType.Count > 1 Then
                ObjectCategory = String.Format("(|{0})", ObjectCategory)
            End If

            Searcher.Filter = String.Format("(&(|(displayName=*{0}*)(samAccountName=*{0}*)(userPrincipalName=*{0}*)(eMail={0}*)){1})", SearchString, ObjectCategory)
            Dim SearchResult As SearchResultCollection = Searcher.FindAll()
            If SearchResult.Count > 99 Then
                Dim itemdata As RadComboBoxItemData = New RadComboBoxItemData()
                itemdata.Text = "More data found, please narrow your search"
                itemdata.Value = ""
            End If
            For Each Entry As SearchResult In SearchResult
                Dim found As Boolean = False
                For Each Str As String In ReturnName
                    If Entry.Properties(Str).Count > 0 And Not found Then
                        Dim itemdata As RadComboBoxItemData = New RadComboBoxItemData()
                        itemdata.Text = Entry.Properties(Str).Item(0).ToString()
                        itemdata.Value = Entry.Properties(Str).Item(0).ToString()
                        itemdata.Attributes.Add("Name", Entry.Properties(Str).Item(0).ToString())
                        itemdata.Attributes.Add("Type", Entry.Properties("objectClass").Item(1).ToString())
                        result.Add(itemdata)
                        found = True
                    End If
                Next
            Next
            SearchResult.Dispose()
        End If
        Return result
    End Function


    <WebMethod()> _
    Public Function SearchForUser(ByVal context As Object) As RadComboBoxItemData()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String))
        Return GetADInfo(filterString, {"userPrincipalName"}, {"person"}).ToArray()
    End Function

    <WebMethod()> _
    Public Function SeachForEmail(ByVal context As Object) As RadComboBoxItemData()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String))
        Return GetADInfo(filterString, {"eMail"}, {"person"}).ToArray()
    End Function

    <WebMethod()> _
    Public Function SeachForUserOrGroups(ByVal context As Object) As RadComboBoxItemData()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String))
        Return GetADInfo(filterString, {"cn"}, {"person", "group"}).ToArray()
    End Function

    <WebMethod()> _
    Public Function SeachForGroups(ByVal context As Object) As RadComboBoxItemData()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String))
        Return GetADInfo(filterString, {"cn"}, {"group"}).ToArray()
    End Function

    <WebMethod()> _
    Public Function Search(ByVal context As Object) As RadComboBoxItemData()
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim filterString As String = (DirectCast(contextDictionary("FilterString"), String)).ToLower()
        Dim ReturnAttribute As String() = (DirectCast(contextDictionary("ReturnAttribute"), String)).Split(",")
        Dim SearchClasses As String() = (DirectCast(contextDictionary("SearchClasses"), String)).Split(",")
        Return GetADInfo(filterString, ReturnAttribute, SearchClasses).ToArray()
    End Function


End Class