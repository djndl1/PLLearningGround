VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTimeSpan"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Type TimeSpan
    Ticks As Variant
End Type

' CTimeSpan is the OOP wrapper for a TimeSpan. Storage is a TimeSpan UDT
' (a single Variant Ticks field defined in TimeSpanValues.bas) which
' provides the value-type representation used by the procedural API in
' CTimeSpans. All 31 public members delegate to the procedural API
' exposed by CTimeSpans. Init is Friend-only; external callers use
' CTimeSpanFactory.From* or CTimeSpans.WrapTimeSpan. A Friend Udt
' accessor exposes the UDT to other CTimeSpan instances (and to
' CTimeSpans.WrapTimeSpan / UnwrapTimeSpan) for OOP-to-UDT bridging.

Private m_udt As TimeSpan

Private Sub Class_Initialize()
    m_udt.Ticks = CDec(0)
End Sub

' Init is the internal constructor used by CTimeSpanFactory / CTimeSpans
' factories. Friend-only: external callers should use CTimeSpanFactory
' or CTimeSpans.WrapTimeSpan instead.
Friend Sub Init(ByRef udt As TimeSpan)
    m_udt = udt
End Sub

' Udt exposes the underlying TimeSpan UDT to other classes in the same
' project (used by CTimeSpans.UnwrapTimeSpan and by CTimeSpan's own
' arithmetic / comparison methods when accessing another CTimeSpan).
' Friend-only: the UDT is not part of the COM-visible surface.
Friend Property Get Udt() As TimeSpan
    Udt = m_udt
End Property

Public Property Get Ticks() As Variant
Attribute Ticks.VB_Description = "Returns the underlying 100-nanosecond tick count as a Decimal.\r\nReturns:\r\n  Variant: The tick count."
    Ticks = m_udt.Ticks
End Property

Public Property Get Days() As Long
Attribute Days.VB_Description = "Days component of the duration.\r\nCarries the sign of the overall TimeSpan (e.g. -1.5 days -> -1).\r\nReturns:\r\n  Long: The days component."
    Days = CTimeSpans.TimeSpanDays(m_udt)
End Property

Public Property Get Hours() As Long
Attribute Hours.VB_Description = "Hours component [-23, 23] of the day component.\r\nReturns:\r\n  Long: The hours component."
    Hours = CTimeSpans.TimeSpanHours(m_udt)
End Property

Public Property Get Minutes() As Long
Attribute Minutes.VB_Description = "Minutes component [-59, 59] of the hour component.\r\nReturns:\r\n  Long: The minutes component."
    Minutes = CTimeSpans.TimeSpanMinutes(m_udt)
End Property

Public Property Get Seconds() As Long
Attribute Seconds.VB_Description = "Seconds component [-59, 59] of the minute component.\r\nReturns:\r\n  Long: The seconds component."
    Seconds = CTimeSpans.TimeSpanSeconds(m_udt)
End Property

Public Property Get Milliseconds() As Long
Attribute Milliseconds.VB_Description = "Milliseconds component [-999, 999] of the second component.\r\nReturns:\r\n  Long: The milliseconds component."
    Milliseconds = CTimeSpans.TimeSpanMilliseconds(m_udt)
End Property

Public Property Get Microseconds() As Long
Attribute Microseconds.VB_Description = "Microseconds component [-999, 999] of the millisecond component.\r\nReturns:\r\n  Long: The microseconds component."
    Microseconds = CTimeSpans.TimeSpanMicroseconds(m_udt)
End Property

Public Property Get Nanoseconds() As Long
Attribute Nanoseconds.VB_Description = "Nanoseconds component [-900, 900] of the microsecond component (in 100ns steps).\r\nReturns:\r\n  Long: The nanoseconds component."
    Nanoseconds = CTimeSpans.TimeSpanNanoseconds(m_udt)
End Property

Public Property Get TotalDays() As Double
Attribute TotalDays.VB_Description = "Duration expressed in whole and fractional days.\r\nReturns:\r\n  Double: The total days (possibly fractional)."
    TotalDays = CTimeSpans.TimeSpanTotalDays(m_udt)
End Property

Public Property Get TotalHours() As Double
Attribute TotalHours.VB_Description = "Duration expressed in whole and fractional hours.\r\nReturns:\r\n  Double: The total hours (possibly fractional)."
    TotalHours = CTimeSpans.TimeSpanTotalHours(m_udt)
End Property

