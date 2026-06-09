VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTimeSpanTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestZero
    TestProperties
    TestArithmetic
    TestComparison
    TestToString
End Sub

Private Sub TestZero()
    Dim factory As New CTimeSpanFactory
    Dim zero As CTimeSpan
    Set zero = factory.Zero()
    m_asserter.AreEqual zero.Ticks, CDec(0), "CTimeSpanTest.TestZero", "Zero should have 0 ticks"
    m_asserter.AreEqual zero.Days, 0, "CTimeSpanTest.TestZero", "Zero days"
    m_asserter.AreEqual zero.Hours, 0, "CTimeSpanTest.TestZero", "Zero hours"
    m_asserter.IsTrue zero.Equals(zero), "CTimeSpanTest.TestZero", "Zero equals itself"
End Sub

Private Sub TestProperties()
    Dim factory As New CTimeSpanFactory
    ' 1 day + 2h + 3m + 4s + 500ms + 600us + 7 (hundred-ns) = ticks
    Dim ts As CTimeSpan
    Set ts = factory.FromDays(1).Add(factory.FromHours(2)).Add(factory.FromMinutes(3)).Add(factory.FromSeconds(4)).Add(factory.FromMillis(500)).Add(factory.FromMicros(600))

    m_asserter.AreEqual ts.Days, 1, "CTimeSpanTest.TestProperties", "Days should be 1"
    m_asserter.AreEqual ts.Hours, 2, "CTimeSpanTest.TestProperties", "Hours should be 2"
    m_asserter.AreEqual ts.Minutes, 3, "CTimeSpanTest.TestProperties", "Minutes should be 3"
    m_asserter.AreEqual ts.Seconds, 4, "CTimeSpanTest.TestProperties", "Seconds should be 4"
    m_asserter.AreEqual ts.Milliseconds, 500, "CTimeSpanTest.TestProperties", "Milliseconds should be 500"
    m_asserter.AreEqual ts.Microseconds, 600, "CTimeSpanTest.TestProperties", "Microseconds should be 600"

    ' Totals are doubles
    m_asserter.IsTrue ts.TotalDays > 1.0 And ts.TotalDays < 1.1, "CTimeSpanTest.TestProperties", "TotalDays ~ 1.1"
    m_asserter.IsTrue ts.TotalHours > 26.0 And ts.TotalHours < 27.0, "CTimeSpanTest.TestProperties", "TotalHours ~ 26"

    ' Negative TimeSpan: -1.5 days -> Days=-1, Hours=-12
    Dim neg As CTimeSpan
    Set neg = factory.FromDays(-1.5)
    m_asserter.AreEqual neg.Days, -1, "CTimeSpanTest.TestProperties", "Negative: -1.5 days, Days=-1"
    m_asserter.AreEqual neg.Hours, -12, "CTimeSpanTest.TestProperties", "Negative: -1.5 days, Hours=-12"
End Sub

Private Sub TestArithmetic()
    Dim factory As New CTimeSpanFactory
    Dim a As CTimeSpan
    Dim b As CTimeSpan
    Set a = factory.FromHours(2)
    Set b = factory.FromMinutes(30)

    ' Add
    Dim sum As CTimeSpan
    Set sum = a.Add(b)
    m_asserter.IsTrue sum.TotalMinutes - 150 < 0.0001, "CTimeSpanTest.TestArithmetic", "2h + 30m = 150 min"

    ' Subtract
    Dim diff As CTimeSpan
    Set diff = a.Subtract(b)
    m_asserter.IsTrue diff.TotalMinutes - 90 < 0.0001, "CTimeSpanTest.TestArithmetic", "2h - 30m = 90 min"

    ' Negate
    Dim negA As CTimeSpan
    Set negA = a.Negate()
    m_asserter.IsTrue negA.TotalHours + 2 < 0.0001, "CTimeSpanTest.TestArithmetic", "-2h"

    ' Duration = abs value
    Dim negDur As CTimeSpan
    Set negDur = negA.Duration()
    m_asserter.IsTrue negDur.TotalHours - 2 < 0.0001, "CTimeSpanTest.TestArithmetic", "|-2h| = 2h"

    ' Multiply
    Dim doubled As CTimeSpan
    Set doubled = a.Multiply(2)
    m_asserter.IsTrue doubled.TotalHours - 4 < 0.0001, "CTimeSpanTest.TestArithmetic", "2h * 2 = 4h"

    ' Divide by scalar
    Dim half As CTimeSpan
    Set half = a.Divide(2)
    m_asserter.IsTrue half.TotalHours - 1 < 0.0001, "CTimeSpanTest.TestArithmetic", "2h / 2 = 1h"

    ' DivideBy returns ratio
    Dim ratio As Double
    ratio = a.DivideBy(b)
    m_asserter.IsTrue ratio - 4 < 0.0001, "CTimeSpanTest.TestArithmetic", "2h / 30m = 4"
End Sub

Private Sub TestComparison()
    Dim factory As New CTimeSpanFactory
    Dim a As CTimeSpan
    Dim b As CTimeSpan
    Dim c As CTimeSpan
    Set a = factory.FromHours(1)
    Set b = factory.FromHours(2)
    Set c = factory.FromHours(1)

    m_asserter.IsTrue a.Equals(c), "CTimeSpanTest.TestComparison", "1h == 1h"
    m_asserter.IsTrue a.NotEquals(b), "CTimeSpanTest.TestComparison", "1h != 2h"
    m_asserter.IsTrue a.IsLessThan(b), "CTimeSpanTest.TestComparison", "1h < 2h"
    m_asserter.IsTrue a.IsLessThanOrEqualTo(c), "CTimeSpanTest.TestComparison", "1h <= 1h"
    m_asserter.IsTrue b.IsGreaterThan(a), "CTimeSpanTest.TestComparison", "2h > 1h"
    m_asserter.IsTrue b.IsGreaterThanOrEqualTo(c), "CTimeSpanTest.TestComparison", "2h >= 1h"
    m_asserter.AreEqual a.CompareTo(b), -1, "CTimeSpanTest.TestComparison", "1h.CompareTo(2h) = -1"
    m_asserter.AreEqual b.CompareTo(a), 1, "CTimeSpanTest.TestComparison", "2h.CompareTo(1h) = +1"
    m_asserter.AreEqual a.CompareTo(c), 0, "CTimeSpanTest.TestComparison", "1h.CompareTo(1h) = 0"
End Sub

Private Sub TestToString()
    Dim factory As New CTimeSpanFactory
    Dim ts As CTimeSpan
    Set ts = factory.FromDays(2).Add(factory.FromHours(3))
    Dim s As String
    s = ts.ToString()
    m_asserter.IsTrue Len(s) > 0, "CTimeSpanTest.TestToString", "ToString returns non-empty"
    ' Hash should be stable
    m_asserter.AreEqual ts.Hash, ts.Hash, "CTimeSpanTest.TestToString", "Hash is stable"
End Sub
