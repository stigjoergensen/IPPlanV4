
Partial Class UserControl_ADComboBox
    Inherits System.Web.UI.UserControl
    Const scriptName As String = "ADComboBoxScript"

    Public Property Width As Integer
    Public Property ReturnAttribute As String
    Public Property SearchClasses As String
    Public Property Enabled As Boolean
    Public ReadOnly Property Combobox As Telerik.Web.UI.RadComboBox
        Get
            Return ADSearch
        End Get
    End Property
    
    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        'Dim CS As ClientScriptManager = Page.ClientScript
        'If Not CS.IsClientScriptIncludeRegistered(Page.GetType(), scriptName) Then
        '    Dim sInclude As String = ResolveClientUrl("/UserControl/ADComboBox.js")
        '    CS.RegisterClientScriptInclude(Page.GetType(), scriptName, sInclude)
        '    'Dim include As HtmlGenericControl = New HtmlGenericControl("script")
        '    'include.Attributes.Add("type", "text/javascript")
        '    'include.Attributes.Add("src", sInclude)
        '    'Page.Header.Controls.Add(include)
        'End If
    End Sub


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ADSearch.Width = Width
        ADSearch.Attributes.Add("ReturnAttribute", ReturnAttribute)
        ADSearch.Attributes.Add("SearchClasses", SearchClasses)
        ADSearch.Enabled = Enabled
    End Sub

    Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        'If Not (CS.IsClientScriptBlockRegistered(Me.GetType(), scriptName)) Then
        '    Dim script As StringBuilder = New StringBuilder()
        '    script.Append("<script type=""text/javascript"">")
        '    script.Append("    function OnClientItemsRequesting(sender, eventArgs) {")
        '    script.Append("        var context = eventArgs.get_context();")
        '    script.Append("        context['FilterString'] = eventArgs.get_text();")
        '    script.Append("        context['ReturnAttribute'] = sender.get_attributes().getAttribute('ReturnAttribute');")
        '    script.Append("        context['SearchClasses'] = sender.get_attributes().getAttribute('SearchClasses');")
        '    script.Append("    }")
        '    script.Append("    function onClientItemDataBound(Sender, eventArgs) {")
        '    script.Append("        var item = eventArgs.get_item();")
        '    script.Append("        var dataItem = eventArgs.get_dataItem();")
        '    script.Append("        var SearchText = Sender.get_text();")
        '    script.Append("        var ItemText = item.get_text();")
        '    script.Append("        if (ItemText.length > (SearchText.length + 4)) {")
        '    script.Append("            item.set_text('...' + ItemText.substr(SearchText.length))")
        '    script.Append("        }")
        '    script.Append("        if (dataItem.Attributes.Type == 'person') {")
        '    script.Append("            item.set_imageUrl('/Images/Person_16x16.png');")
        '    script.Append("        } else {")
        '    script.Append("            item.set_imageUrl('/Images/Group_16x16.png');")
        '    script.Append("        }")
        '    script.Append("    }")
        '    script.Append("</script>")
        '    'CS.RegisterStartupScript(Me.GetType(), scriptName, script.ToString())
        '    CS.RegisterClientScriptBlock(Me.GetType(), scriptName, script.ToString())
        'End If
    End Sub
End Class
