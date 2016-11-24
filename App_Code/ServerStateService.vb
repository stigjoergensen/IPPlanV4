Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

Namespace IPPlan
    ' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
    <System.Web.Script.Services.ScriptService()> _
    <WebService(Namespace:="http://tempuri.org/")> _
    <WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
    Public Class ServerStateService
        Inherits System.Web.Services.WebService

        Public Enum ServerStates
            unknown                 ' grey
            noSCOM                  ' white     = Unable to find scom webservice
            Normal                  ' green
            HTTPError               ' Orange
            InMaint                 ' blue
            Alerts                  ' red
            Warnings                ' yellow
        End Enum


        Public Class ServerState
            Public Property Element As String
            Public Property Servername As String
            Public Property EnvironmentID As Integer
            Public Property ImagePath As String
            Public Property ToolTip As String
            Public Property State As ServerStates
        End Class

        <WebMethod()> _
        Public Function HelloWorld() As String
            Return "Hello World"
        End Function

        <WebMethod()> _
        Public Function GetServerState(ElementName As String, Hostname As String, EnvironmentID As Integer) As ServerState
            Dim result As ServerState = New ServerState()
            result.Element = ElementName
            result.EnvironmentID = EnvironmentID
            result.Servername = Hostname

            Dim WebServiceEndPoint As IPPlanWebServiceEndPoint = New IPPlanWebServiceEndPoint("SCOM", EnvironmentID, "IPPlan_Get_Alert")
            If WebServiceEndPoint.EndPoint Is Nothing Then
                result.State = ServerStates.noSCOM
                result.ImagePath = "/images/bullet2_white.png"
                result.ToolTip = String.Format("Unable to find 'SCOM' WebServiceEndPoint for 'IPPlan_Get_Alert', EnvironmentID {0}", EnvironmentID)
            Else
                Dim params As Dictionary(Of String, String) = New Dictionary(Of String, String)
                If Hostname = "i04071" Then
                    result.ImagePath = "/images/bullet2_green.png"
                    params.Add("NetbiosComputerName", Hostname)
                    Dim WebResult As Dictionary(Of String, String) = WebServiceEndPoint.Invoke(params, True)
                    If WebResult("HTTPError").Length > 0 Then
                        result.ToolTip = String.Format("WebService returned http error:{0}<br>{1}", WebResult("HTTPError"), WebResult("HTTPResponse"))
                        result.ImagePath = "/images/bullet2_orange.png"
                        result.State = ServerStates.HTTPError
                    Else
                        result.ToolTip = String.Format("Alerts {0}, Warnings {1} ", WebResult("AlertCount"), WebResult("WarningCount"))
                        If WebResult("AlertCount") > 0 Then
                            result.ImagePath = "/images/bullet2_red.png"
                            result.State = ServerStates.Alerts
                        ElseIf WebResult("WarningCount") > 0 Then
                            result.ImagePath = "/images/bullet2_yellow.png"
                            result.State = ServerStates.Warnings
                        End If

                        If WebResult("MaintainceMode") = "True" Then
                            result.ImagePath = "/images/bullet2_blue.png"
                            result.State = ServerStates.InMaint
                        End If
                    End If
                Else
                    result.State = ServerStates.noSCOM
                    result.ImagePath = "/images/bullet2_white.png"
                    result.ToolTip = "Skipped due to testing"
                End If
            End If
            Return result
        End Function

    End Class
End Namespace
