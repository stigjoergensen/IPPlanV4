Imports Microsoft.VisualBasic

Public Class IPConst
    Public Const DateDisabled As Date = #1/1/1900#
    Public Const DateNull As Date = #1/1/1901#
    Public Const AppidMode As Integer = 2
    Public Enum Hostmode
        undef = 0
        Hostname = 1
        AppID = 2
    End Enum
    Public Enum HostTypes
        ' must match the table IPPlanHostTypes
        Unknown = 0
        ClusterNode = 1
        ClusterInstance = 2
        ClusterResource = 3
        ESXServer = 4
        AIX = 5
        LinuxSuse = 6
        LinuxRedHat = 7
        OtherOS = 8
        SQLInstance = 9
        Windows = 10
    End Enum

    Shared Function GetConnectionString(ByVal Key As String) As String
        Try
            Return WebConfigurationManager.ConnectionStrings(System.Environment.MachineName + "." + Key).ConnectionString
        Catch ex As Exception
            Return WebConfigurationManager.ConnectionStrings(Key).ConnectionString
        End Try
    End Function

    Shared Function GetConfig(ByVal Key As String) As String
        Try
            Dim tmp As String
            tmp = WebConfigurationManager.AppSettings(System.Environment.MachineName + "." + Key)
            If tmp Is Nothing Then
                tmp = WebConfigurationManager.AppSettings(Key)
            End If
            Return tmp
        Catch ex As Exception
            Return WebConfigurationManager.AppSettings(Key)
        End Try
    End Function
End Class
