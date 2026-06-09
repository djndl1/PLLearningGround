VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTimeSpans"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' CTimeSpans provides the procedural API for TimeSpan plus the shared
' private logic that backs both the CTimeSpan OOP wrapper and the
' CTimeSpanFactory OOP factory.
'
' Two parallel surfaces are exposed:
'   1. The UDT `TimeSpan` (a single Variant Ticks field) for value-style
'      use - cheaper than the CTimeSpan object when no methods are needed.
'      The UDT and the Int64 tick bounds (MAX_TICKS_STR / MIN_TICKS_STR)
'      live in TimeSpanValues.bas - Public Type and Public Const are not
'      allowed in class modules (object modules) under VB6.
'   2. The WrapTimeSpan / UnwrapTimeSpan conversions to bridge the UDT
'      and the CTimeSpan object reference.
'
' The OOP equivalents of the TimeSpanFromXxx factories, plus the cached
' Zero / MaxValue / MinValue singletons, live on CTimeSpanFactory.

' Cached Decimal unit constants. VB6 has no Const As Decimal syntax,
' and four of these values (TicksPerHour, TicksPerDay,
' MicrosecondsPerHour, MicrosecondsPerDay) exceed Long.MaxValue
' (~2.15e9) so they cannot be Const As Long. The cache pattern is:
'   1. Declare a Private m_X As Variant per constant.
'   2. Initialize once in Class_Initialize using CDec("...") on a
'      string literal. CDec on a string parses the digits verbatim
'      into a Decimal Variant, bypassing Long/Double literal type
'      inference that would otherwise overflow or promote lossy to
'      Double.
'   3. Expose via Public Property Get that returns the cached value.
' Each value mirrors a Public Const Long from System.TimeSpan in
' the .NET reference source.

' Cache fields populated by Class_Initialize. m_ prefix matches the
' project convention; see FileTimeDateTime.cls m_ftimestamp for the
' parallel naming style.
Private m_nanosecondsPerTick As Variant
Private m_ticksPerMicrosecond As Variant
Private m_ticksPerMillisecond As Variant
Private m_ticksPerSecond As Variant
Private m_ticksPerMinute As Variant
Private m_ticksPerHour As Variant
Private m_ticksPerDay As Variant
Private m_microsecondsPerMillisecond As Variant
Private m_microsecondsPerSecond As Variant
Private m_microsecondsPerMinute As Variant
Private m_microsecondsPerHour As Variant
Private m_microsecondsPerDay As Variant
Private m_millisecondsPerSecond As Variant
Private m_millisecondsPerMinute As Variant
Private m_millisecondsPerHour As Variant
Private m_millisecondsPerDay As Variant
Private m_secondsPerMinute As Variant
Private m_secondsPerHour As Variant
Private m_secondsPerDay As Variant
Private m_minutesPerHour As Variant
Private m_minutesPerDay As Variant
Private m_hoursPerDay As Variant

Private Sub Class_Initialize()
    m_nanosecondsPerTick = CDec("100")
    m_ticksPerMicrosecond = CDec("10")
    m_ticksPerMillisecond = CDec("10000")
    m_ticksPerSecond = CDec("10000000")
    m_ticksPerMinute = CDec("600000000")
    m_ticksPerHour = CDec("36000000000")
    m_ticksPerDay = CDec("864000000000")
    m_microsecondsPerMillisecond = CDec("1000")
    m_microsecondsPerSecond = CDec("1000000")
    m_microsecondsPerMinute = CDec("60000000")
    m_microsecondsPerHour = CDec("3600000000")
    m_microsecondsPerDay = CDec("86400000000")
    m_millisecondsPerSecond = CDec("1000")
    m_millisecondsPerMinute = CDec("60000")
    m_millisecondsPerHour = CDec("3600000")
    m_millisecondsPerDay = CDec("86400")
    m_secondsPerMinute = CDec("60")
    m_secondsPerHour = CDec("3600")
    m_secondsPerDay = CDec("86400")
    m_minutesPerHour = CDec("60")
    m_minutesPerDay = CDec("1440")
    m_hoursPerDay = CDec("24")
End Sub

' Nanosecond scale.
Public Property Get NanosecondsPerTick() As Variant
Attribute NanosecondsPerTick.VB_Description = "Number of nanoseconds in a single tick (100)."
    NanosecondsPerTick = m_nanosecondsPerTick
End Property

Public Property Get TicksPerMicrosecond() As Variant
Attribute TicksPerMicrosecond.VB_Description = "Number of ticks in a microsecond (10)."
    TicksPerMicrosecond = m_ticksPerMicrosecond
End Property

Public Property Get TicksPerMillisecond() As Variant
Attribute TicksPerMillisecond.VB_Description = "Number of ticks in a millisecond (10,000)."
    TicksPerMillisecond = m_ticksPerMillisecond
End Property

Public Property Get TicksPerSecond() As Variant
Attribute TicksPerSecond.VB_Description = "Number of ticks in a second (10,000,000)."
    TicksPerSecond = m_ticksPerSecond
End Property

Public Property Get TicksPerMinute() As Variant
Attribute TicksPerMinute.VB_Description = "Number of ticks in a minute (600,000,000)."
    TicksPerMinute = m_ticksPerMinute
End Property

Public Property Get TicksPerHour() As Variant
Attribute TicksPerHour.VB_Description = "Number of ticks in an hour (36,000,000,000)."
    TicksPerHour = m_ticksPerHour
End Property

Public Property Get TicksPerDay() As Variant
Attribute TicksPerDay.VB_Description = "Number of ticks in a day (864,000,000,000)."
    TicksPerDay = m_ticksPerDay
