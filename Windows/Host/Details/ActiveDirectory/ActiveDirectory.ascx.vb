
Partial Class Windows_Host_Details_ActiveDirectory_ActiveDirectory
    Inherits System.Web.UI.UserControl

    Public Property Hostname() As String
        Get
            Return lblHostname.Text
        End Get
        Set(value As String)
            lblHostname.Text = value
        End Set
    End Property

    Public Property includeHistory() As String
        Get
            Return lblIncludeHistory.Text
        End Get
        Set(value As String)
            lblIncludeHistory.Text = value
        End Set
    End Property

    Protected Sub ADComputerView_DataFound(e As Object, Args As UserControl_RowView.DataFoundEventArgs) Handles ADComputerView.DataFound
        Dim ADPath As String = Args.DataRow("DN").ToString()
        Dim Table As DataTable = New DataTable("RowData")
        Table.Columns.Add("ID", Type.GetType("System.Int32"))
        Table.Columns.Add("ParentID", Type.GetType("System.Int32"))
        Table.Columns.Add("Type", Type.GetType("System.String"))
        Table.Columns.Add("Name", Type.GetType("System.String"))
        Dim ID As Integer = 0
        Dim row As DataRow = Table.NewRow()
        For Each Str As String In ADPath.Split(",")
            row = Table.NewRow()
            Dim s As String() = Str.Split("=")
            row("ID") = ID
            row("ParentID") = ID + 1
            row("Type") = s(0)
            row("Name") = s(1)
            Table.Rows.Add(row)
            ID = ID + 1
        Next
        row("ParentID") = DBNull.Value

        ADPathTree.DataSource = Table
        ADPathTree.DataBind()
        ADPathTree.ExpandAllNodes()
    End Sub
End Class
