Attribute VB_Name = "FileTimeDateTimes"
Option Explicit

Public Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type

Public Enum DateTimeKind
        DateTimeKind_Unspecified = 0
        DateTimeKind_Utc = 1
        DateTimeKind_Local = 2
End Enum


Private Declare Sub GetSystemTimePreciseAsFileTime Lib "kernel32" (ByRef lpSystemTimeAsFileTime As FILETIME)

Private Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILETIME, lpSystemTime As SYSTEMTIME) As Long

Private Declare Function SystemTimeToFileTime Lib "kernel32" (ByRef lpSystemTime As SYSTEMTIME, ByRef lpFileTime As FILETIME) As Long

Private Declare Function FileTimeToLocalFileTime Lib "kernel32" (lpFileTime As FILETIME, lpLocalFileTime As FILETIME) As Long

Private s_unixEpoch As FileTimeDateTime

Private s_fileTimeEpoch As FileTimeDateTime

Public Property Get NtEpoch() As FileTimeDateTime
        If s_fileTimeEpoch Is Nothing Then
                Set s_fileTimeEpoch = New FileTimeDateTime
        End If
        Set NtEpoch = s_fileTimeEpoch
End Property

Public Property Get UnixEpoch() As FileTimeDateTime
        If s_unixEpoch Is Nothing Then
                Set s_unixEpoch = FromDateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind_Utc)
        End If

        Set UnixEpoch = s_unixEpoch
End Property

Public Function FromFileTime(ft As FILETIME, Optional dtKind As DateTimeKind = DateTimeKind_Unspecified) As FileTimeDateTime
        Dim cft As FileTimeDateTime
        Set cft = New FileTimeDateTime
        cft.InitFromFileTime ft.dwLowDateTime, ft.dwHighDateTime, dtKind

        Set FromFileTime = cft
End Function

Private Function ToFileTime(ByVal cft As FileTimeDateTime) As FILETIME
        Dim ft As FILETIME
        
        ft.dwLowDateTime = cft.LowDateTime
        ft.dwHighDateTime = cft.HighDateTime

        ToFileTime = ft
End Function

Public Function FromSystemTime(sysTime As SYSTEMTIME, Optional dtKind As DateTimeKind = DateTimeKind_Unspecified) As FileTimeDateTime
        Dim ft As FILETIME
        Call SystemTimeToFileTime(sysTime, ft)
        Set FromSystemTime = FromFileTime(ft, dtKind)
End Function

Public Function ToSystemTime(ftd As FileTimeDateTime) As SYSTEMTIME
        Dim ft As FILETIME
        ft = ToFileTime(ftd)
        Dim sysTime As SYSTEMTIME
        FileTimeToSystemTime ft, sysTime

        ToSystemTime = sysTime
End Function

Public Function FromDateTime(ByVal year As Long, _
                             ByVal month As Long, _
                             ByVal day As Long, _
                             Optional ByVal hour As Long, _
                             Optional ByVal minute As Long = 0, _
                             Optional ByVal second As Long = 0, _
                             Optional ByVal millisecond As Long = 0, _
			     Optional Byval microsecond As Long = 0, _
                             Optional ByVal dtKind As DateTimeKind = DateTimeKind_Unspecified) As FileTimeDateTime
        Dim sysT As SYSTEMTIME
        sysT.wYear = year
        sysT.wMonth = month
        sysT.wDay = day
        sysT.wHour = hour
        sysT.wMinute = minute
        sysT.wSecond = second
        sysT.wMilliseconds = millisecond

	Dim ft As FILETIME
	SystemTimeToFileTime sysT, ft
	ft.dwLowDateTime = ft.dwLowDateTime + microsecond * 10

        Set FromDateTime = FromFileTime(ft, dtKind)
End Function

Public Function GetUtcNow() As FileTimeDateTime
        Dim ft As FILETIME
        GetSystemTimePreciseAsFileTime ft

        Set GetUtcNow = FromFileTime(ft, DateTimeKind_Utc)
End Function

Public Function GetLocalNow() As FileTimeDateTime
        Dim uft As FILETIME, ft As FILETIME
        GetSystemTimePreciseAsFileTime uft
        FileTimeToLocalFileTime uft, ft
        
        Set GetLocalNow = FromFileTime(ft, DateTimeKind_Local)
End Function

Public Function GetToday() As FileTimeDateTime
	Set GetToday = GetLocalNow().DatePart
End Function

Public Function FormatFileTimeDateTimeToISO(ftd As FileTimeDateTime) As String
        Dim sysTime As SYSTEMTIME
        sysTime = ToSystemTime(ftd)
        Dim s As String
        s = SystemTimeDateTime.SYSTEMTIMEAsISO8601(sysTime)
        If ftd.Kind = DateTimeKind_Utc Then
                s = s & "Z"
        End If
        FormatFileTimeDateTimeToISO = s
End Function
