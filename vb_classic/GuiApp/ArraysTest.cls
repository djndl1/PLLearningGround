VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ArraysTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestResizeArray
End Sub

Private Sub TestResizeArray()
    Dim i As Integer
    ReDim a(5) As Long
    For i = LBound(a) To UBound(a)
        a(i) = i
    Next

    Arrays.ResizeArray a, 3
    m_asserter.IsTrue Arrays.GetArrayLength(a) = 3, "ArraysTest.TestResizeArray", "a should have 3 elements"
    For i = LBound(a) To UBound(a)
        m_asserter.IsTrue a(i) = i, "ArraysTest.TestResizeArray", "a(" & i & ") = " & a(i)
    Next

    Arrays.ResizeArray a, 10
    m_asserter.IsTrue Arrays.GetArrayLength(a) = 10, "ArraysTest.TestResizeArray", "a should have 10 elements"
    Dim expectedValue As Long
    For i = LBound(a) To UBound(a)
        expectedValue = IIF(i < 3, i, 0)
        m_asserter.IsTrue a(i) = expectedValue, "ArraysTest.TestResizeArray", "a(" & i & ") = " & a(i) & " expectedValue = " & expectedValue
    Next
End Sub