End Property

' Microsecond scale.
Public Property Get MicrosecondsPerMillisecond() As Variant
Attribute MicrosecondsPerMillisecond.VB_Description = "Number of microseconds in a millisecond (1,000)."
    MicrosecondsPerMillisecond = m_microsecondsPerMillisecond
End Property

Public Property Get MicrosecondsPerSecond() As Variant
Attribute MicrosecondsPerSecond.VB_Description = "Number of microseconds in a second (1,000,000)."
    MicrosecondsPerSecond = m_microsecondsPerSecond
End Property

Public Property Get MicrosecondsPerMinute() As Variant
Attribute MicrosecondsPerMinute.VB_Description = "Number of microseconds in a minute (60,000,000)."
    MicrosecondsPerMinute = m_microsecondsPerMinute
End Property

Public Property Get MicrosecondsPerHour() As Variant
Attribute MicrosecondsPerHour.VB_Description = "Number of microseconds in an hour (3,600,000,000)."
    MicrosecondsPerHour = m_microsecondsPerHour
End Property

Public Property Get MicrosecondsPerDay() As Variant
Attribute MicrosecondsPerDay.VB_Description = "Number of microseconds in a day (86,400,000,000)."
    MicrosecondsPerDay = m_microsecondsPerDay
End Property

' Millisecond scale.
Public Property Get MillisecondsPerSecond() As Variant
Attribute MillisecondsPerSecond.VB_Description = "Number of milliseconds in a second (1,000)."
    MillisecondsPerSecond = m_millisecondsPerSecond
End Property

Public Property Get MillisecondsPerMinute() As Variant
Attribute MillisecondsPerMinute.VB_Description = "Number of milliseconds in a minute (60,000)."
    MillisecondsPerMinute = m_millisecondsPerMinute
End Property

Public Property Get MillisecondsPerHour() As Variant
Attribute MillisecondsPerHour.VB_Description = "Number of milliseconds in an hour (3,600,000)."
    MillisecondsPerHour = m_millisecondsPerHour
End Property

Public Property Get MillisecondsPerDay() As Variant
Attribute MillisecondsPerDay.VB_Description = "Number of milliseconds in a day (86,400,000)."
    MillisecondsPerDay = m_millisecondsPerDay
End Property

' Second scale.
Public Property Get SecondsPerMinute() As Variant
Attribute SecondsPerMinute.VB_Description = "Number of seconds in a minute (60)."
    SecondsPerMinute = m_secondsPerMinute
End Property

Public Property Get SecondsPerHour() As Variant
Attribute SecondsPerHour.VB_Description = "Number of seconds in an hour (3,600)."
    SecondsPerHour = m_secondsPerHour
End Property

Public Property Get SecondsPerDay() As Variant
Attribute SecondsPerDay.VB_Description = "Number of seconds in a day (86,400)."
    SecondsPerDay = m_secondsPerDay
End Property

' Minute and hour scale.
Public Property Get MinutesPerHour() As Variant
Attribute MinutesPerHour.VB_Description = "Number of minutes in an hour (60)."
    MinutesPerHour = m_minutesPerHour
End Property

Public Property Get MinutesPerDay() As Variant
Attribute MinutesPerDay.VB_Description = "Number of minutes in a day (1,440)."
    MinutesPerDay = m_minutesPerDay
End Property

Public Property Get HoursPerDay() As Variant
Attribute HoursPerDay.VB_Description = "Number of hours in a day (24)."
    HoursPerDay = m_hoursPerDay
End Property

' TimeSpanFromTicks returns a UDT TimeSpan holding exactly the supplied
' tick count. Raises Overflow on out-of-range.
Public Function TimeSpanFromTicks(ByVal ticks As Variant) As TimeSpan
Attribute TimeSpanFromTicks.VB_Description = "Returns a UDT TimeSpan holding exactly the supplied tick count.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  ticks (Variant): The exact tick count.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Ensure.IsTrue InTickRange(CDec(ticks)), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromTicks", "ticks out of range"
    Dim result As TimeSpan
    result.ticks = CDec(ticks)
    TimeSpanFromTicks = result
End Function

' TimeSpanFromMillis returns a UDT TimeSpan representing the given number
' of milliseconds. Raises Overflow on out-of-range.
Public Function TimeSpanFromMillis(ByVal millis As Double) As TimeSpan
Attribute TimeSpanFromMillis.VB_Description = "Returns a UDT TimeSpan representing the given number of milliseconds.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  millis (Double): The number of milliseconds.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = CDec(millis) * CDec(CTimeSpans.TicksPerMillisecond)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromMillis", "millis out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromMillis = result
End Function

' TimeSpanFromMicros returns a UDT TimeSpan representing the given number
' of microseconds. Raises Overflow on out-of-range.
Public Function TimeSpanFromMicros(ByVal micros As Double) As TimeSpan
Attribute TimeSpanFromMicros.VB_Description = "Returns a UDT TimeSpan representing the given number of microseconds.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  micros (Double): The number of microseconds.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = CDec(micros) * CDec(CTimeSpans.TicksPerMicrosecond)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromMicros", "micros out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromMicros = result
End Function

' TimeSpanFromSeconds returns a UDT TimeSpan representing the given number
' of seconds. Raises Overflow on out-of-range.
Public Function TimeSpanFromSeconds(ByVal seconds As Double) As TimeSpan
Attribute TimeSpanFromSeconds.VB_Description = "Returns a UDT TimeSpan representing the given number of seconds.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  seconds (Double): The number of seconds.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = CDec(seconds) * CDec(CTimeSpans.TicksPerSecond)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromSeconds", "seconds out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromSeconds = result
End Function

