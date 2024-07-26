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
Option Explicit

Private m_ftimestamp As FILETIME

Private m_dtKind As DateTimeKind

Public Property Get LowDateTime() As Long
        LowDateTime = m_ftimestamp.dwLowDateTime
End Property

Public Property Get HighDateTime() As Long
        HighDateTime = m_ftimestamp.dwHighDateTime
End Property

Public Property Get Kind() As DateTimeKind
        Kind = m_dtKind
End Property

Public Property Get DatePart() As FileTimeDateTime
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)

        Set DatePart = FileTimeDateTimes.FromDateTime(sysTime.wYear, sysTime.wMonth, sysTime.wDay, dtKind:=Me.Kind)
End Property

Public Property Get YearPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
                
        YearPart = sysTime.wYear
End Property

Public Property Get MonthPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
                
        MonthPart = sysTime.wMonth
End Property

Public Property Get DayPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
                
        DayPart = sysTime.wDay
End Property

Public Property Get HourPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
                
        HourPart = sysTime.wHour
End Property

Public Property Get MinutePart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
                
        MinutePart = sysTime.wMinute
End Property

Public Property Get SecondPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
                
        SecondPart = sysTime.wSecond
End Property

Public Property Get MillisecondPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
                
        MillisecondPart = sysTime.wMilliseconds
End Property

Private Function GetSubmillisecondTicks() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)

        Dim convertedBack As FileTimeDateTime
        Set convertedBack = FileTimeDateTimes.FromSystemTime(sysTime)

        GetSubmillisecondTicks = CInt(m_ftimestamp.dwLowDateTime - convertedBack.LowDateTime)
End Function

Public Property Get MicrosecondPart() As Integer
        MicrosecondPart = GetSubmillisecondTicks() \ 10
End Property

Public Property Get NanosecondPart() As Integer
        NanosecondPart = (GetSubmillisecondTicks() Mod 10) * 100
End Property

Sub Class_Initialize()
        m_dtKind = DateTimeKind_Utc
End Sub

Public Sub InitFromFileTime(ByVal lowPart As Long, ByVal highPart As Long, Optional ByVal dtKind As DateTimeKind = FileTimeDateTimes.DateTimeKind_Unspecified)
        m_ftimestamp.dwLowDateTime = lowPart
        m_ftimestamp.dwHighDateTime = highPart
        m_dtKind = dtKind
End Sub


Public Function ToISOFormat() As String
        Dim yearString As String
        yearString = Format(YearPart, "0000")
        Dim monthString As String
        monthString = Format(MonthPart, "00")
        Dim dayString As String
        dayString = Format(DayPart, "00")
        Dim hourString As String
        hourString = Format(HourPart, "00")
        Dim minuteString As String
        minuteString = Format(MinutePart, "00")
        Dim secondString As String
        secondString = Format(SecondPart, "00")
        Dim milliString As String
        milliString = Format(MillisecondPart, "000")
        Dim microString As String
        microString = Format(MicrosecondPart, "000")
        Dim nanoString As String
        nanoString = Format(NanosecondPart, "000")

	Dim s As String
         s = yearString & "-" & monthString & "-" & dayString & "T" _
               & hourString & ":" & minuteString & ":" & secondString & "." & milliString & microString & nanoString
        If Me.Kind = DateTimeKind_Utc Then
                s = s & "Z"
        End If
	
	ToISOFormat = s
End Function
