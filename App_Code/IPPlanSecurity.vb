Imports Microsoft.VisualBasic

Public Class IPPlanSecurity

    Shared IPPlanSecurity As IPPlanSecurity = Nothing
    Protected Cache As Dictionary(Of String, String)

    Shared Function SecurityGroup(GroupName As String, DefaultGroup As String, HelpText As String) As String
        If IPPlanSecurity Is Nothing Then IPPlanSecurity = New IPPlanSecurity()
        If IPPlanSecurity.Cache.ContainsKey(GroupName) Then
            Return IPPlanSecurity.Cache(GroupName)
        Else
            Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
            Conn.Open()
            Dim cmd As SqlCommand = New SqlCommand("SELECT * FROM IPPlanV4Security WHERE GroupName=@GroupName", Conn)
            cmd.Parameters.AddWithValue("GroupName", GroupName)
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            If reader.HasRows Then
                Dim ostr As List(Of String) = New List(Of String)
                While reader.Read()
                    ostr.Add(reader("SecurityGroups"))
                End While
                reader.Close()
                SecurityGroup = String.Join(",", ostr)
            Else
                reader.Close()
                cmd.CommandText = "INSERT INTO IPPlanV4Security(Groupname,SecurityGroups,HelpText) VALUES(@Groupname,@SecurityGroups,@HelpText)"
                cmd.Parameters.AddWithValue("SecurityGroups", DefaultGroup)
                cmd.Parameters.AddWithValue("HelpText", HelpText)
                cmd.ExecuteNonQuery()
                SecurityGroup = DefaultGroup
            End If
            IPPlanSecurity.Cache(GroupName) = SecurityGroup
            Conn.Close()
            Conn.Dispose()
        End If
    End Function

    Shared Function SecurityGroup(Groupname As String, helptext As String) As String
        Return SecurityGroup(Groupname, "GRIT.G.U.IPPlan.Admin", helptext)
    End Function

    Shared Function isInRole(Page As System.Web.UI.Page, Groupname As String, HelpText As String) As Boolean
        If IPPlanSecurity Is Nothing Then IPPlanSecurity = New IPPlanSecurity()
        Dim res As Boolean = False
        For Each Entry As String In SecurityGroup(Groupname, HelpText).Split(",")
            res = res Or Page.User.IsInRole(Entry)
        Next
        Return res
    End Function

    Public Sub New()
        Cache = New Dictionary(Of String, String)
    End Sub

End Class