' TimeSpanFromMinutes returns a UDT TimeSpan representing the given number
' of minutes. Raises Overflow on out-of-range.
Public Function TimeSpanFromMinutes(ByVal minutes As Double) As TimeSpan
Attribute TimeSpanFromMinutes.VB_Description = "Returns a UDT TimeSpan representing the given number of minutes.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  minutes (Double): The number of minutes.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = CDec(minutes) * CDec(CTimeSpans.TicksPerMinute)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromMinutes", "minutes out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromMinutes = result
End Function

' TimeSpanFromHours returns a UDT TimeSpan representing the given number
' of hours. Raises Overflow on out-of-range.
Public Function TimeSpanFromHours(ByVal hours As Double) As TimeSpan
Attribute TimeSpanFromHours.VB_Description = "Returns a UDT TimeSpan representing the given number of hours.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  hours (Double): The number of hours.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = CDec(hours) * CDec(CTimeSpans.TicksPerHour)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromHours", "hours out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromHours = result
End Function

' TimeSpanFromDays returns a UDT TimeSpan representing the given number
' of days. Raises Overflow on out-of-range.
Public Function TimeSpanFromDays(ByVal days As Double) As TimeSpan
Attribute TimeSpanFromDays.VB_Description = "Returns a UDT TimeSpan representing the given number of days.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  days (Double): The number of days.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = CDec(days) * CDec(CTimeSpans.TicksPerDay)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromDays", "days out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromDays = result
End Function

' TimeSpanFromHoursMinutesSeconds constructs a UDT TimeSpan from h:m:s.
' All inputs can be negative. h must fit in [0, 23] when all inputs are
' non-negative. Raises Overflow on out-of-range.
Public Function TimeSpanFromHoursMinutesSeconds(ByVal h As Long, ByVal m As Long, ByVal s As Long) As TimeSpan
Attribute TimeSpanFromHoursMinutesSeconds.VB_Description = "Returns a UDT TimeSpan constructed from h:m:s.\r\nAll inputs can be negative. h must fit in [0, 23] when all inputs are non-negative.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = TimeToTicks(0, h, m, s)
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromHoursMinutesSeconds = result
End Function

' TimeSpanFromDaysHoursMinutesSeconds constructs a UDT TimeSpan from
' d:h:m:s. All inputs can be negative. d must fit in [0, 10675199] when
' all inputs are non-negative. h must fit in [0, 23], m in [0, 59],
' s in [0, 59]. Raises Overflow on out-of-range.
Public Function TimeSpanFromDaysHoursMinutesSeconds(ByVal d As Long, ByVal h As Long, ByVal m As Long, ByVal s As Long) As TimeSpan
Attribute TimeSpanFromDaysHoursMinutesSeconds.VB_Description = "Returns a UDT TimeSpan constructed from d:h:m:s.\r\nAll inputs can be negative. d must fit in [0, 10675199] when all inputs are non-negative. h must fit in [0, 23], m in [0, 59], s in [0, 59].\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  d (Long): Days.\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = TimeToTicks(d, h, m, s)
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromDaysHoursMinutesSeconds = result
End Function

' TimeSpanFromDaysHoursMinutesSecondsMillis adds a milliseconds component.
' Raises Overflow on out-of-range.
Public Function TimeSpanFromDaysHoursMinutesSecondsMillis(ByVal d As Long, ByVal h As Long, ByVal m As Long, ByVal s As Long, ByVal millis As Long) As TimeSpan
Attribute TimeSpanFromDaysHoursMinutesSecondsMillis.VB_Description = "Returns a UDT TimeSpan constructed from d:h:m:s plus a milliseconds component.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  d (Long): Days.\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\n  millis (Long): Milliseconds.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = TimeToTicks(d, h, m, s) + CDec(millis) * CDec(CTimeSpans.TicksPerMillisecond)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromDaysHoursMinutesSecondsMillis", "resulting ticks out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromDaysHoursMinutesSecondsMillis = result
End Function

' TimeSpanFromDaysHoursMinutesSecondsMillisMicros adds both a milliseconds
' and a microseconds component. The most precise factory offered.
' Raises Overflow on out-of-range.
Public Function TimeSpanFromDaysHoursMinutesSecondsMillisMicros(ByVal d As Long, ByVal h As Long, ByVal m As Long, ByVal s As Long, ByVal millis As Long, ByVal micros As Long) As TimeSpan
Attribute TimeSpanFromDaysHoursMinutesSecondsMillisMicros.VB_Description = "Returns a UDT TimeSpan constructed from d:h:m:s plus milliseconds and microseconds.\r\nThe most precise factory offered.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  d (Long): Days.\r\n  h (Long): Hours.\r\n  m (Long): Minutes.\r\n  s (Long): Seconds.\r\n  millis (Long): Milliseconds.\r\n  micros (Long): Microseconds.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ticks = TimeToTicks(d, h, m, s) _
        + CDec(millis) * CDec(CTimeSpans.TicksPerMillisecond) _
        + CDec(micros) * CDec(CTimeSpans.TicksPerMicrosecond)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeSpanFromDaysHoursMinutesSecondsMillisMicros", "resulting ticks out of range"
    Dim result As TimeSpan
    result.ticks = ticks
    TimeSpanFromDaysHoursMinutesSecondsMillisMicros = result
End Function

' TimeSpanAdd returns a new TimeSpan whose ticks are a + b. Raises
' Overflow on out-of-range.
Public Function TimeSpanAdd(ByRef a As TimeSpan, ByRef b As TimeSpan) As TimeSpan
Attribute TimeSpanAdd.VB_Description = "Returns a new TimeSpan whose ticks are a + b.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  TimeSpan: a + b."
    Dim result As TimeSpan
    result.ticks = CheckedAdd(CDec(a.ticks), CDec(b.ticks))
    TimeSpanAdd = result
