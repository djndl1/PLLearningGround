Attribute VB_Name = "FileTimeDateTimes"
Option Explicit

Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type


Private Declare Sub GetSystemTimePreciseAsFileTime Lib "kernel32" (ByRef lpSystemTimeAsFileTime As FILETIME)

Private Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILETIME, lpSystemTime As SYSTEMTIME) As Long

Private Declare Function FileTimeToLocalFileTime Lib "kernel32" (lpFileTime As FILETIME, lpLocalFileTime As FILETIME) As Long


Private Function FromFileTime(ft As FILETIME) As CFileTime
        Dim cft As CFileTime
        Set cft = New CFileTime
        cft.LowDateTime = ft.dwLowDateTime
        cft.HighDateTime = ft.dwHighDateTime

        Set FromFileTime = cft
End Function

Private Function ToFileTime(ByVal cft As CFileTime) As FILETIME
        Dim ft As FILETIME
        
        ft.dwLowDateTime = cft.LowDateTime
        ft.dwHighDateTime = cft.HighDateTime

        ToFileTime = ft
End Function

Public Function GetUtcNow() As FileTimeDateTime
        Dim ft As FILETIME
        GetSystemTimePreciseAsFileTime ft

        Dim cft As CFileTime
        Set cft = FromFileTime(ft)

        Dim t As FileTimeDateTime
        Set t = New FileTimeDateTime
        t.InitFromFileTime cft

        Set GetUtcNow = t
End Function

Public Function GetLocalNow() As FileTimeDateTime
        Dim uft As FILETIME, ft As FILETIME
        GetSystemTimePreciseAsFileTime uft
        FileTimeToLocalFileTime uft, ft

        Dim cft As CFileTime
        Set cft = FromFileTime(ft)

        Dim t As FileTimeDateTime
        Set t = New FileTimeDateTime
        t.InitFromFileTime cft

        Set GetLocalNow = t
End Function


Public Function FormatFileTimeDateTimeToISO(ftd As FileTimeDateTime) As String
        Dim cft As CFileTime
        Set cft = ftd.ToCFileTime()
        Dim ft As FILETIME
        ft = ToFileTime(cft)

        Dim sysTime As SYSTEMTIME
        FileTimeToSystemTime ft, sysTime

        FormatFileTimeDateTimeToISO = SystemTimeDateTime.SYSTEMTIMEAsISO8601(sysTime)
End Function
