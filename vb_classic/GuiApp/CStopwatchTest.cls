VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CStopwatchTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Sub Sleep Lib "kernel32" (ByVal ms As Long)

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestFrequency
    TestIsHighResolution
    TestGetTimestamp
    TestStartNew
    TestElapsed
    TestPause
    TestReset
    TestRestart
End Sub

Private Sub TestFrequency()
    Dim freq As Variant
    freq = CStopwatches.Frequency
    m_asserter.IsTrue CDec(freq) > CDec(0), "CStopwatchTest.TestFrequency", "Frequency must be positive"
End Sub

Private Sub TestIsHighResolution()
    m_asserter.IsTrue CStopwatches.IsHighResolution, "CStopwatchTest.TestIsHighResolution", "IsHighResolution is always True"
End Sub

Private Sub TestGetTimestamp()
    Dim t1 As Variant
    Dim t2 As Variant
    t1 = CStopwatches.GetTimestamp
    Sleep 10
    t2 = CStopwatches.GetTimestamp
    m_asserter.IsTrue CDec(t2) > CDec(t1), "CStopwatchTest.TestGetTimestamp", "GetTimestamp should be monotonically increasing"
End Sub

Private Sub TestStartNew()
    Dim sw As CStopwatch
    Set sw = CStopwatches.StartNew()
    m_asserter.IsTrue sw.IsRunning, "CStopwatchTest.TestStartNew", "StartNew should be running"
End Sub

Private Sub TestElapsed()
    Dim sw As CStopwatch
    Set sw = CStopwatches.StartNew()
    Sleep 50
    sw.Pause
    Dim elapsed As CTimeSpan
    Set elapsed = sw.Elapsed
    m_asserter.IsTrue elapsed.TotalMilliseconds >= 40, "CStopwatchTest.TestElapsed", "Elapsed >= 40ms after 50ms sleep"
    m_asserter.IsTrue elapsed.TotalMilliseconds < 1000, "CStopwatchTest.TestElapsed", "Elapsed < 1s (sanity)"

    Dim ems As Double
    ems = sw.ElapsedMilliseconds
    m_asserter.IsTrue ems >= 40, "CStopwatchTest.TestElapsed", "ElapsedMilliseconds >= 40"
End Sub

Private Sub TestPause()
    Dim sw As CStopwatch
    Set sw = CStopwatches.StartNew()
    Sleep 10
    sw.Pause
    m_asserter.IsFalse sw.IsRunning, "CStopwatchTest.TestPause", "Pause sets IsRunning=False"
    Dim e1 As Double
    e1 = sw.ElapsedMilliseconds
    Sleep 20
    Dim e2 As Double
    e2 = sw.ElapsedMilliseconds
    m_asserter.IsTrue e2 = e1, "CStopwatchTest.TestStop", "Elapsed freezes after Stop"
End Sub

Private Sub TestReset()
    Dim sw As CStopwatch
    Set sw = CStopwatches.StartNew()
    Sleep 20
    sw.Reset
    m_asserter.IsFalse sw.IsRunning, "CStopwatchTest.TestReset", "Reset sets IsRunning=False"
    m_asserter.AreEqual sw.ElapsedMilliseconds, 0, "CStopwatchTest.TestReset", "Reset zeros ElapsedMilliseconds"
End Sub

Private Sub TestRestart()
    Dim sw As CStopwatch
    Set sw = CStopwatches.StartNew()
    Sleep 20
    sw.Restart
    m_asserter.IsTrue sw.IsRunning, "CStopwatchTest.TestRestart", "Restart sets IsRunning=True"
    ' Just-elapsed should be small (no sleep between Restart and read)
    m_asserter.IsTrue sw.ElapsedMilliseconds < 100, "CStopwatchTest.TestRestart", "Restart resets elapsed"
End Sub