End Function

' TimeSpanSubtract returns a new TimeSpan whose ticks are a - b. Raises
' Overflow on out-of-range.
Public Function TimeSpanSubtract(ByRef a As TimeSpan, ByRef b As TimeSpan) As TimeSpan
Attribute TimeSpanSubtract.VB_Description = "Returns a new TimeSpan whose ticks are a - b.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  TimeSpan: a - b."
    Dim result As TimeSpan
    result.ticks = CheckedSubtract(CDec(a.ticks), CDec(b.ticks))
    TimeSpanSubtract = result
End Function

' TimeSpanNegate returns a new TimeSpan with the sign of the duration
' inverted. Negating MinValue overflows (no positive equivalent) ->
' Overflow.
Public Function TimeSpanNegate(ByRef a As TimeSpan) As TimeSpan
Attribute TimeSpanNegate.VB_Description = "Returns a new TimeSpan with the sign of a inverted.\r\nNegating MinValue raises Overflow (no positive equivalent).\r\nArgs:\r\n  a (TimeSpan): Operand.\r\nReturns:\r\n  TimeSpan: -a."
    Dim result As TimeSpan
    result.ticks = CheckedNegate(CDec(a.ticks))
    TimeSpanNegate = result
End Function

' TimeSpanDuration returns the absolute value of a as a new TimeSpan.
' The largest negative value cannot be negated without overflow ->
' Overflow.
Public Function TimeSpanDuration(ByRef a As TimeSpan) As TimeSpan
Attribute TimeSpanDuration.VB_Description = "Returns the absolute value of a as a new TimeSpan.\r\nThe largest negative value raises Overflow.\r\nArgs:\r\n  a (TimeSpan): Operand.\r\nReturns:\r\n  TimeSpan: |a|."
    Dim result As TimeSpan
    If CDec(a.ticks) < CDec(0) Then
        result.ticks = CheckedNegate(CDec(a.ticks))
    Else
        result.ticks = CDec(a.ticks)
    End If
    TimeSpanDuration = result
End Function

' TimeSpanMultiply returns a new TimeSpan scaled by factor. factor can
' be negative. Raises Overflow when the product leaves the tick range.
Public Function TimeSpanMultiply(ByRef a As TimeSpan, ByVal factor As Double) As TimeSpan
Attribute TimeSpanMultiply.VB_Description = "Returns a new TimeSpan scaled by factor.\r\nfactor can be negative. Raises Overflow on out-of-range.\r\nArgs:\r\n  a (TimeSpan): Operand.\r\n  factor (Double): Scale factor.\r\nReturns:\r\n  TimeSpan: a * factor."
    Dim result As TimeSpan
    result.ticks = CheckedMultiply(CDec(a.ticks), CDec(factor))
    TimeSpanMultiply = result
End Function

' TimeSpanDivide returns a new TimeSpan whose ticks are a / divisor.
' divisor = 0 raises Overflow (mirroring the .NET Overflow path).
' Raises Overflow when the result leaves the tick range.
Public Function TimeSpanDivide(ByRef a As TimeSpan, ByVal divisor As Double) As TimeSpan
Attribute TimeSpanDivide.VB_Description = "Returns a new TimeSpan whose ticks are a / divisor.\r\ndivisor = 0 raises Overflow; result out of range also raises Overflow.\r\nArgs:\r\n  a (TimeSpan): Numerator.\r\n  divisor (Double): Divisor.\r\nReturns:\r\n  TimeSpan: a / divisor."
    Dim result As TimeSpan
    result.ticks = CheckedDivide(CDec(a.ticks), CDec(divisor))
    TimeSpanDivide = result
End Function

' TimeSpanDivideBy returns a / b as a Double ratio. b.Ticks = 0 raises
' Overflow.
Public Function TimeSpanDivideBy(ByRef a As TimeSpan, ByRef b As TimeSpan) As Double
Attribute TimeSpanDivideBy.VB_Description = "Returns a / b as a Double ratio.\r\nb.Ticks = 0 raises Overflow.\r\nArgs:\r\n  a (TimeSpan): Numerator.\r\n  b (TimeSpan): Denominator.\r\nReturns:\r\n  Double: a.Ticks / b.Ticks."
    Ensure.NotEqual b.ticks, CDec(0), ErrorCodes.Overflow, "CTimeSpans.TimeSpanDivideBy", "divisor ticks cannot be zero"
    TimeSpanDivideBy = CDbl(a.ticks) / CDbl(b.ticks)
End Function

' TimeSpanEquals returns True when a and b hold the same tick count.
Public Function TimeSpanEquals(ByRef a As TimeSpan, ByRef b As TimeSpan) As Boolean
Attribute TimeSpanEquals.VB_Description = "Returns True when a and b hold the same tick count.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when a.Ticks = b.Ticks."
    TimeSpanEquals = (CDec(a.ticks) = CDec(b.ticks))
End Function

' TimeSpanNotEquals returns True when a and b hold different tick counts.
Public Function TimeSpanNotEquals(ByRef a As TimeSpan, ByRef b As TimeSpan) As Boolean
Attribute TimeSpanNotEquals.VB_Description = "Returns True when a and b hold different tick counts.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when a.Ticks <> b.Ticks."
    TimeSpanNotEquals = (CDec(a.ticks) <> CDec(b.ticks))
End Function