Public Property Get TotalMinutes() As Double
Attribute TotalMinutes.VB_Description = "Duration expressed in whole and fractional minutes.\r\nReturns:\r\n  Double: The total minutes (possibly fractional)."
    TotalMinutes = CTimeSpans.TimeSpanTotalMinutes(m_udt)
End Property

Public Property Get TotalSeconds() As Double
Attribute TotalSeconds.VB_Description = "Duration expressed in whole and fractional seconds.\r\nReturns:\r\n  Double: The total seconds (possibly fractional)."
    TotalSeconds = CTimeSpans.TimeSpanTotalSeconds(m_udt)
End Property

Public Property Get TotalMilliseconds() As Double
Attribute TotalMilliseconds.VB_Description = "Duration expressed in whole and fractional milliseconds.\r\nReturns:\r\n  Double: The total milliseconds (possibly fractional)."
    TotalMilliseconds = CTimeSpans.TimeSpanTotalMilliseconds(m_udt)
End Property

Public Property Get TotalMicroseconds() As Double
Attribute TotalMicroseconds.VB_Description = "Duration expressed in whole and fractional microseconds.\r\nReturns:\r\n  Double: The total microseconds (possibly fractional)."
    TotalMicroseconds = CTimeSpans.TimeSpanTotalMicroseconds(m_udt)
End Property

Public Property Get TotalNanoseconds() As Double
Attribute TotalNanoseconds.VB_Description = "Duration expressed in whole and fractional nanoseconds.\r\nReturns:\r\n  Double: The total nanoseconds (possibly fractional)."
    TotalNanoseconds = CTimeSpans.TimeSpanTotalNanoseconds(m_udt)
End Property

Public Function Add(ByVal ts As CTimeSpan) As CTimeSpan
Attribute Add.VB_Description = "Returns a new CTimeSpan whose ticks are this + ts.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  ts (CTimeSpan): Right operand.\r\nReturns:\r\n  CTimeSpan: this + ts."
    Ensure.ArgumentNotNull ts, "ts"
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanAdd(m_udt, ts.Udt)
    Dim result As New CTimeSpan
    result.Init resultUdt
    Set Add = result
End Function

Public Function Subtract(ByVal ts As CTimeSpan) As CTimeSpan
Attribute Subtract.VB_Description = "Returns a new CTimeSpan whose ticks are this - ts.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  ts (CTimeSpan): Right operand.\r\nReturns:\r\n  CTimeSpan: this - ts."
    Ensure.ArgumentNotNull ts, "ts"
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanSubtract(m_udt, ts.Udt)
    Dim result As New CTimeSpan
    result.Init resultUdt
    Set Subtract = result
End Function

Public Function Negate() As CTimeSpan
Attribute Negate.VB_Description = "Returns a new CTimeSpan with the sign of the duration inverted.\r\nNegating MinValue raises Overflow (no positive equivalent).\r\nReturns:\r\n  CTimeSpan: -this."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanNegate(m_udt)
    Dim result As New CTimeSpan
    result.Init resultUdt
    Set Negate = result
End Function

Public Function Duration() As CTimeSpan
Attribute Duration.VB_Description = "Returns the absolute value as a new CTimeSpan.\r\nThe largest negative value raises Overflow.\r\nReturns:\r\n  CTimeSpan: |this|."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanDuration(m_udt)
    Dim result As New CTimeSpan
    result.Init resultUdt
    Set Duration = result
End Function

Public Function Multiply(ByVal factor As Double) As CTimeSpan
Attribute Multiply.VB_Description = "Returns a new CTimeSpan scaled by factor.\r\nfactor can be negative. Raises Overflow on out-of-range.\r\nArgs:\r\n  factor (Double): Scale factor.\r\nReturns:\r\n  CTimeSpan: this * factor."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanMultiply(m_udt, factor)
    Dim result As New CTimeSpan
    result.Init resultUdt
    Set Multiply = result
End Function

Public Function Divide(ByVal divisor As Double) As CTimeSpan
Attribute Divide.VB_Description = "Returns a new CTimeSpan whose ticks are this / divisor.\r\ndivisor = 0 raises Overflow; result out of range also raises Overflow.\r\nArgs:\r\n  divisor (Double): Divisor.\r\nReturns:\r\n  CTimeSpan: this / divisor."
    Dim resultUdt As TimeSpan
    resultUdt = CTimeSpans.TimeSpanDivide(m_udt, divisor)
    Dim result As New CTimeSpan
    result.Init resultUdt
    Set Divide = result
End Function

