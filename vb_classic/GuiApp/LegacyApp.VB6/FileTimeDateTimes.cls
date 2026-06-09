VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "FileTimeDateTimes"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' FileTimeDateTimes - UDT-based pseudo-OOP date/time API.
' Operates on FILETIME/SYSTEMTIME/Date/Decimal primitives, never on
' FileTimeDateTime instances. Class-based factories (FromFileTime,
' FromSystemTime, FromDateTime, GetUtcNow, GetLocalNow, GetToday,
' FromOleDate) live in FileTimeDateTimeFactory.cls. The two epoch
' singletons (NtEpoch, UnixEpoch) also live in the factory because
' they return FileTimeDateTime instances.
'
' Caches for the Convert* helpers and unit constants are populated
' once in Class_Initialize using CDec("...") string literals, which
' bypasses VB6's Long/Double literal type inference.

' --- Private cache fields ---

Private m_Bit33UInteger As Variant
Private m_MaxLong As Variant
Private m_ticksPerMicrosecond As Variant
Private m_ticksPerMillisecond As Variant
Private m_ticksPerSecond As Variant
Private m_ticksPerMinute As Variant
Private m_ticksPerHour As Variant
Private m_ticksPerDay As Variant

Private Sub Class_Initialize()
    m_Bit33UInteger = CDec("4294967296")
    m_MaxLong = CDec("2147483647")
    m_ticksPerMicrosecond = CDec("10")
    m_ticksPerMillisecond = CDec("1000") * m_ticksPerMicrosecond
    m_ticksPerSecond = CDec("1000") * m_ticksPerMillisecond
    m_ticksPerMinute = CDec("60") * m_ticksPerSecond
    m_ticksPerHour = CDec("60") * m_ticksPerMinute
    m_ticksPerDay = CDec("24") * m_ticksPerHour
End Sub

' --- Unit constants (Property Get) ---

Public Property Get TicksPerMicrosecond() As Variant
Attribute TicksPerMicrosecond.VB_Description = "Number of FILETIME ticks in one microsecond (10)."
    TicksPerMicrosecond = m_ticksPerMicrosecond
End Property

Public Property Get TicksPerMillisecond() As Variant
Attribute TicksPerMillisecond.VB_Description = "Number of FILETIME ticks in one millisecond (10,000)."
    TicksPerMillisecond = m_ticksPerMillisecond
End Property

Public Property Get TicksPerSecond() As Variant
Attribute TicksPerSecond.VB_Description = "Number of FILETIME ticks in one second (10,000,000)."
    TicksPerSecond = m_ticksPerSecond
End Property

Public Property Get TicksPerMinute() As Variant
Attribute TicksPerMinute.VB_Description = "Number of FILETIME ticks in one minute (600,000,000)."
    TicksPerMinute = m_ticksPerMinute
End Property

Public Property Get TicksPerHour() As Variant
Attribute TicksPerHour.VB_Description = "Number of FILETIME ticks in one hour (36,000,000,000)."
    TicksPerHour = m_ticksPerHour
End Property

Public Property Get TicksPerDay() As Variant
Attribute TicksPerDay.VB_Description = "Number of FILETIME ticks in one day (864,000,000,000)."
    TicksPerDay = m_ticksPerDay
End Property

Public Property Get NtEpoch() As Date
Attribute NtEpoch.VB_Description = "The Windows NT epoch, midnight of 1 January 1601 (the FILETIME origin)."
    NtEpoch = 0#
End Property

Public Property Get UnixEpoch() As Date
Attribute UnixEpoch.VB_Description = "The Unix epoch, midnight of 1 January 1970 UTC (Date = 25569)."
    UnixEpoch = DateSerial(1970, 1, 1)
End Property

' --- Internal helpers ---

Private Function ULongToLong(ul As Variant) As Long
    Dim l As Long
    If ul > m_MaxLong Then
        l = CLng(ul - m_Bit33UInteger)
    Else
        l = CLng(ul)
    End If
    ULongToLong = l
End Function

Private Function LongToULong(l As Long) As Variant
    Dim ul As Variant
    ul = CDec(l)
    If ul < 0 Then
        ul = ul + m_Bit33UInteger
    End If
    LongToULong = ul
End Function

' --- Convert* functions (UDT-based) ---

Public Function ConvertDecimalToFileTime(ticks As Variant) As FILETIME
Attribute ConvertDecimalToFileTime.VB_Description = "Converts a Decimal FILETIME tick count to a FILETIME UDT.\r\n\r\nArgs:\r\n  ticks (Variant): The Decimal tick count (100-ns intervals since 1601-01-01).\r\nReturns:\r\n  FILETIME: The corresponding FILETIME."
    Dim highPartInt As Variant
    Dim HighPart As Variant
    HighPart = ticks / m_Bit33UInteger
    highPartInt = CLng(HighPart)

    If HighPart < highPartInt Then
        highPartInt = highPartInt - 1
    End If

    Dim lowPartInt As Variant
    lowPartInt = ticks - m_Bit33UInteger * highPartInt

    Dim highDateTime As Long
    Dim lowDateTime As Long
    highDateTime = ULongToLong(highPartInt)
    lowDateTime = ULongToLong(lowPartInt)

    Dim ft As FILETIME
    ft.dwLowDateTime = lowDateTime
    ft.dwHighDateTime = highDateTime

    ConvertDecimalToFileTime = ft
