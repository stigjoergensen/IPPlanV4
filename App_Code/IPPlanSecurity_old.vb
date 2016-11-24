Imports Microsoft.VisualBasic

Public Class IPPlanSecurity_old
    Public Shared ReadOnly SecurityTimer As Integer = 120

    Public Overloads Shared Sub Security(ByRef control As WebControl, User As System.Security.Principal.IPrincipal, GroupName As String)
        If control IsNot Nothing Then
            Dim tooltip As String = control.ToolTip
            control.ToolTip = ""
            control.Enabled = False
            SetControlSecurity(control, User, GroupName)
            control.ToolTip = tooltip + vbCrLf + control.ToolTip
        End If
    End Sub

    Public Overloads Shared Sub security(ByRef control As WebControl, User As IPrincipal, ParamArray GroupNames() As String)
        If control IsNot Nothing Then
            Dim tooltip As String = "" ' control.ToolTip
            control.ToolTip = ""
            control.Enabled = False
            For Each Group As String In GroupNames
                SetControlSecurity(control, User, Group)
            Next
            control.ToolTip = tooltip + vbCrLf + control.ToolTip
        End If
    End Sub

    Private Shared Sub SetControlSecurity(ByRef control As WebControl, User As IPrincipal, GroupName As String)
        If control IsNot Nothing Then
            If User.IsInRole(GroupName) Then
                control.Enabled = True
                control.ToolTip = control.ToolTip + vbCrLf + "Group membership: " + GroupName + " (member)"
            Else
                If GroupName.StartsWith(User.Identity.Name.Substring(User.Identity.Name.LastIndexOf("\") + 1)) Then
                    control.Enabled = True
                    control.ToolTip = control.ToolTip + vbCrLf + "Username match: " + GroupName
                Else
                    control.Enabled = control.Enabled Or False
                    control.ToolTip = control.ToolTip + vbCrLf + "Group membership: " + GroupName + " (not member)"
                End If
            End If
        End If
    End Sub

    Public Shared Sub IssueTicket(Session As System.Web.SessionState.HttpSessionState)
        Session("Ticket") = Now().AddSeconds(SecurityTimer).Ticks.ToString()
    End Sub

    Public Shared Function CheckTicket(session As System.Web.SessionState.HttpSessionState) As Boolean
        Dim i As Integer = 0
        Dim res As Boolean = False
        While (i < 10) And Not res
            i = i + 1
            If session("Ticket") <> "" Then
                res = (Int64.Parse(session("Ticket")) > Now.Ticks)
            End If
            If Not res Then
                Threading.Thread.Sleep(1000)
            End If
        End While
        Return res
    End Function

    Public Overloads Shared Sub SetUrl(Control As LinkButton)
        'Dim prop As System.Reflection.PropertyInfo = Control.GetType().GetProperty("PostBackUrl")
        'If prop IsNot Nothing Then
        'Dim val As String = prop.GetValue(Control, Nothing)
        'If val <> "" Then
        'Control.Attributes.Add("onClick", "javascript:setTimeout(function(){window.open('" + VirtualPathUtility.ToAbsolute(Val) + "','_blank','toolbar=no');return true;},1000);")
        'prop.SetValue(Control, "", Nothing)
        'Dim prop2 As System.Reflection.PropertyInfo = Control.GetType().GetProperty("CommandName")
        'If prop2 IsNot Nothing Then
        'prop2.SetValue(Control, "IssueTicket", Nothing)
        'End If
        'End If
        'End If
    End Sub

    Public Overloads Shared Sub SetUrl(Control As LinkButton, url As String)
        If url.Length > 7 Then
            Dim str As String = url
            If url.StartsWith("~") Then
                str = VirtualPathUtility.ToAbsolute(url)
            End If

            Control.Attributes.Add("onClick", "javascript:setTimeout(function(){window.open('" + str + "','_blank','screenX=1,screenY=1,left=1,top=1,height='+screen.availHeight+',width='+screen.availWidth+',toolbar=no,channelmode=no,scrollbars=yes,status=no,titlebar=no,resizable=yes');return true;},1000);")
            Control.CommandName = "IssueTicket"
        Else
            Control.Text = "Url was too short - please report to Stig"
        End If
    End Sub

    Public Shared Sub CreateHostHistory(Hostname As String, Text As String, User As IPrincipal)
        Dim dbconn As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString)
        dbconn.Open()
        Dim rs As SqlCommand = New SqlCommand("INSERT INTO HostExtraDataHistory(Hostname,Description,Who) VALUES(@Hostname,@Description,@Who)", dbconn)
        rs.Parameters.AddWithValue("Hostname", Hostname)
        rs.Parameters.AddWithValue("Description", Text)
        rs.Parameters.AddWithValue("Who", User.Identity.Name)
        rs.CommandType = CommandType.Text
        rs.ExecuteNonQuery()
        dbconn.Close()
    End Sub

End Class
