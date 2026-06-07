VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTimeSpanFactory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' CTimeSpanFactory is the OOP factory class for CTimeSpan. It is an
' instance class (NOT predeclared or singleton), following the
' FileTimeDateTimeFactory pattern. Callers should use:
'   Dim factory As New CTimeSpanFactory
'   Set ts = factory.FromTicks(42)
'
' Provides 3 cached singletons (Zero, MaxValue, MinValue) plus 11 OOP
' factory methods that mirror CTimeSpans.TimeSpanFromXxx but return
' CTimeSpan instances. Construction goes through CTimeSpans (and its
' CTimeSpan Init) so the factory-controlled invariant is preserved.

' Cached immutable singletons. CTimeSpan is logically immutable, so we
' instantiate each value on first access and reuse the same instance
' for every subsequent call. Callers must not invoke Init on the cached
' instances (the Init method is Friend so this is enforceable at the
' project boundary).
Private m_zero As CTimeSpan
Private m_maxValue As CTimeSpan
Private m_minValue As CTimeSpan

' Zero returns a CTimeSpan whose duration is zero ticks. Cached as a
' singleton: the same instance is returned on every call.
Public Function Zero() As CTimeSpan
Attribute Zero.VB_Description = "Returns a CTimeSpan whose duration is zero ticks.\r\nCached as a singleton: the same instance is returned on every call.\r\nReturns:\r\n  CTimeSpan: The shared zero-tick instance."
    If m_zero Is Nothing Then Set m_zero = New CTimeSpan
    Set Zero = m_zero
End Function

' MaxValue returns a CTimeSpan with Int64.MaxValue ticks
' (9223372036854775807, ~10675199.116 days). Cached as a singleton.
Public Function MaxValue() As CTimeSpan
Attribute MaxValue.VB_Description = "Returns a CTimeSpan with Int64.MaxValue ticks (9223372036854775807, ~10675199.116 days).\r\nCached as a singleton: the same instance is returned on every call.\r\nReturns:\r\n  CTimeSpan: The shared MaxValue instance."
    If m_maxValue Is Nothing Then
        Dim udt As TimeSpan
        udt.Ticks = CDec(MAX_TICKS_STR)
        Set m_maxValue = CTimeSpans.WrapTimeSpan(udt)
    End If
    Set MaxValue = m_maxValue
End Function

' MinValue returns a CTimeSpan with Int64.MinValue ticks
' (-9223372036854775808). Cached as a singleton.
Public Function MinValue() As CTimeSpan
Attribute MinValue.VB_Description = "Returns a CTimeSpan with Int64.MinValue ticks (-9223372036854775808).\r\nCached as a singleton: the same instance is returned on every call.\r\nReturns:\r\n  CTimeSpan: The shared MinValue instance."
    If m_minValue Is Nothing Then
        Dim udt As TimeSpan
        udt.Ticks = CDec(MIN_TICKS_STR)
        Set m_minValue = CTimeSpans.WrapTimeSpan(udt)
    End If
    Set MinValue = m_minValue
End Function

' FromTicks returns a CTimeSpan holding exactly the supplied tick count.
' Raises Overflow on out-of-range.
Public Function FromTicks(ByVal ticks As Variant) As CTimeSpan
Attribute FromTicks.VB_Description = "Returns a CTimeSpan holding exactly the supplied tick count.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  ticks (Variant): The exact tick count.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan wrapping the supplied ticks."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromTicks(ticks)
    Set FromTicks = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromMillis returns a CTimeSpan representing the given number of
' milliseconds. Raises Overflow on out-of-range.
Public Function FromMillis(ByVal millis As Double) As CTimeSpan
Attribute FromMillis.VB_Description = "Returns a CTimeSpan representing the given number of milliseconds.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  millis (Double): The number of milliseconds.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromMillis(millis)
    Set FromMillis = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromMicros returns a CTimeSpan representing the given number of
' microseconds. Raises Overflow on out-of-range.
Public Function FromMicros(ByVal micros As Double) As CTimeSpan
Attribute FromMicros.VB_Description = "Returns a CTimeSpan representing the given number of microseconds.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  micros (Double): The number of microseconds.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromMicros(micros)
    Set FromMicros = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromSeconds returns a CTimeSpan representing the given number of
