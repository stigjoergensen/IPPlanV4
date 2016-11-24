Imports Telerik.Web.UI
Partial Class Config_MenuConfig
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        IPPlanV4MenuFunction.SelectParameters("MenuFunctionID").DefaultValue = ""
        Dim view As DataView = IPPlanV4MenuFunction.Select(DataSourceSelectArguments.Empty)
        Dim table As DataTable = view.ToTable()
        Dim arr As String() = (From row In table Select MenuHelp = row("MenuHelp").ToString()).ToArray()
        Page.ClientScript.RegisterArrayDeclaration("MenuHelpArray", """" + String.Join(""",""", arr) + """")
    End Sub
End Class
