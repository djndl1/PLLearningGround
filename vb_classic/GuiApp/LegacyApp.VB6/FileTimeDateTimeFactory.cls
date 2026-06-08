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
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' FileTimeDateTimeFactory - Factory class for creating FileTimeDateTime
' instances. The only place in the project that instantiates FileTimeDateTime.
' Internal callers can use the predeclared static access:
'   FileTimeDateTimeFactory.FromDateTime(...)
' External COM users must `New FileTimeDateTimeFactory` first.
'
' Epoch singletons (NtEpoch, UnixEpoch) are cached as Private fields with
' lazy-init; first call constructs the FTD, subsequent calls return the
' cached instance.

' --- Cached epoch singletons ---

Private m_ntEpoch As FileTimeDateTime
Private m_unixEpoch As FileTimeDateTime

' --- Factory methods ---

Public Function GetUtcNow() As FileTimeDateTime
Attribute GetUtcNow.VB_Description = "Returns a FileTimeDateTime representing the current UTC time.\r\n\r\nReturns:\r\n  FileTimeDateTime: A new instance with Kind=UtcKind."
    Dim ft As FILETIME
    GetSystemTimeAsFileTime ft
    Dim result As New FileTimeDateTime
    result.InitFromFileTime ft.dwLowDateTime, ft.dwHighDateTime, UtcKind
    Set GetUtcNow = result
End Function

Public Function GetLocalNow() As FileTimeDateTime
Attribute GetLocalNow.VB_Description = "Returns a FileTimeDateTime representing the current local time.\r\n\r\nReturns:\r\n  FileTimeDateTime: A new instance with Kind=LocalKind."
    Dim utcFt As FILETIME
    Dim localFt As FILETIME
    GetSystemTimeAsFileTime utcFt
    Dim ok As Long
    ok = FileTimeToLocalFileTime(utcFt, localFt)
    Ensure.IsTrue ok <> 0, ErrorCodes.Overflow, "FileTimeDateTimeFactory.GetLocalNow", "FileTimeToLocalFileTime failed"
    Dim result As New FileTimeDateTime
    result.InitFromFileTime localFt.dwLowDateTime, localFt.dwHighDateTime, LocalKind
    Set GetLocalNow = result
End Function

Public Function GetToday() As FileTimeDateTime
Attribute GetToday.VB_Description = "Returns a FileTimeDateTime representing today at 00:00:00 local time.\r\n\r\nReturns:\r\n  FileTimeDateTime: A new instance with Kind=LocalKind and time components zeroed."
    Dim nowLocal As FileTimeDateTime
    Set nowLocal = GetLocalNow()
    Dim y As Integer, m As Integer, d As Integer
    Dim sysTime As SYSTEMTIME
    sysTime = nowLocal.ToSystemTime()
    y = sysTime.wYear
    m = sysTime.wMonth
    d = sysTime.wDay
    Set GetToday = FromDateTime(y, m, d, dtKind:=LocalKind)
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
Attribute FromDateTime.VB_Description = "Creates a FileTimeDateTime from a calendar date and time components.\r\n\r\nArgs:\r\n  year (Long): The year.\r\n  month (Long): The month (1-12).\r\n  day (Long): The day of the month.\r\n  hour (Long): The hour (0-23).\r\n  minute (Long): The minute (0-59).\r\n  second (Long): The second (0-59).\r\n  millisecond (Long): The millisecond (0-999).\r\n  microsecond (Long): The microsecond (0-999). Sub-millisecond, so it is preserved as a FILETIME tick offset.\r\n  dtKind (DateTimeKind): The kind to assign to the resulting FileTimeDateTime.\r\nReturns:\r\n  FileTimeDateTime: The new instance."
    Dim sysTime As SYSTEMTIME
    sysTime.wYear = CInt(year)
    sysTime.wMonth = CInt(month)
    sysTime.wDay = CInt(day)
    sysTime.wHour = CInt(hour)
    sysTime.wMinute = CInt(minute)
    sysTime.wSecond = CInt(second)
    sysTime.wMilliseconds = CInt(millisecond)
    Dim ft As FILETIME
    Dim result As Long
    result = SystemTimeToFileTime(sysTime, ft)
    Ensure.IsTrue result <> 0, ErrorCodes.Overflow, "FileTimeDateTimeFactory.FromDateTime", "SystemTimeToFileTime failed"
    Dim ftd As New FileTimeDateTime
    ftd.InitFromFileTime ft.dwLowDateTime, ft.dwHighDateTime, dtKind
    If microsecond <> 0 Then
        ftd = ftd.AddMicroseconds(CDbl(microsecond))
    End If
    Set FromDateTime = ftd