End Function

Public Function ConvertFileTimeToDecimal(ft As FILETIME) As Variant
Attribute ConvertFileTimeToDecimal.VB_Description = "Converts a FILETIME UDT to a Decimal tick count.\r\n\r\nArgs:\r\n  ft (FILETIME): The FILETIME to convert.\r\nReturns:\r\n  Variant: The Decimal tick count (100-ns intervals since 1601-01-01)."
    Dim h As Variant
    Dim l As Variant
    h = LongToULong(ft.dwHighDateTime)
    l = LongToULong(ft.dwLowDateTime)
    ConvertFileTimeToDecimal = h * m_Bit33UInteger + l
End Function

Public Function ConvertFileTimeToSystemTime(ft As FILETIME) As SYSTEMTIME
Attribute ConvertFileTimeToSystemTime.VB_Description = "Converts a FILETIME to a SYSTEMTIME via the Win32 FileTimeToSystemTime API.\r\n\r\nRaises:\r\n  Overflow (Long): when FileTimeToSystemTime fails\r\nArgs:\r\n  ft (FILETIME): The FILETIME to convert.\r\nReturns:\r\n  SYSTEMTIME: The corresponding SYSTEMTIME."
    Dim sysTime As SYSTEMTIME
    Dim result As Long
    result = FileTimeToSystemTime(ft, sysTime)
    Ensure.IsTrue result <> 0, ErrorCodes.Overflow, "FileTimeDateTimes.ConvertFileTimeToSystemTime", "FileTimeToSystemTime failed"
    ConvertFileTimeToSystemTime = sysTime
End Function

Public Function ConvertSystemTimeToFileTime(sysTime As SYSTEMTIME) As FILETIME
Attribute ConvertSystemTimeToFileTime.VB_Description = "Converts a SYSTEMTIME to a FILETIME via the Win32 SystemTimeToFileTime API.\r\n\r\nRaises:\r\n  Overflow (Long): when SystemTimeToFileTime fails\r\nArgs:\r\n  sysTime (SYSTEMTIME): The SYSTEMTIME to convert.\r\nReturns:\r\n  FILETIME: The corresponding FILETIME."
    Dim ft As FILETIME
    Dim result As Long
    result = SystemTimeToFileTime(sysTime, ft)
    Ensure.IsTrue result <> 0, ErrorCodes.Overflow, "FileTimeDateTimes.ConvertSystemTimeToFileTime", "SystemTimeToFileTime failed"
    ConvertSystemTimeToFileTime = ft
End Function

Public Function ConvertOleDateToSystemTime(oleDate As Date) As SYSTEMTIME
Attribute ConvertOleDateToSystemTime.VB_Description = "Converts an OLE Date to a SYSTEMTIME via the Win32 VariantTimeToSystemTime API.\r\n\r\nRaises:\r\n  Overflow (Long): when VariantTimeToSystemTime fails\r\nArgs:\r\n  oleDate (Date): The OLE Date to convert.\r\nReturns:\r\n  SYSTEMTIME: The corresponding SYSTEMTIME."
    Dim sysTime As SYSTEMTIME
    Dim hr As Long
    hr = VariantTimeToSystemTime(oleDate, sysTime)
    Ensure.IsTrue hr <> 0, ErrorCodes.Overflow, "FileTimeDateTimes.ConvertOleDateToSystemTime", "VariantTimeToSystemTime failed"
    ConvertOleDateToSystemTime = sysTime
End Function

Public Function ConvertSystemTimeToOleDate(sysTime As SYSTEMTIME) As Date
Attribute ConvertSystemTimeToOleDate.VB_Description = "Converts a SYSTEMTIME to an OLE Automation Date via the Win32 SystemTimeToVariantTime API.\r\n\r\nRaises:\r\n  Overflow (Long): when SystemTimeToVariantTime fails\r\nArgs:\r\n  sysTime (SYSTEMTIME): The SYSTEMTIME to convert.\r\nReturns:\r\n  Date: The corresponding OLE Date."
    Dim hr As Long
    hr = SystemTimeToVariantTime(sysTime, ConvertSystemTimeToOleDate)
    Ensure.IsTrue hr <> 0, ErrorCodes.Overflow, "FileTimeDateTimes.ConvertSystemTimeToOleDate", "SystemTimeToVariantTime failed"
End Function

Public Function ConvertFileTimeToOleDate(ft As FILETIME) As Date
Attribute ConvertFileTimeToOleDate.VB_Description = "Converts a FILETIME to an OLE Automation Date via the Win32 FileTimeToSystemTime and SystemTimeToVariantTime APIs.\r\n\r\nRaises:\r\n  Overflow (Long): when SystemTimeToVariantTime fails\r\nArgs:\r\n  ft (FILETIME): The FILETIME to convert.\r\nReturns:\r\n  Date: The corresponding OLE Date."
    ConvertFileTimeToOleDate = ConvertSystemTimeToOleDate(ConvertFileTimeToSystemTime(ft))
