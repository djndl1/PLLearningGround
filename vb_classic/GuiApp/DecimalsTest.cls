VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DecimalsTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Private Sub RoundToZeroTest()
        Dim before As Variant, rounded As Variant
        before = Array(CDec(1.5), CDec(1.1), CDec(2.5), CDec(3.1), _
                        CDec(0.1), CDec(0.6), CDec(-0.5), CDec(-0.6))
        rounded = Array(CDec(1), CDec(1), CDec(2), CDec(3), _
                        CDec(0), CDec(0), CDec(0), CDec(0))

        Dim i As Integer, result As Variant, expected As Variant, unrounded As Variant
        For i = LBound(before) To UBound(before)
                unrounded = before(i)
                result = Decimals.RoundToZero(unrounded)
                expected = rounded(i)
                Call m_asserter.IsTrue(result = expected, "DecimalsTest.RoundToZeroTest", _
                        unrounded & " rounds to " & expected)
        Next

End Sub

Public Sub RunTest(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
        Call RoundToZeroTest
End Sub
