Attribute VB_Name = "FileTimeDateTimes"
Option Explicit

Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type


Private Declare Sub GetSystemTimePreciseAsFileTime Lib "kernel32" (ByRef lpSystemTimeAsFileTime As FILETIME)

Private Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILETIME, lpSystemTime As SYSTEMTIME) As Long

Private Declare Function SystemTimeToFileTime Lib "kernel32" (ByRef lpSystemTime As SYSTEMTIME, ByRef lpFileTime As FILETIME) As Long

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

Public Function FromDateTime(ByVal year As Long, _
			     ByVal month As Long, _
			     ByVal day As Long, _
			     Optional ByVal hour As Long, _
			     Optional ByVal minute As Long = 0, _
			     Optional ByVal second As Long = 0, _
			     Optional ByVal millisecond As Long = 0, _
			     Optional ByVal dtKind As DateTimeKind = DateTimeKind_Unspecified) As FileTimeDateTime
	Dim sysT As SYSTEMTIME
	sysT.wYear = year
        sysT.wMonth = month
        sysT.wDay = day
        sysT.wHour = hour
        sysT.wMinute = minute
        sysT.wSecond = second
        sysT.wMilliseconds = millisecond

	Dim ft As FileTime
	Dim converted As Long
	converted = SystemTimeToFileTime(sysT, ft)

	If converted <> 0 Then
		Debug.Print "Invalid date!"
	End If

	Dim cft As CFileTime
	Set cft = FromFileTime(ft)

	Dim ftdt As FileTimeDateTime
	Set ftdt = New FileTimeDateTime
	Call ftdt.InitFromFileTime(cft, dtKind)

	Set FromDateTime = ftdt
End Function

Public Function GetUtcNow() As FileTimeDateTime
        Dim ft As FILETIME
        GetSystemTimePreciseAsFileTime ft

        Dim cft As CFileTime
        Set cft = FromFileTime(ft)

        Dim t As FileTimeDateTime
        Set t = New FileTimeDateTime
        t.InitFromFileTime cft, DateTimeKind_Utc

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
        t.InitFromFileTime cft, DateTimeKind_Local

        Set GetLocalNow = t
End Function


Public Function FormatFileTimeDateTimeToISO(ftd As FileTimeDateTime) As String
        Dim cft As CFileTime
        Set cft = ftd.ToCFileTime()
        Dim ft As FILETIME
        ft = ToFileTime(cft)

        Dim sysTime As SYSTEMTIME
        FileTimeToSystemTime ft, sysTime
	Dim s As String
	s = SystemTimeDateTime.SYSTEMTIMEAsISO8601(sysTime)
	If ftd.Kind = DateTimeKind_Utc then
		s = s & "Z"
	End If
        FormatFileTimeDateTimeToISO = s
End Function
