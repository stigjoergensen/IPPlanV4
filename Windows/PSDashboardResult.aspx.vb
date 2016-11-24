
Partial Class Windows_PSDashboardResult
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LogID.Text = Request.QueryString("ID")
            Select Case Request.QueryString("Type")
                Case "Log"
                    PanelLog.Visible = True
                Case "Error"
                    PanelError.Visible = True
                Case "Transcript"
                    PanelTranscript.Visible = True
                Case "Result"
                    PanelResult.Visible = True
            End Select
        End If
    End Sub
End Class
