Attribute VB_Name = "DateTimeTest"
Option Explicit

Public Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type


Public Type SYSTEMTIME
        wYear As Integer
        wMonth As Integer
        wDayOfWeek As Integer
        wDay As Integer
        wHour As Integer
        wMinute As Integer
        wSecond As Integer
        wMilliseconds As Integer
End Type

Public Declare Function VariantTimeToSystemTime Lib "OleAut32.dll" (ByVal vtime As Date, ByRef lpSystemTime As SYSTEMTIME) As Long

Public Declare Function FileTimeToSystemTime Lib "kernel32.dll" (ByRef lpFileTime As FILETIME, ByRef lpSystemTime As SYSTEMTIME) As Long

Public Declare Function SystemTimeToFileTime Lib "kernel32.dll" (ByRef lpSystemTime As SYSTEMTIME, ByRef lpFileTime As FILETIME) As Long

Public Declare Sub GetSystemTime Lib "kernel32.dll" (ByRef lpSystemTime As SYSTEMTIME)

Public Declare Sub GetSystemTimeAsFileTime Lib "kernel32.dll" (lpSystemTimeAsFileTime As FILETIME)

Public Sub Run()
   ShowDateTest
   ShowInC
   GetUnixEpochAsFileTime
End Sub

Private Sub GetUnixEpochAsFileTime()
   Dim ft As FILETIME
   ft.dwHighDateTime = 27111902
   ft.dwLowDateTime = -717324288

   Console.WriteLine (CStr(ft.dwHighDateTime) & " " & CStr(ft.dwLowDateTime))
End Sub

Private Sub ShowInC()
   Dim ft As FILETIME
   GetSystemTimeAsFileTime ft

   Dim ti As SYSTEMTIME
   FileTimeToSystemTime ft, ti


   Dim f As String
   f = Format(ti.wYear, "0000") & "-" & Format(ti.wMonth, "00") & "-" & Format(ti.wDay, "00") & "T" _
    & Format(ti.wHour, "00") & ":" & Format(ti.wMinute, "00") & ":" & Format(ti.wSecond, "00") & "." & Format(ti.wMilliseconds, "000")

   Console.WriteLine f
End Sub

Private Sub ShowDateTest()
   Dim d As Date
   d = #7/22/2023 11:49:41 PM# ' build with literal
   AssertThat.IsTrue DateTimeAsISO8601(d) = "2023-07-22T23:49:41", "ISO8601 Format"

   Dim combined As Date
   combined = DateSerial(2023, 7, 22) + TimeSerial(23, 49, 41) 'build with functions
   AssertThat.IsTrue DateTimeAsISO8601(combined) = "2023-07-22T23:49:41", "ISO8601 Format"
   Console.WriteLine DateTimeAsISO8601(combined)

   Dim valueDate As Date
   valueDate = DateValue("2023-07-22 23:49:41") ' date only
   AssertThat.IsTrue DateTimeAsISO8601(valueDate) = "2023-07-22T00:00:00", "ISO8601 Format"

   Dim dvalue As Double
   dvalue = valueDate
   Console.WriteLine CStr(dvalue / 365.25) & " years since the Lotus 1-2-3 epoch"

   Dim tseconds As Single
   tseconds = Timer
   Dim tTime As Date
   tTime = Time
   AssertThat.IsTrue DateAsISO8601(tTime) = "1899-12-30", ""
End Sub

Public Function DateTimeAsISO8601(ByRef d As Date) As String
   DateTimeAsISO8601 = Format(d, "yyyy-mm-ddThh:nn:ss")
End Function

Public Function DateAsISO8601(ByRef d As Date) As String
   DateAsISO8601 = Format(d, "yyyy-mm-dd")
End Function
