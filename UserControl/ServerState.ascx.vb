
Partial Class UserControl_ServerState
    Inherits System.Web.UI.UserControl

    Private _hostname As String
    Private _dlgt As AsyncTaskDelegate
    Delegate Sub AsyncTaskDelegate()

    Public Property Hostname As String
        Get
            Return _hostname
        End Get
        Set(value As String)
            _hostname = value
        End Set
    End Property
    Public Property EnvironmentID As Integer
    Public Property State As IPPlan.ServerStateService.ServerStates

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        'Dim servicePath As String = "/Providers/ServerStateService.asmx"
        'Me.State = ServerStateService.ServerStates.unknown
        'Dim sc As Telerik.Web.UI.RadScriptManager = Telerik.Web.UI.RadScriptManager.GetCurrent(Me.Page)
        'Dim found As Boolean = False
        'For Each service As System.Web.UI.ServiceReference In sc.Services
        '    found = found Or service.Path = servicePath
        'Next
        'If Not found Then sc.Services.Add(New ServiceReference(servicePath))
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        StateImage.Attributes.Add("onload", "StateImageLoad(this,'" + _hostname + "'," + EnvironmentID.ToString() + ");return false;")
    End Sub

End Class
