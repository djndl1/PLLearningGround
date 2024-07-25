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

Public Enum DateTimeKind
	DateTimeKind_Unspecified = 0
	DateTimeKind_Utc = 1
	DateTimeKind_Local = 2
End Enum

Private m_ftimestamp As CFileTime

Private m_dtKind As DateTimeKind

Public Property Get Kind() As DateTimeKind
	Kind = m_dtKind
End Property

Public Sub InitFromFileTime(ByVal cft As CFileTime, Optional ByVal dtKind As DateTimeKind = DateTimeKind_Unspecified)
        Set m_ftimestamp = cft
	m_dtKind = dtKind
End Sub

Public Function ToCFileTime() As CFileTime
        Dim cft As New CFileTime
        cft.LowDateTime = m_ftimestamp.LowDateTime
        cft.HighDateTime = m_ftimestamp.HighDateTime

        Set ToCFileTime = cft
End Function

Public Function ToISOFormat() As String
        ToISOFormat = FileTimeDateTimes.FormatFileTimeDateTimeToISO(Me)
End Function
