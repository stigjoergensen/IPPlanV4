
Partial Class UserControl_RowView
    Inherits System.Web.UI.UserControl


    Class DataFoundEventArgs
        Inherits System.EventArgs

        Public DataRow As System.Data.DataRow
        Public Sub New(Row As System.Data.DataRow)
            MyBase.New()
            DataRow = Row
        End Sub
    End Class
    Public Event DataFound(e As Object, Args As DataFoundEventArgs)
    Public Event SecurityBound(e As Object, args As DataFoundEventArgs)

    Private _dataSource As SqlDataSource = Nothing
    Private _datasourceid As String = ""
    Private _AccessMethod As String = ""
    Private _ViewName As String = ""
    Private _ReadGroups As String = "domain users"
    Private _UpdateGroups As String = "none"

    Public Property AccessMethod As String
        Get
            Return _AccessMethod
        End Get
        Set(value As String)
            _AccessMethod = value
        End Set
    End Property

    Public Property ReadGroups As String
        Get
            Return _ReadGroups
        End Get
        Set(value As String)
            _ReadGroups = value
        End Set
    End Property

    Public Property UpdateGroups As String
        Get
            Return _UpdateGroups
        End Get
        Set(value As String)
            _UpdateGroups = value
        End Set
    End Property

    Public Property DataSource() As SqlDataSource
        Get
            Return _dataSource
        End Get
        Set(value As SqlDataSource)
            _dataSource = value
        End Set
    End Property

    Public Property DataSourceID As String
        Get
            Return _datasourceid
        End Get
        Set(value As String)
            _datasourceid = value
        End Set
    End Property

    Public Property ViewName As String
        Get
            Return _ViewName
        End Get
        Set(value As String)
            _ViewName = value
        End Set
    End Property

    Private Function GetViewSecurity(ViewName As String, AccessMethod As String) As DataView
        IPPlanV4ViewSecurity.SelectParameters("ViewName").DefaultValue = ViewName
        IPPlanV4ViewSecurity.SelectParameters("AccessMethod").DefaultValue = AccessMethod
        Dim dv As DataView = DirectCast(IPPlanV4ViewSecurity.Select(DataSourceSelectArguments.Empty), DataView)
        Return dv
    End Function

    Private Function AddViewSecurity(CacheTable As DataView, Viewname As String, AccessMethod As String, KeyName As String) As DataRow()
        IPPlanV4ViewSecurity.InsertParameters("ViewName").DefaultValue = Viewname
        IPPlanV4ViewSecurity.InsertParameters("KeyName").DefaultValue = KeyName
        IPPlanV4ViewSecurity.InsertParameters("KeyTitle").DefaultValue = KeyName
        IPPlanV4ViewSecurity.Insert()

        IPPlanV4ViewSecurityGroup.InsertParameters("AccessMethod").DefaultValue = AccessMethod
        IPPlanV4ViewSecurityGroup.InsertParameters("ReadGroups").DefaultValue = _ReadGroups
        IPPlanV4ViewSecurityGroup.InsertParameters("WriteGroups").DefaultValue = _UpdateGroups
        IPPlanV4ViewSecurityGroup.Insert()

        Dim row As DataRow = CacheTable.Table.NewRow()
        row("ViewName") = Viewname
        row("KeyName") = KeyName
        row("KeyTitle") = KeyName
        row("ReadGroups") = _ReadGroups
        row("UpdateGroups") = _UpdateGroups
        Return CacheTable.Table.Select(String.Format("KeyName='{0}'", KeyName))
    End Function

    Private Function GetRowData(ViewName As String, AccessMethod As String, DataSource As SqlDataSource) As DataTable
        Dim Table As DataTable = New DataTable("RowData")
        Table.Columns.Add("FieldTitle", Type.GetType("System.String"))
        Table.Columns.Add("FieldName", Type.GetType("System.String"))
        Table.Columns.Add("FieldValue", Type.GetType("System.String"))
        Table.Columns.Add("Editable", Type.GetType("System.Boolean"))

        Dim Security As DataView = GetViewSecurity(ViewName, AccessMethod)
        Dim dv As DataView = DirectCast(DataSource.Select(DataSourceSelectArguments.Empty), DataView)
        If dv IsNot Nothing Then
            RaiseEvent DataFound(Me, New DataFoundEventArgs(dv.Table.Rows(0)))

            For Each column As DataColumn In dv.Table.Columns
                Dim SecurityRows As DataRow() = Security.Table.Select(String.Format("KeyName='{0}'", column.ColumnName))
                If SecurityRows.Count = 0 Then
                    SecurityRows = AddViewSecurity(Security, ViewName, _AccessMethod, column.ColumnName)
                End If
                Dim visible As Boolean = False
                Dim editable As Boolean = False
                For Each row As DataRow In SecurityRows
                    For Each Group As String In row("ReadGroups").ToString().Split(",")
                        visible = visible Or Page.User.IsInRole(Group)
                    Next
                    For Each Group As String In row("WriteGroups").ToString().Split(",")
                        editable = editable Or Page.User.IsInRole(Group)
                    Next
                Next
                If visible Or editable Then
                    Dim row As DataRow = Table.NewRow()
                    row("FieldTitle") = SecurityRows(0)("KeyTitle")
                    row("FieldName") = column.ColumnName
                    If dv.Table.Rows.Count > 0 Then
                        Dim Formatstring As String = SecurityRows(0)("Formating").ToString()
                        If Formatstring = "" Then
                            row("FieldValue") = dv.Table.Rows(0)(column).ToString()
                        ElseIf Formatstring.StartsWith("{") Then
                            row("FieldValue") = String.Format(SecurityRows(0)("Formating").ToString(), dv.Table.Rows(0)(column))
                        Else
                            row("FieldValue") = String.Format("{0:" + SecurityRows(0)("Formating").ToString() + "}", dv.Table.Rows(0)(column))
                        End If
                    End If
                    row("Editable") = editable
                    Table.Rows.Add(row)
                    RaiseEvent SecurityBound(Me, New DataFoundEventArgs(row))
                End If
            Next
        End If
        Return Table
    End Function

    Private Function FindControlRecursive(control As Control, id As String) As Control
        If control Is Nothing Then
            Return Nothing
        End If
        If control.ID = id Then
            Return control
        End If

        For Each c As Control In control.Controls
            Dim found = FindControlRecursive(c, id)
            If found IsNot Nothing Then
                Return found
            End If
        Next

        Return Nothing
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim ctrl As Control = FindControlRecursive(Me.Page, _datasourceid)
        If TypeOf ctrl Is SqlDataSource Then
            _dataSource = ctrl
            rgRowView.DataSource = GetRowData(_ViewName, _AccessMethod, _dataSource)
            rgRowView.DataBind()
        Else
            Throw New InvalidCastException("DataSourceID is not pointing to a SqlDataSource")
        End If
    End Sub


    Protected Sub IPPlanV4ViewSecurity_Inserted(sender As Object, e As SqlDataSourceStatusEventArgs) Handles IPPlanV4ViewSecurity.Inserted
        IPPlanV4ViewSecurityGroup.InsertParameters("SecurityID").DefaultValue = e.Command.Parameters("@SecurityID").Value
    End Sub
End Class
