Imports Microsoft.VisualBasic

Public Class MenuGenerator
    Private ds As DataSet
    Private MenuUser As System.Security.Principal.WindowsIdentity
    Public ADGroups As ArrayList = New ArrayList()

    Public Sub New(ByVal User As System.Security.Principal.WindowsIdentity)
        ds = New DataSet
        menuuser = User
        For Each group In MenuUser.Groups
            Try
                ADGroups.Add(group.Translate(GetType(System.Security.Principal.NTAccount)).ToString())
            Catch
            End Try
        Next
        ADGroups.Sort()

        LoadMenus()
    End Sub

    Public Sub LoadMenus()
        ds.Clear()
        Dim connection As SqlConnection
        Dim command As SqlCommand
        Dim adapter As New SqlDataAdapter
        connection = New SqlConnection(IPConst.GetConnectionString("DSVAsset"))

        connection.Open()
        command = New SqlCommand("SELECT * FROM IPPlanMenuTree", connection)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        connection.Close()
    End Sub

    Public ReadOnly Property MenuCount() As Integer
        Get
            Return ds.Tables(0).Rows.Count
        End Get
    End Property

#Region "Submenu generators"
    Public Sub GenerateMenu(ByVal Menu As System.Web.UI.WebControls.Menu, ByVal MenuRoot As String)
        GenerateMenu(Menu, "&nbsp;", MenuRoot)
    End Sub

    Public Sub GenerateMenu(ByVal Menu As System.Web.UI.WebControls.Menu, ByVal Caption As String, ByVal MenuRoot As String)
        GenerateMenu(Menu, Caption, MenuRoot, "")
    End Sub

    Public Sub GenerateMenu(ByVal Menu As System.Web.UI.WebControls.Menu, ByVal Caption As String, ByVal MenuRoot As String, ByVal ParamArray Params() As String)
        Dim RootItem As MenuItem = New MenuItem(Caption)
        Menu.Items.Add(RootItem)
        GenerateMenu(RootItem, Caption, MenuRoot, Params)
    End Sub

    Public Sub GenerateMenu(ByVal Menu As MenuItem, ByVal Caption As String, ByVal MenuRoot As String, ByVal ParamArray Params() As String)
        For Each row As DataRow In ds.Tables(0).Rows
            If row.Item("RootMenuName") = MenuRoot Then
                Dim newItem As MenuItem = addItem(Menu, row.Item("MenuID"), row.Item("Name"), row.Item("url"), row.Item("Style"))
                EnableMenu(newItem, IIf(IsDBNull(row.Item("ADGroup")), "", row.Item("ADGroup")))
                If row.Item("Style") = 0 Then
                    GenerateMenu(newItem, row.Item("Name"), row.Item("Name"), Params)
                End If
            End If
        Next
    End Sub

    Private Function addItem(ByVal RootItem As MenuItem, ByVal id As String, ByVal Caption As String, ByVal url As String, ByVal Style As Integer) As MenuItem
        addItem = Nothing
        For Each item As MenuItem In RootItem.ChildItems
            If (item.Text = Caption) And (item.Value = id) Then addItem = item
        Next
        If addItem Is Nothing Then
            'Dim MenuItem As MenuItem = New MenuItem(Caption, id, "", url, "_blank")
            addItem = New MenuItem(Caption)
            addItem.Value = id
            addItem.Enabled = False
            Select Case Style
                Case 0 'sub menu
                Case 1 ' Popup
                Case 2 ' Window
                Case 3 ' cmd
                Case 4 ' pscmd
                Case Else
                    Throw New Exception("MenuGenerator:addItem; Invalid menu style")
            End Select
            addItem.NavigateUrl = url
            RootItem.ChildItems.Add(addItem)
        End If
    End Function

    Private Sub EnableMenu(ByVal item As MenuItem, ByVal ADGroup As String)
        If ADGroup = "" Then
            item.Enabled = True
            item.Text = item.Text + "*"
            item.ToolTip = "Warning : Implicit enabled as no security group is added"
        Else
            For Each Group In ADGroups
                item.Enabled = item.Enabled Or (String.Compare(Group, ADGroup, True) = 0)
            Next
        End If
    End Sub
#End Region

#Region "TreeView generator"
    Public Sub PopulateTreeView(ByVal TreeView As System.Web.UI.WebControls.TreeView)
        Dim node As TreeNode
        If TreeView.Nodes.Count > 0 Then
            node = TreeView.Nodes(0)
        Else
            node = New TreeNode("IPPlan Menus")
            node.Value = 0
            TreeView.Nodes.Add(node)
        End If
        PopulateTreeView(node, 0)
    End Sub

    Private Sub PopulateTreeView(ByVal ParentNode As System.Web.UI.WebControls.TreeNode, ByVal ParentID As Integer)
        For Each row As DataRow In ds.Tables(0).Rows
            If (row.Item("ParentID") = ParentID) And (row.Item("MenuID") <> ParentID) Then
                Dim node As TreeNode
                Dim found As Boolean = False
                For Each node In ParentNode.ChildNodes
                    found = found Or ((node.Text = row.Item("Name")) And (node.Value = row.Item("MenuID")))
                Next
                If Not found Then
                    node = New TreeNode(row.Item("Name"))
                    node.Value = row.Item("MenuID")
                    ParentNode.ChildNodes.Add(node)
                    If row.Item("ParentID") <> row.Item("MenuID") Then PopulateTreeView(node, row.Item("MenuID"))
                End If
            End If
        Next
    End Sub
#End Region
End Class
