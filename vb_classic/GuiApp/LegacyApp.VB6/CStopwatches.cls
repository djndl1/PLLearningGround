VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CStopwatches"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' CStopwatches is the factory class for CStopwatch. The
' VB_GlobalNameSpace = True + VB_PredeclaredId = True
' attributes make its members callable as
' CStopwatches.StartNew() without explicit instantiation,
' mirroring the Arrays / CTimeSpans singleton pattern.

' QueryPerformanceCounter / QueryPerformanceFrequency write a
' raw 64-bit count into the ByRef parameter. We declare the
' parameter as Currency because Currency's 8-byte storage is
' the same size as an Int64, and Windows happily writes the
' 8 bytes of the QPC count there. The catch: Currency is
' stored as Int64 / 10000 (its 4-decimal-place scaling), so
' the raw int64 has to be recovered by multiplying by 10000
' after CDec() conversion. The conversion happens at this
' single boundary; all internal arithmetic uses Decimal.
Private Declare Function QueryPerformanceCounter Lib "kernel32" _
    (ByRef lpPerformanceCount As Currency) As Long
Private Declare Function QueryPerformanceFrequency Lib "kernel32" _
    (ByRef lpFrequency As Currency) As Long

' m_frequency is the QPC counts per second, stored as Decimal
' so the Int64 range survives. Populated once at
' Class_Initialize from QueryPerformanceFrequency.
Private m_frequency As Variant

' m_tickFrequency caches the ratio
'   CTimeSpans.TicksPerSecond / m_frequency
' as a Decimal, eliminating the per-call division when
' converting raw QPC counts to TimeSpan ticks. Mirrors the
' .NET s_tickFrequency private static field.
' tick per counter
Private m_tickFrequency As Variant

Private Sub Class_Initialize()
    Dim freq As Currency
    If QueryPerformanceFrequency(freq) = 0 Then
        Err.Raise ErrorCodes.ObjectVariableNotSet, _
            "CStopwatches.Class_Initialize", _
            "QueryPerformanceFrequency failed"
    End If
    ' Recover raw int64 from Currency's 4-decimal scaling.
    m_frequency = CDec(freq) * CDec(10000)
    m_tickFrequency = CDec(CTimeSpans.TicksPerSecond) / m_frequency
End Sub

' Frequency returns the count rate of the high-resolution
' performance counter, in counts per second. Exposed for
' callers that want to convert raw QPC counts to seconds
' without going through a CStopwatch instance.
Public Property Get Frequency() As Variant
    Frequency = m_frequency
End Property

' IsHighResolution always returns True. .NET 9 hardcodes
' this because QPC has been ubiquitous on Windows since
' XP; the VB6 project targets Windows only and relies on QPC.
Public Property Get IsHighResolution() As Boolean
    IsHighResolution = True
End Property

' GetTimestamp returns the current value of the high-
' resolution performance counter, converted from the raw
' Int64 to Variant(Decimal). Callers that want the ratio
' can divide by CStopwatches.Frequency to get seconds.
Public Function GetTimestamp() As Variant
    Dim raw As Currency
    If QueryPerformanceCounter(raw) = 0 Then
        Err.Raise ErrorCodes.ObjectVariableNotSet, _
            "CStopwatches.GetTimestamp", _
            "QueryPerformanceCounter failed"
    End If
    ' Recover raw int64 from Currency's 4-decimal scaling.
    GetTimestamp = CDec(raw) * CDec(10000)
End Function

' StartNew creates a new CStopwatch, calls Start, and returns
' it. Mirrors the .NET Stopwatch.StartNew() factory.
Public Function StartNew() As CStopwatch
    Dim result As New CStopwatch
    result.Start
    Set StartNew = result
End Function

' GetElapsedTime returns the CTimeSpan between the starting
' timestamp and the optional ending timestamp. When the
' ending timestamp is missing, the current time is sampled
' via GetTimestamp. Mirrors the .NET overloads of
' Stopwatch.GetElapsedTime(long, long).
Public Function GetElapsedTime(ByVal startingTimestamp As Variant, _
                               Optional ByVal endingTimestamp As Variant) As CTimeSpan
    If IsMissing(endingTimestamp) Then
        endingTimestamp = GetTimestamp()
    End If
    Dim elapsedQpc As Variant
    elapsedQpc = CDec(endingTimestamp) - CDec(startingTimestamp)
    Dim tsTicks As Variant
    tsTicks = CDec(elapsedQpc) * CDec(m_tickFrequency)
    Set GetElapsedTime = CTimeSpanFactory.FromTicks(tsTicks)
End Function

' QpcToTimeSpanTicks converts raw QPC counts into TimeSpan
' 100-nanosecond ticks via the cached TickFrequency ratio.
' Called by CStopwatch.ElapsedTimeSpanTicks. Public so the
' CStopwatch instance can reach across the class boundary
' without duplicating the conversion.
Public Function QpcToTimeSpanTicks(ByVal qpcCounts As Variant) As Variant
    QpcToTimeSpanTicks = Fix(CDec(qpcCounts) * CDec(m_tickFrequency))
End Function
