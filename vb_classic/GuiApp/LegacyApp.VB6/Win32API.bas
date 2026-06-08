Attribute VB_Name = "Win32API"
Option Explicit

' Win32API - Win32 declares for date/time FILETIME/SYSTEMTIME/OLE Date
' conversions. All declares are project-internal (Private) and consumed
' by FileTimeDateTimes.cls in the same project.

#If LEGACY_OS = 1 Then
Private Declare Sub GetSystemTimeAsFileTime Lib "kernel32" (ByRef lpSystemTimeAsFileTime As FILETIME)
#Else
Private Declare Sub GetSystemTimePreciseAsFileTime Lib "kernel32" (ByRef lpSystemTimeAsFileTime As FILETIME)
#End If

Private Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILETIME, lpSystemTime As SYSTEMTIME) As Long
Private Declare Function SystemTimeToFileTime Lib "kernel32" (ByRef lpSystemTime As SYSTEMTIME, ByRef lpFileTime As FILETIME) As Long
Private Declare Function FileTimeToLocalFileTime Lib "kernel32" (lpFileTime As FILETIME, lpLocalFileTime As FILETIME) As Long
Private Declare Function LocalFileTimeToFileTime Lib "kernel32" (lpLocalFileTime As FILETIME, lpFileTime As FILETIME) As Long

Private Declare Function SystemTimeToVariantTime Lib "OleAut32.dll" (lpSystemTime As SYSTEMTIME, ByRef pvtime As Date) As Long
Private Declare Function VariantTimeToSystemTime Lib "OleAut32.dll" (ByVal vtime As Date, lpSystemTime As SYSTEMTIME) As Long
