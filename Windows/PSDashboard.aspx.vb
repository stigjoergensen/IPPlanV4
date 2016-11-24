
Partial Class Windows_PSDashboard
    Inherits System.Web.UI.Page
    Dim deviderdate As Date

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        deviderdate = Now
    End Sub


    Protected Overloads Function TimeTaken(Date1 As Object, Date2 As Object) As String
        If IsDBNull(Date1) Then Date1 = Now
        If IsDBNull(Date2) Then Date2 = Now
        Dim tt As Integer = DateDiff(DateInterval.Second, Date2, Date1)
        If tt > 600 Then
            Return DateDiff(DateInterval.Minute, Date2, Date1).ToString() + " min"
        Else
            Return tt.ToString() + " sec"
        End If
    End Function

    Protected Overloads Function TimeTaken(Secs As Object) As String
        If IsDBNull(Secs) Then
            Return "n/a"
        Else
            If Secs < 0 Then
                Return "shortly"
            Else
                If Secs > 120 Then
                    Return (Math.Round(Secs / 60)).ToString() + " min"
                Else
                    Return (Math.Round(Secs - 0.5)).ToString() + " sec"
                End If
            End If
        End If
    End Function

    Protected Function ETA(StartTime As Object, AvgTime As Object) As String
        If IsDBNull(StartTime) Or IsDBNull(AvgTime) Then
            Return "n/a"
        Else
            Return "ETA " + TimeTaken((DirectCast(StartTime, DateTime).AddSeconds(AvgTime) - Now()).TotalSeconds)
        End If
    End Function

    Protected Sub RGPSScript_ItemDataBound(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles RGPSScript.ItemDataBound
        If e.Item.OwnerTableView.Name = "PSScriptDefList" Then
            If TypeOf e.Item Is Telerik.Web.UI.GridDataItem Then
                Dim item As Telerik.Web.UI.GridDataItem = e.Item
                If DateDiff(DateInterval.Day, item.DataItem("Started"), deviderdate) > 0 Then
                    deviderdate = item.DataItem("Started")
                    '#f6f9fb #fff #c2cedb #e1eaf3
                    item.Attributes.Add("style", "border-top: 1px solid #c2cedb !important;")
                End If
            End If
        End If
    End Sub

End Class