' TimeSpanIsLessThan returns True when a is strictly less than b.
Public Function TimeSpanIsLessThan(ByRef a As TimeSpan, ByRef b As TimeSpan) As Boolean
Attribute TimeSpanIsLessThan.VB_Description = "Returns True when a is strictly less than b.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when a.Ticks < b.Ticks."
    TimeSpanIsLessThan = (CDec(a.ticks) < CDec(b.ticks))
End Function

' TimeSpanIsLessThanOrEqualTo returns True when a is less than or equal
' to b.
Public Function TimeSpanIsLessThanOrEqualTo(ByRef a As TimeSpan, ByRef b As TimeSpan) As Boolean
Attribute TimeSpanIsLessThanOrEqualTo.VB_Description = "Returns True when a is less than or equal to b.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when a.Ticks <= b.Ticks."
    TimeSpanIsLessThanOrEqualTo = (CDec(a.ticks) <= CDec(b.ticks))
End Function

' TimeSpanIsGreaterThan returns True when a is strictly greater than b.
Public Function TimeSpanIsGreaterThan(ByRef a As TimeSpan, ByRef b As TimeSpan) As Boolean
Attribute TimeSpanIsGreaterThan.VB_Description = "Returns True when a is strictly greater than b.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when a.Ticks > b.Ticks."
    TimeSpanIsGreaterThan = (CDec(a.ticks) > CDec(b.ticks))
End Function

' TimeSpanIsGreaterThanOrEqualTo returns True when a is greater than
' or equal to b.
Public Function TimeSpanIsGreaterThanOrEqualTo(ByRef a As TimeSpan, ByRef b As TimeSpan) As Boolean
Attribute TimeSpanIsGreaterThanOrEqualTo.VB_Description = "Returns True when a is greater than or equal to b.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when a.Ticks >= b.Ticks."
    TimeSpanIsGreaterThanOrEqualTo = (CDec(a.ticks) >= CDec(b.ticks))
End Function

' TimeSpanCompareTo returns -1, 0, or +1 following the IComparable
' convention.
Public Function TimeSpanCompareTo(ByRef a As TimeSpan, ByRef b As TimeSpan) As Long
Attribute TimeSpanCompareTo.VB_Description = "Returns -1, 0, or +1 following the IComparable convention.\r\nArgs:\r\n  a (TimeSpan): Left operand.\r\n  b (TimeSpan): Right operand.\r\nReturns:\r\n  Long: -1, 0, or +1 based on the relative magnitude of a.Ticks vs b.Ticks."
    If CDec(a.ticks) < CDec(b.ticks) Then
        TimeSpanCompareTo = -1
    ElseIf CDec(a.ticks) > CDec(b.ticks) Then
        TimeSpanCompareTo = 1
    Else
        TimeSpanCompareTo = 0
    End If
End Function

' TimeSpanTicks returns the underlying 100-nanosecond tick count.
Public Function TimeSpanTicks(ByRef ts As TimeSpan) As Variant
Attribute TimeSpanTicks.VB_Description = "Returns the underlying 100-nanosecond tick count as a Decimal.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Variant: The tick count."
    TimeSpanTicks = ts.ticks
End Function

' TimeSpanDays returns the days component. Carries the sign of the
' overall TimeSpan (e.g. -1.5 days -> -1, matching .NET).
Public Function TimeSpanDays(ByRef ts As TimeSpan) As Long
Attribute TimeSpanDays.VB_Description = "Days component of the duration.\r\nCarries the sign of the overall TimeSpan (e.g. -1.5 days -> -1).\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The days component."
    TimeSpanDays = CLng(Fix(CDec(ts.ticks) / CDec(CTimeSpans.TicksPerDay)))
End Function

' TimeSpanHours returns the hours component [-23, 23] of the day component.
Public Function TimeSpanHours(ByRef ts As TimeSpan) As Long
Attribute TimeSpanHours.VB_Description = "Hours component [-23, 23] of the day component.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The hours component."
    TimeSpanHours = TruncatedComponentTicks(CDec(ts.ticks), CDec(CTimeSpans.TicksPerHour), CDec(CTimeSpans.HoursPerDay))
End Function

' TimeSpanMinutes returns the minutes component [-59, 59] of the hour
' component.
Public Function TimeSpanMinutes(ByRef ts As TimeSpan) As Long
Attribute TimeSpanMinutes.VB_Description = "Minutes component [-59, 59] of the hour component.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The minutes component."
    TimeSpanMinutes = TruncatedComponentTicks(CDec(ts.ticks), CDec(CTimeSpans.TicksPerMinute), CDec(CTimeSpans.MinutesPerHour))
End Function

' TimeSpanSeconds returns the seconds component [-59, 59] of the minute
' component.
Public Function TimeSpanSeconds(ByRef ts As TimeSpan) As Long
Attribute TimeSpanSeconds.VB_Description = "Seconds component [-59, 59] of the minute component.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The seconds component."
    TimeSpanSeconds = TruncatedComponentTicks(CDec(ts.ticks), CDec(CTimeSpans.TicksPerSecond), CDec(CTimeSpans.SecondsPerMinute))
End Function

' TimeSpanMilliseconds returns the milliseconds component [-999, 999] of
' the second component.
Public Function TimeSpanMilliseconds(ByRef ts As TimeSpan) As Long
Attribute TimeSpanMilliseconds.VB_Description = "Milliseconds component [-999, 999] of the second component.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The milliseconds component."
    TimeSpanMilliseconds = TruncatedComponentTicks(CDec(ts.ticks), CDec(CTimeSpans.TicksPerMillisecond), CDec(CTimeSpans.MillisecondsPerSecond))
End Function

