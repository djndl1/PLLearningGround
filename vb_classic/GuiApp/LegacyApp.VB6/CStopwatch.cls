VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CStopwatch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' CStopwatch measures elapsed time using the high-resolution
' Windows performance counter. Faithful port of
' System.Diagnostics.Stopwatch from .NET (the partial class
' that hosts the Win32 QueryPerformanceCounter calls). State
' is held in Variant(Decimal) for full Int64 range; the
' QPC-as-Currency conversion trick lives in CStopwatches.

' Accumulated elapsed time across Start/Stop cycles, in raw
' QPC counts. When the stopwatch is running, the in-progress
' interval (GetTimestamp() - m_startTimeStamp) is added on
' the fly by the ElapsedTicks getter.
Private m_elapsed As Variant

' QPC count at the most recent Start. Meaningful only when
' m_isRunning is True; stale (and not consulted) otherwise.
Private m_startTimeStamp As Variant

' True between Start and the next Stop, False otherwise.
Private m_isRunning As Boolean

Private Sub Class_Initialize()
    m_elapsed = CDec(0)
    m_startTimeStamp = CDec(0)
    m_isRunning = False
End Sub

' Start begins (or resumes) measuring elapsed time. Calling
' Start on a running Stopwatch is a no-op, matching .NET.
Public Sub Start()
    If Not m_isRunning Then
        m_startTimeStamp = CStopwatches.GetTimestamp()
        m_isRunning = True
    End If
End Sub

' Stop ends measuring elapsed time, accumulating the elapsed
' interval into m_elapsed. Calling Stop on a stopped
' Stopwatch is a no-op, matching .NET.
Public Sub Pause()
    If m_isRunning Then
        m_elapsed = CDec(m_elapsed) + (CDec(CStopwatches.GetTimestamp()) - CDec(m_startTimeStamp))
        m_isRunning = False
    End If
End Sub

' Reset stops the Stopwatch and sets elapsed time to zero.
' After Reset, the instance is in the same state as a fresh
' New CStopwatch.
Public Sub Reset()
    m_elapsed = CDec(0)
    m_startTimeStamp = CDec(0)
    m_isRunning = False
End Sub

' Restart is a single-call equivalent of {sw.Reset; sw.Start}.
Public Sub Restart()
    Reset
    Start
End Sub

' IsRunning returns True if the Stopwatch is currently
' running (between Start and the next Stop).
Public Property Get IsRunning() As Boolean
    IsRunning = m_isRunning
End Property

' Elapsed returns the total elapsed time as a CTimeSpan.
' When running, the in-progress interval is folded in on
' the fly; when stopped, the accumulated m_elapsed is
' converted to ticks directly.
Public Property Get Elapsed() As CTimeSpan
    Set Elapsed = CTimeSpanFactory.FromTicks(ElapsedTimeSpanTicks())
End Property

' ElapsedMilliseconds returns the total elapsed time in
' milliseconds, preserving sub-ms precision via Double.
' Mirrors .NET's Stopwatch.ElapsedMilliseconds (which is
' also Double-precision in .NET 9).
Public Property Get ElapsedMilliseconds() As Double
    ElapsedMilliseconds = CDbl(ElapsedTimeSpanTicks()) / CDbl(CTimeSpans.TicksPerMillisecond)
End Property

' ElapsedTicks returns the total elapsed time in raw QPC
' counts (not TimeSpan ticks). To convert to seconds,
' divide by CStopwatches.Frequency. Mirrors .NET's
' Stopwatch.ElapsedTicks.
Public Property Get ElapsedTicks() As Variant
    Dim timeElapsed As Variant
    timeElapsed = CDec(m_elapsed)
    If m_isRunning Then
        timeElapsed = CDec(timeElapsed) + (CDec(CStopwatches.GetTimestamp()) - CDec(m_startTimeStamp))
    End If
    ElapsedTicks = timeElapsed
End Property

' ToString returns the elapsed time formatted by
' CTimeSpan.ToString. Mirrors .NET's Stopwatch.ToString.
Public Function ToString() As String
    ToString = Elapsed().ToString()
End Function

' ElapsedTimeSpanTicks converts raw QPC counts into TimeSpan
' 100-nanosecond ticks via the cached TickFrequency ratio
' exposed by CStopwatches.QpcToTimeSpanTicks.
Private Function ElapsedTimeSpanTicks() As Variant
    ElapsedTimeSpanTicks = CStopwatches.QpcToTimeSpanTicks(ElapsedTicks())
End Function
