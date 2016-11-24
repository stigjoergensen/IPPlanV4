Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Management.Automation

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://dsv.com/ipplan/ExtProviders/WSTest")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class WSTest
    Inherits System.Web.Services.WebService


    Public Class PSDirectory
        Public PSChildName As String
        Public PSDrive As String
        Public BaseName As String
        Public Mode As String
        Public Name As String
        Public Parent As String
        Public Exists As String
        Public Root As String
        Public FullName As String
        Public Extension As String
        Public CreationTime As DateTime?
        Public CreationTimeUtc As DateTime?
        Public LastAccessTime As DateTime?
        Public LastAccessTimeUtc As DateTime?
        Public LastWriteTime As DateTime?
        Public LastWriteTimeUtc As DateTime?
        Public Attributes As DateTime?
    End Class

    Private Function OpenDB(SQLStatement As String) As SqlCommand
        Dim connection As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        connection.Open()
        OpenDB = New SqlCommand(SQLStatement, connection)
    End Function

    Private Sub CloseDB(SQLCmd As SqlCommand)
        SQLCmd.Connection.Close()
        SQLCmd.Connection.Dispose()
        SQLCmd.Connection = Nothing
    End Sub

    Shared Function GetDBValue(reader As SqlDataReader, Fieldname As String) As Object
        If IsDBNull(reader(Fieldname)) Then
            If reader(Fieldname).GetType() Is GetType(System.String) Then
                Return ""
            Else
                Return Nothing
            End If
        Else
            Return reader(Fieldname)
        End If
    End Function

    Private Sub SetDBValue(SQLCmd As SqlCommand, FieldName As String, Value As Object)
        If Value.GetType() Is GetType(System.String) AndAlso Value = "" Then
            SQLCmd.Parameters(FieldName).Value = DBNull.Value
        Else
            If Value Is Nothing Then
                SQLCmd.Parameters(FieldName).Value = DBNull.Value
            Else
                SQLCmd.Parameters(FieldName).Value = Value
            End If
        End If
    End Sub


    <WebMethod()> _
    Public Function BulkInsertPSDir(arg As List(Of System.Management.Automation.PSObject)) As Integer
        Console.WriteLine(arg)
        Return 0
    End Function

    <WebMethod()> _
    Public Function test(arg As System.IO.FileSystemInfo) As Integer
        Return 0
    End Function


    <WebMethod()> _
    Public Function InsertPSDir(arg As PSDirectory) As Integer
        Console.WriteLine(arg)
        Return 0
    End Function

    <WebMethod()> _
    Public Function GetPSDirectoryType() As PSDirectory
        Return New PSDirectory
    End Function

End Class