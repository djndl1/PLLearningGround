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

Private s_Bit33UInteger As Variant

Private s_MaxLong As Variant

Private s_ticksPerMicrosecond As Variant
Private s_ticksPerMillisecond As Variant
Private s_ticksPerSecond As Variant
Private s_ticksPerMinute As Variant
Private s_ticksPerHour As Variant
Private s_ticksPerDay As Variant

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

Private Property Get Bit33UInteger() As Variant
	If IsEmpty(s_Bit33UInteger) Then
		s_Bit33UInteger = CDec("4294967296")
	End if

	Bit33UInteger = s_Bit33UInteger
End Property

Private Property Get MaxLong() As Variant
	If IsEmpty(s_MaxLong) Then
		s_MaxLong	= CDec("2147483647")
	End if

	MaxLong = s_MaxLong
End Property

Public Property Get TicksPerMicrosecond As Variant
	If IsEmpty(s_TicksPerMicrosecond) Then
		s_TicksPerMicrosecond	= CDec("10")
	End if

	TicksPerMicrosecond = s_TicksPerMicrosecond
End Property

Public Property Get TicksPerMillisecond As Variant
	If IsEmpty(s_TicksPerMillisecond) Then
		s_TicksPerMillisecond	= CDec("1000") * TicksPerMicrosecond
	End if

	TicksPerMillisecond = s_TicksPerMillisecond
End Property

Public Property Get TicksPerSecond As Variant
	If IsEmpty(s_TicksPerSecond) Then
		s_TicksPerSecond	= CDec("1000") * TicksPerMillisecond
	End If

	TicksPerSecond = s_TicksPerSecond
End Property

Public Property Get TicksPerMinute As Variant
	If IsEmpty(s_TicksPerMinute) Then
		s_TicksPerMinute	= CDec("60") * TicksPerSecond
	End If

	TicksPerMinute = s_TicksPerMinute
End Property

Public Property Get TicksPerHour As Variant
	If IsEmpty(s_TicksPerHour) Then
		s_TicksPerHour	= CDec("60") * TicksPerMinute
	End If

	TicksPerHour = s_TicksPerHour
End Property

Public Property Get TicksPerDay As Variant
	If IsEmpty(s_TicksPerDay) Then
		s_TicksPerDay	= CDec("24") * TicksPerHour
	End If

	TicksPerDay = s_TicksPerDay
End Property

Private Function ULongToLong(ul As Variant) As Long
	Dim l As Long
	If ul > MaxLong Then
		l = CLng(ul - Bit33UInteger)
	Else 
		l = CLng(ul)
	End If

	ULongToLong = l
End Function

Private Function LongToULong(l As Long) As Variant
	Dim ul As Variant
	ul = CDec(l)
	if ul < 0 Then
		ul = ul + Bit33UInteger
	End If

	LongToULong = ul
End Function

Public Function ConvertDecimalToFileTime(ticks As Variant) As FILETIME
	Dim highPartInt As Variant	, highPart As Variant
	highPart = ticks / Bit33UInteger
	highPartInt = CLng(highPart)

	If highPart  < highPartInt Then
		highPartInt = highPartInt - 1
	End If

	Dim lowPartInt As Variant
	lowPartInt = ticks - Bit33UInteger * highPartInt

	Dim highDateTime As Long, lowDateTime As Long
	highDateTime = ULongToLong(highPartInt)
	lowDateTime = ULongToLong(lowPartInt)

	Dim ft As FILETIME
	ft.dwLowDateTime = lowDateTime
	ft.dwHighDateTime = highDateTime

	ConvertDecimalToFileTime = ft
End Function

Public Function ConvertFileTimeToDecimal(ft As FILETIME) As Variant
	Dim h As Variant, l As Variant
	h = LongToULong(ft.dwHighDateTime)
	l = LongToULong(ft.dwLowDateTime)

	ConvertFileTimeToDecimal = h * Bit33UInteger + l
End Function


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
