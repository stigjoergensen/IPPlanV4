
Partial Class Error404
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim Redirect As String = ""
        Dim Type As String = ""
        Dim OriginalUrl As String = If(Request.QueryString("aspxerrorpath"), Request.RawUrl)
        If OriginalUrl.ToLower().StartsWith("/page/") Then
            Redirect = OriginalUrl
            Type = "Page"
        ElseIf OriginalUrl.ToLower().Contains(".aspx") Then
            Redirect = "window/ErrorPage.aspx?Pagename=" + OriginalUrl.Replace("?", "&")
            Type = "404"
            ' Log that the page is not available
        Else
            Redirect = ""
            Type = "404"
        End If

        Dim sb As StringBuilder = New StringBuilder()
        sb.Append("<html>")
        sb.Append("<body onload='document.forms[""form""].submit()'>")
        sb.AppendFormat("<form name='form' action='{0}' method='post'>", "/")
        sb.AppendFormat("<input type='hidden' name='redirect' value='{0}'>", Redirect)
        sb.AppendFormat("<input type='hidden' name='type' value='{0}'>", Type)
        sb.Append("</form>")
        sb.Append("</body>")
        sb.Append("</html>")
        Response.Write(sb.ToString())
        Response.End()
    End Sub
End Class