Public Function DivideBy(ByVal ts As CTimeSpan) As Double
Attribute DivideBy.VB_Description = "Returns this / ts as a Double ratio.\r\nts.Ticks = 0 raises Overflow.\r\nArgs:\r\n  ts (CTimeSpan): Denominator.\r\nReturns:\r\n  Double: this.Ticks / ts.Ticks."
    Ensure.ArgumentNotNull ts, "ts"
    DivideBy = CTimeSpans.TimeSpanDivideBy(m_udt, ts.Udt)
End Function

Public Function Equals(ByVal other As CTimeSpan) As Boolean
Attribute Equals.VB_Description = "Returns True when this and other have the same tick count.\r\nArgs:\r\n  other (CTimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when this.Ticks = other.Ticks."
    Ensure.ArgumentNotNull other, "other"
    Equals = CTimeSpans.TimeSpanEquals(m_udt, other.Udt)
End Function

Public Function NotEquals(ByVal other As CTimeSpan) As Boolean
Attribute NotEquals.VB_Description = "Returns True when this and other have different tick counts.\r\nArgs:\r\n  other (CTimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when this.Ticks <> other.Ticks."
    Ensure.ArgumentNotNull other, "other"
    NotEquals = CTimeSpans.TimeSpanNotEquals(m_udt, other.Udt)
End Function

Public Function IsLessThan(ByVal other As CTimeSpan) As Boolean
Attribute IsLessThan.VB_Description = "Returns True when this is strictly less than other.\r\nArgs:\r\n  other (CTimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when this.Ticks < other.Ticks."
    Ensure.ArgumentNotNull other, "other"
    IsLessThan = CTimeSpans.TimeSpanIsLessThan(m_udt, other.Udt)
End Function

Public Function IsLessThanOrEqualTo(ByVal other As CTimeSpan) As Boolean
Attribute IsLessThanOrEqualTo.VB_Description = "Returns True when this is less than or equal to other.\r\nArgs:\r\n  other (CTimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when this.Ticks <= other.Ticks."
    Ensure.ArgumentNotNull other, "other"
    IsLessThanOrEqualTo = CTimeSpans.TimeSpanIsLessThanOrEqualTo(m_udt, other.Udt)
End Function

Public Function IsGreaterThan(ByVal other As CTimeSpan) As Boolean
Attribute IsGreaterThan.VB_Description = "Returns True when this is strictly greater than other.\r\nArgs:\r\n  other (CTimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when this.Ticks > other.Ticks."
    Ensure.ArgumentNotNull other, "other"
    IsGreaterThan = CTimeSpans.TimeSpanIsGreaterThan(m_udt, other.Udt)
End Function

Public Function IsGreaterThanOrEqualTo(ByVal other As CTimeSpan) As Boolean
Attribute IsGreaterThanOrEqualTo.VB_Description = "Returns True when this is greater than or equal to other.\r\nArgs:\r\n  other (CTimeSpan): Right operand.\r\nReturns:\r\n  Boolean: True when this.Ticks >= other.Ticks."
    Ensure.ArgumentNotNull other, "other"
    IsGreaterThanOrEqualTo = CTimeSpans.TimeSpanIsGreaterThanOrEqualTo(m_udt, other.Udt)
End Function

Public Function CompareTo(ByVal other As CTimeSpan) As Long
Attribute CompareTo.VB_Description = "Returns -1, 0, or +1 following the IComparable convention.\r\nArgs:\r\n  other (CTimeSpan): Right operand.\r\nReturns:\r\n  Long: -1, 0, or +1 based on the relative magnitude of this.Ticks vs other.Ticks."
    Ensure.ArgumentNotNull other, "other"
    CompareTo = CTimeSpans.TimeSpanCompareTo(m_udt, other.Udt)
End Function

Public Function ToString() As String
Attribute ToString.VB_Description = "Returns the .NET Format C representation: [-][d.]hh:mm:ss[.fffffff].\r\nThe days component is omitted when zero, and the fractional component is omitted on whole-second boundaries.\r\nReturns:\r\n  String: The formatted string."
    ToString = CTimeSpans.TimeSpanToString(m_udt)
End Function

Public Function Hash() As Long
Attribute Hash.VB_Description = "Stable 32-bit hash of the tick count (polynomial string hash).\r\nSuitable for using this CTimeSpan's value as a Scripting.Dictionary key.\r\nReturns:\r\n  Long: The 32-bit hash."
    Hash = CTimeSpans.TimeSpanHash(m_udt)
End Function