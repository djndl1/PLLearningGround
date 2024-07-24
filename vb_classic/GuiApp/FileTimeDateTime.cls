VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "FileTimeDateTime"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private ftimestamp As CFileTime

Public Sub InitFromFileTime(ByVal cft As CFileTime)
        Set ftimestamp = cft
End Sub

Public Function ToCFileTime() As CFileTime
        Dim cft As New CFileTime
        cft.LowDateTime = ftimestamp.LowDateTime
        cft.HighDateTime = ftimestamp.HighDateTime

        Set ToCFileTime = cft
End Function

Public Function ToISOFormat() As String
        ToISOFormat = FileTimeDateTimes.FormatFileTimeDateTimeToISO(Me)
End Function