End Function

Public Function FromFileTime(ByVal LowPart As Long, ByVal HighPart As Long, Optional ByVal dtKind As DateTimeKind = DateTimeKind.UnspecifiedKind) As FileTimeDateTime
Attribute FromFileTime.VB_Description = "Creates a FileTimeDateTime from the two 32-bit halves of a FILETIME.\r\n\r\nArgs:\r\n  LowPart (Long): The low 32 bits of the FILETIME.\r\n  HighPart (Long): The high 32 bits of the FILETIME.\r\n  dtKind (DateTimeKind): The kind to assign to the resulting FileTimeDateTime.\r\nReturns:\r\n  FileTimeDateTime: The new instance."
    Dim ft As New FileTimeDateTime
    ft.InitFromFileTime LowPart, HighPart, dtKind
    Set FromFileTime = ft
End Function

Public Function FromSystemTime(ByRef sysTime As SYSTEMTIME, Optional ByVal dtKind As DateTimeKind = DateTimeKind.UnspecifiedKind) As FileTimeDateTime
Attribute FromSystemTime.VB_Description = "Creates a FileTimeDateTime from a SYSTEMTIME.\r\n\r\nArgs:\r\n  sysTime (SYSTEMTIME): The SYSTEMTIME to convert.\r\n  dtKind (DateTimeKind): The kind to assign to the resulting FileTimeDateTime.\r\nReturns:\r\n  FileTimeDateTime: The new instance."
    Dim ft As FILETIME
    Dim result As Long
    result = SystemTimeToFileTime(sysTime, ft)
    Ensure.IsTrue result <> 0, ErrorCodes.Overflow, "FileTimeDateTimeFactory.FromSystemTime", "SystemTimeToFileTime failed"
    Dim ftd As New FileTimeDateTime
    ftd.InitFromFileTime ft.dwLowDateTime, ft.dwHighDateTime, dtKind
    Set FromSystemTime = ftd
End Function

Public Function FromOleDate(ByVal oleDate As Date, ByVal dtKind As DateTimeKind) As FileTimeDateTime
Attribute FromOleDate.VB_Description = "Creates a FileTimeDateTime from an OLE Automation Date.\r\n\r\nArgs:\r\n  oleDate (Date): The OLE Date to convert.\r\n  dtKind (DateTimeKind): The kind to assign to the resulting FileTimeDateTime.\r\nReturns:\r\n  FileTimeDateTime: The new instance."
    Dim ft As FILETIME
    ft = FileTimeDateTimes.ConvertOleDateToFileTime(oleDate)
    Dim ftd As New FileTimeDateTime
    ftd.InitFromFileTime ft.dwLowDateTime, ft.dwHighDateTime, dtKind
    Set FromOleDate = ftd
End Function

Public Function FromTicks(ByVal ticks As Variant, Optional ByVal dtKind As DateTimeKind = UnspecifiedKind) As FileTimeDateTime
Attribute FromTicks.VB_Description = "Creates a FileTimeDateTime from a Decimal FILETIME tick count.\r\n\r\nArgs:\r\n  ticks (Variant): The Decimal tick count (100-ns intervals since 1601-01-01).\r\n  dtKind (DateTimeKind): The kind to assign to the resulting FileTimeDateTime.\r\nReturns:\r\n  FileTimeDateTime: The new instance."
    Dim ft As New FileTimeDateTime
    ft.InitFromTicks ticks, dtKind
    Set FromTicks = ft
End Function

' --- Epoch singletons ---

Public Function NtEpoch() As FileTimeDateTime
Attribute NtEpoch.VB_Description = "Returns the Windows NT epoch (1601-01-01 00:00:00 UTC) as a FileTimeDateTime singleton.\r\n\r\nReturns:\r\n  FileTimeDateTime: A cached instance representing the NT epoch."
    If m_ntEpoch Is Nothing Then
        Set m_ntEpoch = FromTicks(CDec(0), UtcKind)
    End If
    Set NtEpoch = m_ntEpoch
End Function

Public Function UnixEpoch() As FileTimeDateTime
Attribute UnixEpoch.VB_Description = "Returns the Unix epoch (1970-01-01 00:00:00 UTC) as a FileTimeDateTime singleton.\r\n\r\nReturns:\r\n  FileTimeDateTime: A cached instance representing the Unix epoch."
    If m_unixEpoch Is Nothing Then
        Set m_unixEpoch = FromTicks(FileTimeDateTimes.TicksPerDay * CDec("134774"), UtcKind)
    End If
    Set UnixEpoch = m_unixEpoch
End Function
