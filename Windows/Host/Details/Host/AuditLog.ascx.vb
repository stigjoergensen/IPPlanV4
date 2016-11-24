
Partial Class Windows_Host_Details_Host_AuditLog
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
End Class
