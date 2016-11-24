Imports System
Imports System.Web
Imports System.Data

Public Class URLRedirector
    Implements IHttpModule

    Private mdsRedirect As DataSet

    Public Sub Init(ByVal TheApp As HttpApplication) Implements IHttpModule.Init
        AddHandler TheApp.BeginRequest, AddressOf Me.Application_BeginRequest
        ' Cache the redirection file in a dataset.
        mdsRedirect = New DataSet()
        mdsRedirect.ReadXml(HttpContext.Current.Server.MapPath("~/App_Data/Redirection.xml"))
    End Sub

    Public Sub Dispose() Implements IHttpModule.Dispose
        mdsRedirect = Nothing
    End Sub

    Private Sub Application_BeginRequest(ByVal Source As Object, ByVal e As EventArgs)
        Dim oApp As HttpApplication = CType(Source, HttpApplication)
        Dim strRequestUri As String

        strRequestUri = oApp.Request.Url.AbsoluteUri.ToLower()

        ' OPTION 1: Process all requests (use when running in Visual Studio)...
        ' Redirect known paths and just let the others fall through.
        Call RedirectKnownPath(oApp, strRequestUri)

        ' OPTION 2: Process only the 404 requests (use when running under IIS)...
        ' For this module to work under IIS, you must configure the web site to redirect
        ' all 404 requests back to the application.
        'If strRequestUri.Contains("?404;") Then
        '   If Not RedirectKnownPath(oApp, strRequestUri) Then
        '      ' Send all 404 requests for unknown paths to the default page.
        '      oApp.Response.Redirect("~/Default.aspx")
        '   End If
        'End If
    End Sub

    Private Function RedirectKnownPath(ByVal oApp As HttpApplication, _
          ByVal strRequestUri As String) As Boolean
        Dim strOriginalUri As String = strRequestUri
        Dim intPos As Integer
        Dim boolPathRedirected As Boolean = False
        Dim oRow As DataRow
        Dim strRequestPath As String
        Dim strDestinationUrl As String

        ' Extract the original URL if you received a 404 URL.
        intPos = strRequestUri.IndexOf("?404;")
        If intPos > 0 And strRequestUri.Length > (intPos + 5) Then
            strOriginalUri = strRequestUri.Substring(intPos + 5)
        End If

        ' Redirect the request if you find a matching request path.
        For Each oRow In mdsRedirect.Tables(0).Rows
            strRequestPath = Convert.ToString(oRow("RequestPath")).ToLower()
            If strOriginalUri.EndsWith(strRequestPath) Then
                strDestinationUrl = Convert.ToString(oRow("Target"))
                Call oApp.Response.Redirect(strDestinationUrl, False)
                boolPathRedirected = True
                Exit For
            End If
        Next

        Return boolPathRedirected
    End Function
End Class
