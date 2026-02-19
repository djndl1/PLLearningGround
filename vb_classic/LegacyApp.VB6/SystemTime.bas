Attribute VB_Name = "SystemTimeDateTime"
Option Explicit


Private Declare Sub GetSystemTime Lib "kernel32.dll" (ByRef lpSystemTime As SYSTEMTIME)
Private Declare Sub GetLocalTime Lib "kernel32.dll" (ByRef lpSystemTime As SYSTEMTIME)

Public Function DateTimeAsISO8601(ByRef d As Date) As String
   DateTimeAsISO8601 = Format(d, "yyyy-mm-ddThh:nn:ss")
End Function

Public Function SYSTEMTIMEAsISO8601(ByRef sysTime As SYSTEMTIME) As String
        Dim yearString As String
        yearString = Format(sysTime.wYear, "0000")
        Dim monthString As String
        monthString = Format(sysTime.wMonth, "00")
        Dim dayString As String
        dayString = Format(sysTime.wDay, "00")
        Dim hourString As String
        hourString = Format(sysTime.wHour, "00")
        Dim minuteString As String
        minuteString = Format(sysTime.wMinute, "00")
        Dim secondString As String
        secondString = Format(sysTime.wSecond, "00")
        Dim milliString As String
        milliString = Format(sysTime.wMilliseconds, "000")

        SYSTEMTIMEAsISO8601 = yearString & "-" & monthString & "-" & dayString & "T" _
               & hourString & ":" & minuteString & ":" & secondString & "." & milliString
End Function



Public Function LocalSystemTimeNow() As SYSTEMTIME
        Dim s As SYSTEMTIME
        GetLocalTime s
        LocalSystemTimeNow = s
End Function

Public Function UtcSystemTimeNow() As SYSTEMTIME
        Dim s As SYSTEMTIME
        GetSystemTime s
        UtcSystemTimeNow = s
End Function

