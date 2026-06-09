VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "OleDates"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' OleDates is the home for OLE Automation Date (the VB6 Date type)
' conversions. It is a Global + Predeclared class, so calls look like
' OleDates.OleEpoch / OleDates.FormatAsISO8601(d) / OleDates.ToFileTimeDecimal(d)
' without needing to instantiate the class.
'
' The two FileTimeDecimal conversion methods (ToFileTimeDecimal /
' FromFileTimeDecimal) compose the thin Win32 wrappers in
' FileTimeDateTimes.bas: ConvertOleDateToSystemTime +
' ConvertSystemTimeToFileTime + ConvertFileTimeToDecimal (and the
' reverse). They bypass the circular dependency in the Composed
' Convert* functions and avoid the overhead of creating an intermediate
' FileTimeDateTime instance.
'
' The two timezone conversion methods (ToLocalFromUtc / ToUtcFromLocal)
' additionally route through ConvertFileTimeToLocalFileTime and
' ConvertLocalFileTimeToFileTime to perform the actual timezone shift
' via the Win32 kernel32 APIs.
'
' The "FileTimeDecimal" name clarifies that the Decimal value being
' passed / returned is a FILETIME tick count (100-ns intervals since
' 1601-01-01), not any other kind of Decimal.

Public Property Get OleEpoch() As Date
Attribute OleEpoch.VB_Description = "The OLE Automation epoch, midnight of 30 December 1899 (Date = 0#). This is the literal zero point of the OLE Date type by definition.\r\n\r\nReturns:\r\n  Date: The OLE epoch."
    OleEpoch = 0#
End Property

Public Property Get NtEpoch() As Date
Attribute NtEpoch.VB_Description = "The Windows NT / FILETIME epoch as an OLE Automation Date: 1601-01-01 00:00:00 UTC.\r\n\r\nOLE Date constant -109205.0 (1899-12-30 minus 109,205 days = 1601-01-01). Verified via Python: date(1601,1,1) - date(1899,12,30) = -109205 days.\r\n\r\nReturns:\r\n  Date: The NT epoch as an OLE Date."
    NtEpoch = -109205#
End Property

Public Property Get UnixEpoch() As Date
Attribute UnixEpoch.VB_Description = "The Unix epoch as an OLE Automation Date: 1970-01-01 00:00:00 UTC.\r\n\r\nOLE Date constant 25569.0 (1899-12-30 plus 25,569 days = 1970-01-01). Verified via Python: date(1970,1,1) - date(1899,12,30) = 25569 days.\r\n\r\nReturns:\r\n  Date: The Unix epoch as an OLE Date."
    UnixEpoch = 25569#
End Property

Public Function FormatAsISO8601(ByRef d As Date) As String
Attribute FormatAsISO8601.VB_Description = "Formats an OLE Automation Date as an ISO 8601 string (yyyy-mm-ddThh:nn:ss).\r\n\r\nArgs:\r\n  d (Date): The date to format.\r\nReturns:\r\n  String: The ISO 8601 representation."
    FormatAsISO8601 = Format$(d, "yyyy-mm-ddThh:nn:ss")
End Function

Public Function ToFileTimeDecimal(ByVal oleDate As Date) As Variant
Attribute ToFileTimeDecimal.VB_Description = "Converts an OLE Automation Date to a Decimal FILETIME tick count (a FileTimeDecimal).\r\n\r\nRaises:\r\n  Overflow (Long): when any Win32 conversion in the chain fails\r\nArgs:\r\n  oleDate (Date): The OLE Date to convert.\r\nReturns:\r\n  Variant: The Decimal tick count (100-ns intervals since 1601-01-01)."
    ToFileTimeDecimal = FileTimeDateTimes.ConvertFileTimeToDecimal( _
        FileTimeDateTimes.ConvertSystemTimeToFileTime( _
            FileTimeDateTimes.ConvertOleDateToSystemTime(oleDate)))
End Function

Public Function FromFileTimeDecimal(ByVal fileTimeDecimal As Variant) As Date
Attribute FromFileTimeDecimal.VB_Description = "Converts a Decimal FILETIME tick count (a FileTimeDecimal) to an OLE Automation Date.\r\n\r\nRaises:\r\n  Overflow (Long): when any Win32 conversion in the chain fails\r\nArgs:\r\n  fileTimeDecimal (Variant): The FILETIME tick count (100-ns intervals since 1601-01-01).\r\nReturns:\r\n  Date: The corresponding OLE Date."
    FromFileTimeDecimal = FileTimeDateTimes.ConvertSystemTimeToOleDate( _
        FileTimeDateTimes.ConvertFileTimeToSystemTime( _
            FileTimeDateTimes.ConvertDecimalToFileTime(fileTimeDecimal)))
End Function

Public Function ToLocalFromUtc(ByVal utcOleDate As Date) As Date
Attribute ToLocalFromUtc.VB_Description = "Converts a UTC OLE Automation Date to a local OLE Automation Date.\r\n\r\nRaises:\r\n  Overflow (Long): when any Win32 conversion in the chain fails\r\nArgs:\r\n  utcOleDate (Date): The UTC OLE Date to convert.\r\nReturns:\r\n  Date: The corresponding local OLE Date."
    Dim sysTime_utc As SYSTEMTIME
    Dim ft_utc As FILETIME
    Dim ft_local As FILETIME
    Dim sysTime_local As SYSTEMTIME
    sysTime_utc = FileTimeDateTimes.ConvertOleDateToSystemTime(utcOleDate)
    ft_utc = FileTimeDateTimes.ConvertSystemTimeToFileTime(sysTime_utc)
    ft_local = FileTimeDateTimes.ConvertFileTimeToLocalFileTime(ft_utc)
    sysTime_local = FileTimeDateTimes.ConvertFileTimeToSystemTime(ft_local)
    ToLocalFromUtc = FileTimeDateTimes.ConvertSystemTimeToOleDate(sysTime_local)
End Function

Public Function ToUtcFromLocal(ByVal localOleDate As Date) As Date
Attribute ToUtcFromLocal.VB_Description = "Converts a local OLE Automation Date to a UTC OLE Automation Date.\r\n\r\nRaises:\r\n  Overflow (Long): when any Win32 conversion in the chain fails\r\nArgs:\r\n  localOleDate (Date): The local OLE Date to convert.\r\nReturns:\r\n  Date: The corresponding UTC OLE Date."
    Dim sysTime_local As SYSTEMTIME
    Dim ft_local As FILETIME
    Dim ft_utc As FILETIME
    Dim sysTime_utc As SYSTEMTIME
    sysTime_local = FileTimeDateTimes.ConvertOleDateToSystemTime(localOleDate)
    ft_local = FileTimeDateTimes.ConvertSystemTimeToFileTime(sysTime_local)
    ft_utc = FileTimeDateTimes.ConvertLocalFileTimeToFileTime(ft_local)
    sysTime_utc = FileTimeDateTimes.ConvertFileTimeToSystemTime(ft_utc)
    ToUtcFromLocal = FileTimeDateTimes.ConvertSystemTimeToOleDate(sysTime_utc)
End Function
