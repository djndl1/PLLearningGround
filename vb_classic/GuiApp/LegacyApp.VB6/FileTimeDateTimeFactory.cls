VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "FileTimeDateTimeFactory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' FileTimeDateTimeFactory - Factory class for creating FileTimeDateTime instances
' Provides static factory methods following the Factory pattern

Public Function GetUtcNow() As FileTimeDateTime
    Set GetUtcNow = FileTimeDateTimes.GetUtcNow()
End Function

Public Function GetLocalNow() As FileTimeDateTime
    Set GetLocalNow = FileTimeDateTimes.GetLocalNow()
End Function

Public Function GetToday() As FileTimeDateTime
    Set GetToday = FileTimeDateTimes.GetToday()
End Function

Public Function FromDateTime(ByVal year As Long, _
                            ByVal month As Long, _
                            ByVal day As Long, _
                            Optional ByVal hour As Long = 0, _
                            Optional ByVal minute As Long = 0, _
                            Optional ByVal second As Long = 0, _
                            Optional ByVal millisecond As Long = 0, _
                            Optional ByVal microsecond As Long = 0, _
                             Optional ByVal dtKind As DateTimeKind = UnspecifiedKind) As FileTimeDateTime
    Set FromDateTime = FileTimeDateTimes.FromDateTime(year, month, day, hour, minute, second, millisecond, microsecond, dtKind)
End Function

Public Function FromFileTime(ByVal lowPart As Long, ByVal highPart As Long, Optional ByVal dtKind As DateTimeKind = DateTimeKind.UnspecifiedKind) As FileTimeDateTime
    Dim ft As New FileTimeDateTime
    ft.InitFromFileTime lowPart, highPart, dtKind
    Set FromFileTime = ft
End Function

Public Function FromSystemTime(ByRef sysTime As SYSTEMTIME, Optional ByVal dtKind As DateTimeKind = DateTimeKind.UnspecifiedKind) As FileTimeDateTime
    Set FromSystemTime = FileTimeDateTimes.FromSystemTime(sysTime, dtKind)
End Function

Public Function FromTicks(ByVal ticks As Variant, Optional ByVal dtKind As DateTimeKind = UnspecifiedKind) As FileTimeDateTime
    Dim ft As New FileTimeDateTime
    ft.InitFromTicks ticks, dtKind
    Set FromTicks = ft
End Function
