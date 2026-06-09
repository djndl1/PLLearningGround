Attribute VB_Name = "Win32API"
Option Explicit

' Win32API - Win32 declares for date/time FILETIME/SYSTEMTIME/OLE Date
' conversions. Declares must be Public (not Private) so that other project
' modules (notably FileTimeDateTimes.cls) can call them. They remain
' project-internal because .bas modules are not COM-exposed in an ActiveX DLL.

#If LEGACY_OS = 1 Then
Public Declare Sub GetSystemTimeAsFileTime Lib "kernel32" (ByRef lpSystemTimeAsFileTime As FILETIME)
#Else
Public Declare Sub GetSystemTimePreciseAsFileTime Lib "kernel32" (ByRef lpSystemTimeAsFileTime As FILETIME)
#End If

Public Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILETIME, lpSystemTime As SYSTEMTIME) As Long
Public Declare Function SystemTimeToFileTime Lib "kernel32" (ByRef lpSystemTime As SYSTEMTIME, ByRef lpFileTime As FILETIME) As Long
Public Declare Function FileTimeToLocalFileTime Lib "kernel32" (lpFileTime As FILETIME, lpLocalFileTime As FILETIME) As Long
Public Declare Function LocalFileTimeToFileTime Lib "kernel32" (lpLocalFileTime As FILETIME, lpFileTime As FILETIME) As Long

Public Declare Function SystemTimeToVariantTime Lib "OleAut32.dll" (lpSystemTime As SYSTEMTIME, ByRef pvtime As Date) As Long
Public Declare Function VariantTimeToSystemTime Lib "OleAut32.dll" (ByVal vtime As Date, lpSystemTime As SYSTEMTIME) As Long