' TimeSpanMicroseconds returns the microseconds component [-999, 999] of
' the millisecond component.
Public Function TimeSpanMicroseconds(ByRef ts As TimeSpan) As Long
Attribute TimeSpanMicroseconds.VB_Description = "Microseconds component [-999, 999] of the millisecond component.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The microseconds component."
    TimeSpanMicroseconds = TruncatedComponentTicks(CDec(ts.ticks), CDec(CTimeSpans.TicksPerMicrosecond), CDec(CTimeSpans.MicrosecondsPerMillisecond))
End Function

' TimeSpanNanoseconds returns the nanoseconds component [-900, 900] of
' the microsecond component. (Each microsecond is 10 ticks = 1000ns; the
' sub-microsecond remainder, multiplied by NanosecondsPerTick=100, gives
' the ns portion in steps of 100.)
Public Function TimeSpanNanoseconds(ByRef ts As TimeSpan) As Long
Attribute TimeSpanNanoseconds.VB_Description = "Nanoseconds component [-900, 900] of the microsecond component (in 100ns steps).\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The nanoseconds component."
    TimeSpanNanoseconds = CLng((CDec(ts.ticks) Mod CDec(CTimeSpans.TicksPerMicrosecond)) * CDec(CTimeSpans.NanosecondsPerTick))
End Function

' TimeSpanTotalDays returns the duration expressed in whole and fractional
' days.
Public Function TimeSpanTotalDays(ByRef ts As TimeSpan) As Double
Attribute TimeSpanTotalDays.VB_Description = "Duration expressed in whole and fractional days.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Double: The total days (possibly fractional)."
    TimeSpanTotalDays = CDbl(ts.ticks) / CDbl(CTimeSpans.TicksPerDay)
End Function

' TimeSpanTotalHours returns the duration expressed in whole and fractional
' hours.
Public Function TimeSpanTotalHours(ByRef ts As TimeSpan) As Double
Attribute TimeSpanTotalHours.VB_Description = "Duration expressed in whole and fractional hours.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Double: The total hours (possibly fractional)."
    TimeSpanTotalHours = CDbl(ts.ticks) / CDbl(CTimeSpans.TicksPerHour)
End Function

' TimeSpanTotalMinutes returns the duration expressed in whole and
' fractional minutes.
Public Function TimeSpanTotalMinutes(ByRef ts As TimeSpan) As Double
Attribute TimeSpanTotalMinutes.VB_Description = "Duration expressed in whole and fractional minutes.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Double: The total minutes (possibly fractional)."
    TimeSpanTotalMinutes = CDbl(ts.ticks) / CDbl(CTimeSpans.TicksPerMinute)
End Function

' TimeSpanTotalSeconds returns the duration expressed in whole and
' fractional seconds.
Public Function TimeSpanTotalSeconds(ByRef ts As TimeSpan) As Double
Attribute TimeSpanTotalSeconds.VB_Description = "Duration expressed in whole and fractional seconds.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Double: The total seconds (possibly fractional)."
    TimeSpanTotalSeconds = CDbl(ts.ticks) / CDbl(CTimeSpans.TicksPerSecond)
End Function

' TimeSpanTotalMilliseconds returns the duration expressed in whole and
' fractional milliseconds.
Public Function TimeSpanTotalMilliseconds(ByRef ts As TimeSpan) As Double
Attribute TimeSpanTotalMilliseconds.VB_Description = "Duration expressed in whole and fractional milliseconds.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Double: The total milliseconds (possibly fractional)."
    TimeSpanTotalMilliseconds = CDbl(ts.ticks) / CDbl(CTimeSpans.TicksPerMillisecond)
End Function

' TimeSpanTotalMicroseconds returns the duration expressed in whole and
' fractional microseconds.
Public Function TimeSpanTotalMicroseconds(ByRef ts As TimeSpan) As Double
Attribute TimeSpanTotalMicroseconds.VB_Description = "Duration expressed in whole and fractional microseconds.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Double: The total microseconds (possibly fractional)."
    TimeSpanTotalMicroseconds = CDbl(ts.ticks) / CDbl(CTimeSpans.TicksPerMicrosecond)
End Function

' TimeSpanTotalNanoseconds returns the duration expressed in whole and
' fractional nanoseconds.
Public Function TimeSpanTotalNanoseconds(ByRef ts As TimeSpan) As Double
Attribute TimeSpanTotalNanoseconds.VB_Description = "Duration expressed in whole and fractional nanoseconds.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Double: The total nanoseconds (possibly fractional)."
    TimeSpanTotalNanoseconds = CDbl(ts.ticks) * CDbl(CTimeSpans.NanosecondsPerTick)
End Function

' TimeSpanToString returns the .NET Format C representation:
'   [-][d.]hh:mm:ss[.fffffff]
' The days component is omitted when zero, and the fractional component
' is omitted when the duration lands on a whole-second boundary.
Public Function TimeSpanToString(ByRef ts As TimeSpan) As String
Attribute TimeSpanToString.VB_Description = "Returns the .NET Format C representation: [-][d.]hh:mm:ss[.fffffff].\r\nThe days component is omitted when zero, and the fractional component is omitted on whole-second boundaries.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  String: The formatted string."
    TimeSpanToString = ToStringInternal(CDec(ts.ticks))
End Function

' TimeSpanHash returns a stable 32-bit hash of the tick count, suitable
' for using a CTimeSpan's value as a Scripting.Dictionary key. Uses the
' same polynomial string hash as System.String.GetHashCode.
Public Function TimeSpanHash(ByRef ts As TimeSpan) As Long
Attribute TimeSpanHash.VB_Description = "Stable 32-bit hash of the tick count (polynomial string hash).\r\nSuitable for using a TimeSpan's value as a Scripting.Dictionary key.\r\nArgs:\r\n  ts (TimeSpan): Source TimeSpan UDT.\r\nReturns:\r\n  Long: The 32-bit hash."
    TimeSpanHash = HashInternal(CDec(ts.ticks))