' seconds. Raises Overflow on out-of-range.
Public Function FromSeconds(ByVal seconds As Double) As CTimeSpan
Attribute FromSeconds.VB_Description = "Returns a CTimeSpan representing the given number of seconds.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  seconds (Double): The number of seconds.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromSeconds(seconds)
    Set FromSeconds = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromMinutes returns a CTimeSpan representing the given number of
' minutes. Raises Overflow on out-of-range.
Public Function FromMinutes(ByVal minutes As Double) As CTimeSpan
Attribute FromMinutes.VB_Description = "Returns a CTimeSpan representing the given number of minutes.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  minutes (Double): The number of minutes.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromMinutes(minutes)
    Set FromMinutes = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromHours returns a CTimeSpan representing the given number of hours.
' Raises Overflow on out-of-range.
Public Function FromHours(ByVal hours As Double) As CTimeSpan
Attribute FromHours.VB_Description = "Returns a CTimeSpan representing the given number of hours.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  hours (Double): The number of hours.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromHours(hours)
    Set FromHours = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromDays returns a CTimeSpan representing the given number of days.
' Raises Overflow on out-of-range.
Public Function FromDays(ByVal days As Double) As CTimeSpan
Attribute FromDays.VB_Description = "Returns a CTimeSpan representing the given number of days.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  days (Double): The number of days.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromDays(days)
    Set FromDays = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromHoursMinutesSeconds constructs a CTimeSpan from h:m:s. Raises
' Overflow on out-of-range.
Public Function FromHoursMinutesSeconds(ByVal h As Long, ByVal m As Long, ByVal s As Long) As CTimeSpan
Attribute FromHoursMinutesSeconds.VB_Description = "Returns a CTimeSpan constructed from h:m:s.\r\nAll inputs can be negative. h must fit in [0, 23] when all inputs are non-negative.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromHoursMinutesSeconds(h, m, s)
    Set FromHoursMinutesSeconds = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromDaysHoursMinutesSeconds constructs a CTimeSpan from d:h:m:s.
' Raises Overflow on out-of-range.
Public Function FromDaysHoursMinutesSeconds(ByVal d As Long, ByVal h As Long, ByVal m As Long, ByVal s As Long) As CTimeSpan
Attribute FromDaysHoursMinutesSeconds.VB_Description = "Returns a CTimeSpan constructed from d:h:m:s.\r\nAll inputs can be negative. d must fit in [0, 10675199] when all inputs are non-negative. h must fit in [0, 23], m in [0, 59], s in [0, 59].\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  d (Long): Days.\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromDaysHoursMinutesSeconds(d, h, m, s)
    Set FromDaysHoursMinutesSeconds = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromDaysHoursMinutesSecondsMillis adds a milliseconds component.
' Raises Overflow on out-of-range.
Public Function FromDaysHoursMinutesSecondsMillis(ByVal d As Long, ByVal h As Long, ByVal m As Long, ByVal s As Long, ByVal millis As Long) As CTimeSpan
Attribute FromDaysHoursMinutesSecondsMillis.VB_Description = "Returns a CTimeSpan constructed from d:h:m:s plus a milliseconds component.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  d (Long): Days.\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\n  millis (Long): Milliseconds.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromDaysHoursMinutesSecondsMillis(d, h, m, s, millis)
    Set FromDaysHoursMinutesSecondsMillis = CTimeSpans.WrapTimeSpan(resultUdt)
End Function

' FromDaysHoursMinutesSecondsMillisMicros adds both a milliseconds and a
' microseconds component. The most precise factory offered. Raises
' Overflow on out-of-range.
Public Function FromDaysHoursMinutesSecondsMillisMicros(ByVal d As Long, ByVal h As Long, ByVal m As Long, ByVal s As Long, ByVal millis As Long, ByVal micros As Long) As CTimeSpan
Attribute FromDaysHoursMinutesSecondsMillisMicros.VB_Description = "Returns a CTimeSpan constructed from d:h:m:s plus milliseconds and microseconds.\r\nThe most precise factory offered.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  d (Long): Days.\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\n  millis (Long): Milliseconds.\r\n  micros (Long): Microseconds.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan representing the duration."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanFromDaysHoursMinutesSecondsMillisMicros(d, h, m, s, millis, micros)
    Set FromDaysHoursMinutesSecondsMillisMicros = CTimeSpans.WrapTimeSpan(resultUdt)
End Function
