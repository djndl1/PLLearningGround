VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NaiveCounterTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter
Private m_counter As NaiveCounter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestConstructor
    TestIncrementNoOverflow
    TestIncrementWithOverflow
    TestAddWithOverflow
    TestReset
    TestJustOverflowedFlag
    TestOverflowEvent
    TestIncrementLessThanOne
    TestUnsubscribe
End Sub

Private Sub TestConstructor()
    Set m_counter = New NaiveCounter
    m_counter.Init "TestCounter", 5

    m_asserter.AreEqual "TestCounter", m_counter.Name, "NaiveCounterTest.TestConstructor", "Name should be 'TestCounter'"
    m_asserter.AreEqual 0&, m_counter.Current, "NaiveCounterTest.TestConstructor", "Initial current should be 0"
    m_asserter.AreEqual 5&, m_counter.Max, "NaiveCounterTest.TestConstructor", "Max should be 5"
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestConstructor", "JustOverflowed should be false initially"
End Sub

Private Sub TestIncrementNoOverflow()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 10

    m_counter.increment
    m_asserter.AreEqual 1&, m_counter.Current, "NaiveCounterTest.TestIncrementNoOverflow", "Current should be 1 after increment"
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestIncrementNoOverflow", "JustOverflowed should be false"

    m_counter.increment
    m_asserter.AreEqual 2&, m_counter.Current, "NaiveCounterTest.TestIncrementNoOverflow", "Current should be 2 after second increment"
End Sub

Private Sub TestIncrementWithOverflow()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 3

    m_counter.increment  ' 1
    m_counter.increment  ' 2
    m_counter.increment  ' 3 - no overflow (3 > 3 is false)
    m_counter.increment  ' 4 - should overflow to 0
    m_asserter.AreEqual 0&, m_counter.Current, "NaiveCounterTest.TestIncrementWithOverflow", "Current should be 0 after overflow"
    m_asserter.IsTrue m_counter.JustOverflowed, "NaiveCounterTest.TestIncrementWithOverflow", "JustOverflowed should be true after overflow"

    ' Next increment should not have JustOverflowed flag
    m_counter.increment
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestIncrementWithOverflow", "JustOverflowed should be false after next increment"
End Sub

Private Sub TestAddWithOverflow()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 5

    m_counter.Add 3
    m_asserter.AreEqual 3&, m_counter.Current, "NaiveCounterTest.TestAddWithOverflow", "Current should be 3 after Add(3)"

    m_counter.Add 4  ' 3 + 4 = 7 > 5, overflow
    m_asserter.AreEqual 0&, m_counter.Current, "NaiveCounterTest.TestAddWithOverflow", "Current should be 0 after overflow"
    m_asserter.IsTrue m_counter.JustOverflowed, "NaiveCounterTest.TestAddWithOverflow", "JustOverflowed should be true"
End Sub

Private Sub TestReset()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 5

    m_counter.Add 3
    m_asserter.AreEqual 3&, m_counter.Current, "NaiveCounterTest.TestReset", "Current should be 3 before reset"

    m_counter.Reset
    m_asserter.AreEqual 0&, m_counter.Current, "NaiveCounterTest.TestReset", "Current should be 0 after reset"
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestReset", "JustOverflowed should be false after reset"
End Sub

Private Sub TestJustOverflowedFlag()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 2

    m_counter.increment  ' 1
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestJustOverflowedFlag", "JustOverflowed should be false at 1"

    m_counter.increment  ' 2 - no overflow (2 > 2 is false)
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestJustOverflowedFlag", "JustOverflowed should be false at 2"

    m_counter.increment  ' 3 - overflow (3 > 2 is true)
    m_asserter.IsTrue m_counter.JustOverflowed, "NaiveCounterTest.TestJustOverflowedFlag", "JustOverflowed should be true after overflow"

    m_counter.increment  ' 1
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestJustOverflowedFlag", "JustOverflowed should be false after increment following overflow"

    m_counter.increment  ' 2
    m_asserter.IsFalse m_counter.JustOverflowed, "NaiveCounterTest.TestJustOverflowedFlag", "JustOverflowed should be false at 2"

    m_counter.increment  ' 3 - overflow again
    m_asserter.IsTrue m_counter.JustOverflowed, "NaiveCounterTest.TestJustOverflowedFlag", "JustOverflowed should be true after second overflow"
End Sub

Private Sub TestOverflowEvent()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 2

    Dim catcher As OverflowEventCatcher
    Set catcher = New OverflowEventCatcher
    m_counter.Subscribe catcher

    m_counter.increment  ' 1
    m_asserter.IsFalse catcher.Fired, "NaiveCounterTest.TestOverflowEvent", "Event should not fire at 1"
    
    m_counter.increment  ' 2 - no overflow (2 > 2 is false)
    m_asserter.IsFalse catcher.Fired, "NaiveCounterTest.TestOverflowEvent", "Event should not fire at 2"
    
    m_counter.increment  ' 3 - overflow (3 > 2 is true)
    m_asserter.IsTrue catcher.Fired, "NaiveCounterTest.TestOverflowEvent", "Event should fire on overflow"
    m_asserter.AreEqual 2&, catcher.LastValue, "NaiveCounterTest.TestOverflowEvent", "LastValue should be 2"
End Sub

Private Sub TestUnsubscribe()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 2

    Dim catcher As OverflowEventCatcher
    Set catcher = New OverflowEventCatcher
    m_counter.Subscribe catcher

    m_counter.increment  ' 1
    m_counter.increment  ' 2 - no overflow
    m_counter.increment  ' 3 - overflow, event fires
    m_asserter.IsTrue catcher.Fired, "NaiveCounterTest.TestUnsubscribe", "Event should fire before unsubscribe"

    ' Unsubscribe and reset
    m_counter.Unsubscribe catcher
    Set catcher = Nothing
    Set catcher = New OverflowEventCatcher  ' Create new catcher
    m_counter.Subscribe catcher

    m_counter.increment  ' 1
    m_counter.increment  ' 2 - no overflow
    m_counter.increment  ' 3 - overflow, event should fire for new catcher
    m_asserter.IsTrue catcher.Fired, "NaiveCounterTest.TestUnsubscribe", "Event should fire for new subscriber"

    ' Unsubscribe again
    m_counter.Unsubscribe catcher
    catcher.Reset

    m_counter.increment  ' 1
    m_counter.increment  ' 2 - no overflow
    m_counter.increment  ' 3 - overflow, no event should fire (not subscribed)
    m_asserter.IsFalse catcher.Fired, "NaiveCounterTest.TestUnsubscribe", "Event should not fire after unsubscribe"
End Sub

Private Sub TestIncrementLessThanOne()
    Set m_counter = New NaiveCounter
    m_counter.Init "Test", 5

    m_counter.Add 0  ' Should treat as Add(1)
    m_asserter.AreEqual 1&, m_counter.Current, "NaiveCounterTest.TestIncrementLessThanOne", "Add(0) should increment by 1"

    m_counter.Add -5  ' Should treat as Add(1)
    m_asserter.AreEqual 2&, m_counter.Current, "NaiveCounterTest.TestIncrementLessThanOne", "Add(-5) should increment by 1"
End Sub