End Function

' WrapTimeSpan converts a UDT TimeSpan into a freshly-allocated CTimeSpan
' object. The CTimeSpan is constructed via Init (Friend-only) so the
' factory-controlled invariant is preserved.
Public Function WrapTimeSpan(ByRef udt As TimeSpan) As CTimeSpan
Attribute WrapTimeSpan.VB_Description = "Converts a UDT TimeSpan into a freshly-allocated CTimeSpan object.\r\nArgs:\r\n  udt (TimeSpan): Source UDT.\r\nReturns:\r\n  CTimeSpan: A new CTimeSpan wrapping the same tick count."
    Dim result As New CTimeSpan
    result.Init udt
    Set WrapTimeSpan = result
End Function

' UnwrapTimeSpan extracts the underlying TimeSpan UDT from a CTimeSpan
' object. Uses the Friend Udt accessor for direct UDT copy.
Public Function UnwrapTimeSpan(ByVal obj As CTimeSpan) As TimeSpan
Attribute UnwrapTimeSpan.VB_Description = "Extracts the underlying TimeSpan UDT from a CTimeSpan object.\r\nArgs:\r\n  obj (CTimeSpan): Source CTimeSpan object.\r\nReturns:\r\n  TimeSpan: The UDT form."
    UnwrapTimeSpan = obj.Udt
End Function

' CheckedAdd sums two Decimal tick counts, raising Overflow on
' out-of-range. The integer precondition is enforced by InTickRange.
Private Function CheckedAdd(ByVal a As Variant, ByVal b As Variant) As Variant
    Dim result As Variant
    result = CDec(a) + CDec(b)
    Ensure.IsTrue InTickRange(result), ErrorCodes.Overflow, "CTimeSpans.TimeSpanAdd", "resulting ticks out of range"
    CheckedAdd = result
End Function

' CheckedSubtract returns a - b, raising Overflow on out-of-range.
Private Function CheckedSubtract(ByVal a As Variant, ByVal b As Variant) As Variant
    Dim result As Variant
    result = CDec(a) - CDec(b)
    Ensure.IsTrue InTickRange(result), ErrorCodes.Overflow, "CTimeSpans.TimeSpanSubtract", "resulting ticks out of range"
    CheckedSubtract = result
End Function

' CheckedNegate returns -a, raising Overflow on the most-negative value.
Private Function CheckedNegate(ByVal a As Variant) As Variant
    Dim result As Variant
    result = -CDec(a)
    Ensure.IsTrue InTickRange(result), ErrorCodes.Overflow, "CTimeSpans.TimeSpanNegate", "cannot negate MinValue"
    CheckedNegate = result
End Function

' CheckedMultiply returns a * b, raising Overflow on out-of-range.
Private Function CheckedMultiply(ByVal a As Variant, ByVal b As Variant) As Variant
    Dim result As Variant
    result = CDec(a) * CDec(b)
    Ensure.IsTrue InTickRange(result), ErrorCodes.Overflow, "CTimeSpans.TimeSpanMultiply", "resulting ticks out of range"
    CheckedMultiply = result
End Function

' CheckedDivide returns a / b, raising Overflow when the quotient
' exceeds the tick range or when b is zero (the latter is what .NET
' signals as Overflow via DivideByZeroException -> we use Overflow for
' symmetry with the rest of the TimeSpan API).
Private Function CheckedDivide(ByVal a As Variant, ByVal b As Variant) As Variant
    Ensure.NotEqual b, CDec(0), ErrorCodes.Overflow, "CTimeSpans.TimeSpanDivide", "divisor cannot be zero"
    Dim result As Variant
    result = CDec(a) / CDec(b)
    Ensure.IsTrue InTickRange(result), ErrorCodes.Overflow, "CTimeSpans.TimeSpanDivide", "resulting ticks out of range"
    CheckedDivide = result
End Function

