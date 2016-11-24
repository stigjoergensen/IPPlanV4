Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports Telerik.Web.UI

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class MenuProvider
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function HelloWorld() As String
        Return "Hello World"
    End Function

    Private Function CreateMenuDivider() As RadMenuItemData
        Dim MenuItem As RadMenuItemData = New RadMenuItemData()
        MenuItem.IsSeparator = True
        Return MenuItem
    End Function

    Public Shared Function GetMenuFunction(MenuFunctionID As Integer, MenuFunction As String) As String
        Select Case MenuFunctionID
            Case 1
                Return MenuFunction
            Case 2
                Return "OpenNewWindow(" + MenuFunction + ");"
            Case 3
                Return "OpenNewDialog(" + MenuFunction + ");"
            Case 4
                Return "OpenNewWindowSpecialIcons(" + MenuFunction + ");"
            Case Else
                Return ""
        End Select
    End Function

    Private Function CreateMenuItem(Title As String, FunctionID As Integer, JavaScriptFunction As Object) As RadMenuItemData
        Dim MenuItem As RadMenuItemData = New RadMenuItemData()
        MenuItem.Text = Title
        If IsDBNull(JavaScriptFunction) Then
            MenuItem.Value = "alert('Menu item have no function');"
        Else
            MenuItem.Value = GetMenuFunction(FunctionID, JavaScriptFunction)
        End If
        Return MenuItem
    End Function

    Private Function CreateSubMenuItem(Title As String, MenuID As Integer, argument As String, MenuFunctionID As Integer, MenuFunction As String) As RadMenuItemData
        Dim MenuItem As RadMenuItemData = New RadMenuItemData()
        MenuItem.Text = Title
        MenuItem.ExpandMode = MenuItemExpandMode.WebService
        MenuItem.Value = "Menu:" + MenuID.ToString() + ":" + argument + ":" + GetMenuFunction(MenuFunctionID, MenuFunction)
        Return MenuItem
    End Function

    'SELECT B.*, (SELECT Count(*) FROM IPPlanV4Menu AS C WHERE C.ParentMenuID=B.MenuID) AS SubMenus  FROM IPPlanV4Menu AS B
    ' WHERE B.ParentMenuID = 0
    Private Function GetMenuData(MenuID As Integer) As DataTable
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand("SELECT B.*, (SELECT Count(*) FROM IPPlanV4Menu AS C WHERE C.ParentMenuID=B.MenuID) AS SubMenus  FROM IPPlanV4Menu AS B WHERE B.ParentMenuID = @MenuID ORDER BY [SortOrder]", connection)
        selectCommand.Parameters.AddWithValue("MenuID", MenuID)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        connection.Close()
        connection.Dispose()
        Return products
    End Function


    ' SELECT *, (SELECT ',' + ADGroup FROM PowershellSecurity AS S WHERE S.PSID = P.PSID FOR XML PATH('')) AS SecurityGroups from Powershell AS P WHERE P.MenuLocationID = 1 AND P.Enabled =1
    Private Function GetPowershellMenuData(MenuID As Integer) As DataTable
        Dim connection As New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        Dim selectCommand As New SqlCommand("SELECT *, (SELECT ',' + ADGroup FROM PowershellSecurity AS S WHERE S.PSID = P.PSID FOR XML PATH('')) AS SecurityGroups from Powershell AS P WHERE P.MenuLocationID = @MenuID AND P.Enabled =1", connection)
        selectCommand.Parameters.AddWithValue("MenuID", MenuID)
        Dim adapter As New SqlDataAdapter(selectCommand)
        Dim products As New DataTable()
        adapter.Fill(products)
        connection.Close()
        connection.Dispose()
        Return products
    End Function

    <WebMethod()> _
    Public Function GetMenu(item As RadMenuItemData, context As Object) As RadMenuItemData()
        ' We cannot use a dictionary as a parameter, because it is only supported by script services.
        ' The context object should be cast to a dictionary at runtime.
        Dim contextDictionary As IDictionary(Of String, Object) = DirectCast(context, IDictionary(Of String, Object))
        Dim Strs As String() = item.Value.Split(":")
        Dim func As String = Strs(0)
        Dim parameter As String = ""
        Dim Argument As String = ""
        If Strs.Count > 1 Then parameter = Strs(1)
        If Strs.Count > 2 Then Argument = Strs(2)
        Dim result As New List(Of RadMenuItemData)
        Select Case Strs(0).ToLower()
            Case "menu"
                MainMenu(result, item, contextDictionary, parameter, Argument)
        End Select
        Return result.ToArray()
    End Function

    Private Sub MainMenu(Container As List(Of RadMenuItemData), item As RadMenuItemData, Context As IDictionary(Of String, Object), MenuID As Integer, Optional Argument As String = "")
        Dim MenuItem As RadMenuItemData
        Dim arguments As Dictionary(Of String, String) = New Dictionary(Of String, String)
        If Argument <> "" Then
            arguments = Argument.Trim("[", "]").Split(New String() {"];["}, StringSplitOptions.None).ToDictionary(Function(e) Trim(e.Substring(0, e.IndexOf(","))), Function(e) Trim(e.Substring(e.IndexOf(",") + 1)))
        End If
        If MenuID = 1 Then
            MenuItem = CreateMenuItem(User.Identity.Name, 3, "'/Config/UserSettings.aspx','User settings'")
            Container.Add(MenuItem)
            MenuItem.CssClass = "MenuTitle"
        End If
        Dim MenuData As DataTable = GetMenuData(MenuID)
        For Each row As DataRow In MenuData.Rows
            MenuItem = Nothing
            Dim Enabled As Boolean = False
            Dim Visible As Boolean = False
            If row("ForceVisible").ToString() = "1" Then Visible = True
            For Each Groupname As String In row("SecurityGroups").ToString().Split(",")
                If arguments.Keys.Count > 0 Then
                    For Each Key In arguments.Keys
                        Enabled = Enabled Or (User.IsInRole(Groupname.Replace("$" + Key, arguments(Key))))
                    Next
                Else
                    Enabled = Enabled Or (User.IsInRole(Groupname))
                End If
            Next

            Dim MenuTitle As String = row("MenuTitle").ToString()
            Dim MenuFunction As String = row("MenuFunction").ToString()
            Dim MenuFunctionID As Integer = row("MenuFunctionID").ToString()
            For Each Key As String In arguments.Keys
                MenuTitle = MenuTitle.Replace("$" + Key, arguments(Key))
                MenuFunction = MenuFunction.Replace("$" + Key, arguments(Key))
            Next
            Select Case row("MenuTypeID")
                Case 1
                    If row("SubMenus") > 0 Then
                        MenuItem = CreateSubMenuItem(MenuTitle, row("MenuID"), Argument, MenuFunctionID, MenuFunction)
                    Else
                        MenuItem = CreateMenuItem(MenuTitle, MenuFunctionID, MenuFunction)
                    End If
                Case 2
                    MenuItem = CreateMenuDivider()
                Case 3
                    CreatePowershellMenu(Container, MenuFunction, Argument)
            End Select

            If MenuItem IsNot Nothing Then
                MenuItem.Enabled = Enabled
                If Visible Or Enabled Then Container.Add(MenuItem)
            End If
        Next
    End Sub

    Private Sub CreatePowershellMenu(Container As List(Of RadMenuItemData), MenuLocation As Integer, Argument As String)
        Dim MenuItem As RadMenuItemData
        Dim MenuData As DataTable = GetPowershellMenuData(MenuLocation)
        For Each row As DataRow In MenuData.Rows
            MenuItem = Nothing
            Dim Enabled As Boolean = False
            For Each Groupname As String In row("SecurityGroups").ToString().Split(",")
                Enabled = Enabled Or (User.IsInRole(Groupname))
            Next
            MenuItem = CreateMenuItem(row("Title"), 2, "'/Windows/ExecutePS.aspx?PSID=" + row("PSID").ToString() + "&ShowLocked=0','PS:" + row("Title").ToString() + "'")
            If MenuItem IsNot Nothing And Enabled Then
                Container.Add(MenuItem)
            End If
        Next
    End Sub

End Class