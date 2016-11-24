Imports Microsoft.VisualBasic

Public Interface IShowable
    Sub Show()
End Interface

Public Interface IShowableWithTitle
    Sub Show(Title As String)
End Interface

Public Interface IExecutePS
    Sub Show(Title As String, PSID As Integer, Optional Key As String = "")
End Interface

Public Interface IShowAbleWithHostname
    Sub Show(Hostname As String)
End Interface

Public Interface IEditableWithHostname
    Sub Edit(Hostname As String)
End Interface

Public Interface IShowAbleWithPSID
    Sub Show(PSID As Integer)
End Interface

Public Interface IEditableWithPSID
    Sub Edit(PSID As Integer)
End Interface

Public Interface IShowableApplication
    Sub Show(RecordType As String, ID As Integer)
End Interface

Public Interface IShowableEnvironmentID
    Sub show(EnvironmentID As Integer)
End Interface

Public Interface IShowableEnvironmentName
    Sub show(EnvironmentName As String)
End Interface

Public Interface IShowablePSDetails
    Sub show(Type As String, ID As Integer)
End Interface

Public Interface ISaveable
    Sub save()
End Interface