' TruncatedComponentTicks extracts the [0, scale) remainder of a tick
' count divided by a per-unit tick count. Used by Hours/Minutes/Seconds/
' Milliseconds/Microseconds to peel off the next-larger unit. Fix is
' applied AFTER division to truncate the (possibly repeating-decimal)
' ratio - CLng would otherwise round 23.999... up to 24 for the Hours
' component. ticks is taken as a parameter (no instance state) so the
' helper is reusable from both the OOP and the UDT accessors.
Private Function TruncatedComponentTicks(ByVal ticks As Variant, ByVal ticksPerUnit As Variant, ByVal unitsPerLarger As Variant) As Long
    Dim ticksAsDecimal As Variant
    Dim ticksPerUnitAsDecimal As Variant
    Dim ticksPerLarger As Variant
    Dim remainder As Variant
    ticksAsDecimal = CDec(ticks)
    ticksPerUnitAsDecimal = CDec(ticksPerUnit)
    ticksPerLarger = ticksPerUnitAsDecimal * CDec(unitsPerLarger)
    ' VB6's Mod operator coerces Decimal operands to Long (overflow when
    ' ticksPerLarger exceeds Long.MaxValue). Decimals.TruncationDivision keeps
    ' all arithmetic in Decimal and returns quotient + remainder in a
    ' VariantPair; we use only the remainder.
    remainder = Decimals.TruncationDivision(ticksAsDecimal, ticksPerLarger).second
    TruncatedComponentTicks = CLng(Fix(CDec(remainder) / ticksPerUnitAsDecimal))
End Function

' InTickRange reports whether value is inside [MinValue, MaxValue].
' Integer-only precondition; callers must pass a whole-number Decimal.
Private Function InTickRange(ByVal value As Variant) As Boolean
    Ensure.IsTrue value = Fix(value), ErrorCodes.InvalidProcedureCall, "CTimeSpans.InTickRange", "value must be an integer"
    If CDec(value) >= CDec(MIN_TICKS_STR) Then
        If CDec(value) <= CDec(MAX_TICKS_STR) Then
            InTickRange = True
        Else
            InTickRange = False
        End If
    Else
        InTickRange = False
    End If
End Function

' TimeToTicks combines d:h:m:s into a tick count. The .NET Int64
' implementation throws Overflow when the result would exceed
' [MinValue, MaxValue]; we delegate the same check to InTickRange.
Private Function TimeToTicks(ByVal d As Long, ByVal h As Long, ByVal m As Long, ByVal s As Long) As Variant
    Dim totalSeconds As Variant
    totalSeconds = CDec(d) * CDec(CTimeSpans.SecondsPerDay) _
        + CDec(h) * CDec(CTimeSpans.SecondsPerHour) _
        + CDec(m) * CDec(CTimeSpans.SecondsPerMinute) _
        + CDec(s)
    Ensure.IsTrue CDec(Abs(CDbl(totalSeconds))) <= CDec("922337203685"), ErrorCodes.Overflow, "CTimeSpans.TimeToTicks", "total seconds exceeds MaxSeconds"
    Dim ticks As Variant
    ticks = totalSeconds * CDec(CTimeSpans.TicksPerSecond)
    Ensure.IsTrue InTickRange(ticks), ErrorCodes.Overflow, "CTimeSpans.TimeToTicks", "resulting ticks out of range"
    TimeToTicks = ticks
End Function

' ToStringInternal renders a tick count in .NET Format C form. The body
' was extracted verbatim from the previous CTimeSpan.cls ToString
' implementation; only the source of the tick value changed (now a
' parameter rather than the m_udt field of a CTimeSpan).
Private Function ToStringInternal(ByVal ticks As Variant) As String
    Dim sign As String
    If ticks < CDec(0) Then
        sign = "-"
        ticks = -ticks
    End If
    Dim perDay As Variant
    perDay = CDec(CTimeSpans.TicksPerDay)
    Dim perHour As Variant
    perHour = CDec(CTimeSpans.TicksPerHour)
    Dim perMin As Variant
    perMin = CDec(CTimeSpans.TicksPerMinute)
    Dim perSec As Variant
    perSec = CDec(CTimeSpans.TicksPerSecond)
    Dim days As Variant
    days = CLng(Fix(CDec(ticks) / perDay))
    Dim rem1 As Variant
    rem1 = ticks - CDec(days) * perDay
    Dim hours As Variant
    hours = CLng(Fix(CDec(rem1) / perHour))
    Dim rem2 As Variant
    rem2 = rem1 - CDec(hours) * perHour
    Dim minutes As Variant
    minutes = CLng(Fix(CDec(rem2) / perMin))
    Dim rem3 As Variant
    rem3 = rem2 - CDec(minutes) * perMin
    Dim seconds As Variant
    seconds = CLng(Fix(CDec(rem3) / perSec))
    Dim frac As Variant
    frac = rem3 - CDec(seconds) * perSec
    Dim hh As String, mm As String, ss As String
    hh = Right$("0" & CStr(hours), 2)
    mm = Right$("0" & CStr(minutes), 2)
    ss = Right$("0" & CStr(seconds), 2)
    Dim result As String
    If days = 0 Then
        result = hh & ":" & mm & ":" & ss
    Else
        result = CStr(days) & "." & hh & ":" & mm & ":" & ss
    End If
    If frac <> CDec(0) Then
        result = result & "." & Right$("0000000" & CStr(frac), 7)
    End If
    ToStringInternal = sign & result
End Function

' HashInternal computes a 32-bit hash of the tick count using the same
' algorithm as .NET's TimeSpan.GetHashCode:
'
'   unchecked((int)(long)m_value) ^ (int)(m_value >> 32)
'
' i.e. XOR the lower 32 bits of the 64-bit tick count with the upper 32
' bits. This delegates to Int64.GetHashCode and is a stable,
' well-distributed hash for tick values in the 64-bit range enforced
' by InTickRange.
'
' Implementation in VB6: m_value is a Decimal constrained to 64-bit
' range by the time it reaches this function. "Right shift by 32" is
' truncation-division by 2^32; the low 32 bits are the Decimal remainder
' modulo 2^32; both halves are cast to Long (which is 32-bit signed in
' VB6, exactly matching C#'s int) and XORed.
Private Function HashInternal(ByVal ticks As Variant) As Long
    Dim twoTo32 As Variant
    Dim upper32 As Long
    Dim lower32 As Long
    twoTo32 = CDec("4294967296")
    ' Upper 32 bits: ticks / 2^32 (truncation division toward zero).
    ' The quotient may be negative for negative ticks; cast to Long
    ' gives the bit pattern of the high half, matching (int)(m_value >> 32).
    upper32 = CLng(Decimals.TruncationDivision(CDec(ticks), twoTo32).first)
    ' Lower 32 bits: ticks - upper32 * 2^32. The result is in
    ' [-2^31, 2^31), which fits in Long. Cast to Long gives the bit
    ' pattern of the low half, matching (int)(long)m_value.
    lower32 = CLng(CDec(ticks) - CDec(upper32) * twoTo32)
    HashInternal = lower32 Xor upper32
End Function