End Function

Public Function ConvertOleDateToFileTime(oleDate As Date) As FILETIME
Attribute ConvertOleDateToFileTime.VB_Description = "Converts an OLE Date to a FILETIME via the Win32 VariantTimeToSystemTime and SystemTimeToFileTime APIs.\r\n\r\nRaises:\r\n  Overflow (Long): when VariantTimeToSystemTime or SystemTimeToFileTime fails\r\nArgs:\r\n  oleDate (Date): The OLE Date to convert.\r\nReturns:\r\n  FILETIME: The corresponding FILETIME."
    ConvertOleDateToFileTime = ConvertSystemTimeToFileTime(ConvertOleDateToSystemTime(oleDate))
End Function

Public Function ConvertOleDateToDecimal(oleDate As Date) As Variant
Attribute ConvertOleDateToDecimal.VB_Description = "Converts an OLE Date to a Decimal tick count via the Win32 VariantTimeToSystemTime and SystemTimeToFileTime APIs.\r\n\r\nRaises:\r\n  Overflow (Long): when VariantTimeToSystemTime or SystemTimeToFileTime fails\r\nArgs:\r\n  oleDate (Date): The OLE Date to convert.\r\nReturns:\r\n  Variant: The Decimal tick count."
    ConvertOleDateToDecimal = ConvertFileTimeToDecimal(ConvertOleDateToFileTime(oleDate))
End Function

Public Function ConvertDecimalToOleDate(ticks As Variant) As Date
Attribute ConvertDecimalToOleDate.VB_Description = "Converts a Decimal tick count to an OLE Date via ConvertDecimalToFileTime and ConvertFileTimeToOleDate.\r\n\r\nRaises:\r\n  Overflow (Long): when SystemTimeToVariantTime fails\r\nArgs:\r\n  ticks (Variant): The Decimal tick count.\r\nReturns:\r\n  Date: The corresponding OLE Date."
    ConvertDecimalToOleDate = ConvertFileTimeToOleDate(ConvertDecimalToFileTime(ticks))
End Function

Public Function ConvertFileTimeToLocalFileTime(ft As FILETIME) As FILETIME
Attribute ConvertFileTimeToLocalFileTime.VB_Description = "Converts a UTC FILETIME to a local FILETIME via the Win32 FileTimeToLocalFileTime API.\r\n\r\nRaises:\r\n  Overflow (Long): when FileTimeToLocalFileTime fails\r\nArgs:\r\n  ft (FILETIME): The UTC FILETIME to convert.\r\nReturns:\r\n  FILETIME: The corresponding local FILETIME."
    Dim result As Long
    result = FileTimeToLocalFileTime(ft, ConvertFileTimeToLocalFileTime)
    Ensure.IsTrue result <> 0, ErrorCodes.Overflow, "FileTimeDateTimes.ConvertFileTimeToLocalFileTime", "FileTimeToLocalFileTime failed"
End Function

Public Function ConvertLocalFileTimeToFileTime(ft As FILETIME) As FILETIME
Attribute ConvertLocalFileTimeToFileTime.VB_Description = "Converts a local FILETIME to a UTC FILETIME via the Win32 LocalFileTimeToFileTime API.\r\n\r\nRaises:\r\n  Overflow (Long): when LocalFileTimeToFileTime fails\r\nArgs:\r\n  ft (FILETIME): The local FILETIME to convert.\r\nReturns:\r\n  FILETIME: The corresponding UTC FILETIME."
    Dim result As Long
    result = LocalFileTimeToFileTime(ft, ConvertLocalFileTimeToFileTime)
    Ensure.IsTrue result <> 0, ErrorCodes.Overflow, "FileTimeDateTimes.ConvertLocalFileTimeToFileTime", "LocalFileTimeToFileTime failed"
End Function

' --- Higher-level UDT-based API ---

Public Function FormatFileTimeAsISO8601(ft As FILETIME, ByVal kind As DateTimeKind) As String
Attribute FormatFileTimeAsISO8601.VB_Description = "Formats a FILETIME as an ISO 8601 string. Appends the 'Z' suffix when kind is UtcKind.\r\n\r\nNote: sub-millisecond precision is lost (SYSTEMTIME only carries milliseconds).\r\n\r\nArgs:\r\n  ft (FILETIME): The FILETIME to format.\r\n  kind (DateTimeKind): The timezone interpretation; UtcKind adds the 'Z' suffix.\r\nReturns:\r\n  String: The ISO 8601 representation."
    Dim sysTime As SYSTEMTIME
    sysTime = ConvertFileTimeToSystemTime(ft)
    Dim s As String
    s = SystemTimeDateTime.SYSTEMTIMEAsISO8601(sysTime)
    If kind = UtcKind Then
        s = s & "Z"
    End If
    FormatFileTimeAsISO8601 = s
End Function
