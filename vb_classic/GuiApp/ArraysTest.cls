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
    TestToZeroBased
    TestToOneBased
    TestFlatten
    TestAssignFrom
    TestGetRow
    TestSetRow
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
        expectedValue = IIf(i < 3, i, 0)
        m_asserter.IsTrue a(i) = expectedValue, "ArraysTest.TestResizeArray", "a(" & i & ") = " & a(i) & " expectedValue = " & expectedValue
    Next
End Sub

Private Sub TestToZeroBased()
    Dim arr() As Long
    Dim result As Variant
    Dim i As Long
    
    ' Test: 1-based array to zero-based
    ReDim arr(1 To 5)
    For i = 1 To 5
        arr(i) = i * 10
    Next i
    
    result = Arrays.ToZeroBased(arr)
    
    m_asserter.IsTrue LBound(result) = 0, "ArraysTest.TestToZeroBased", "Result should be zero-based"
    m_asserter.IsTrue UBound(result) = 4, "ArraysTest.TestToZeroBased", "Result should have 5 elements"
    m_asserter.IsTrue result(0) = 10, "ArraysTest.TestToZeroBased", "result(0) should be 10"
    m_asserter.IsTrue result(4) = 50, "ArraysTest.TestToZeroBased", "result(4) should be 50"
End Sub

Private Sub TestToOneBased()
    Dim arr() As Long
    Dim result As Variant
    Dim i As Long
    
    ' Test: zero-based array to one-based
    ReDim arr(0 To 4)
    For i = 0 To 4
        arr(i) = i * 10
    Next i
    
    result = Arrays.ToOneBased(arr)
    
    m_asserter.IsTrue LBound(result) = 1, "ArraysTest.TestToOneBased", "Result should be one-based"
    m_asserter.IsTrue UBound(result) = 5, "ArraysTest.TestToOneBased", "Result should have 5 elements"
    m_asserter.IsTrue result(1) = 0, "ArraysTest.TestToOneBased", "result(1) should be 0"
    m_asserter.IsTrue result(5) = 40, "ArraysTest.TestToOneBased", "result(5) should be 40"
End Sub

Private Sub TestFlatten()
    Dim arr(0 To 2, 0 To 3) As Long
    Dim result As Variant
    Dim r As Long
    Dim c As Long
    Dim expectedIndex As Long
    
    ' Create 2D array with values 0 to 11
    expectedIndex = 0
    For r = 0 To 2
        For c = 0 To 3
            arr(r, c) = expectedIndex
            expectedIndex = expectedIndex + 1
        Next c
    Next r
    
    result = Arrays.Flatten(arr)
    
    m_asserter.IsTrue LBound(result) = 0, "ArraysTest.TestFlatten", "Result should be zero-based"
    m_asserter.IsTrue Arrays.GetArrayLength(result) = 12, "ArraysTest.TestFlatten", "Result should have 12 elements"
    
    ' Verify row-major order
    For r = 0 To 2
        For c = 0 To 3
            expectedIndex = r * 4 + c
            m_asserter.IsTrue result(expectedIndex) = expectedIndex, "ArraysTest.TestFlatten", "result(" & expectedIndex & ") should be " & expectedIndex
        Next c
    Next r
End Sub

Private Sub TestAssignFrom()
    Dim arr(0 To 2, 0 To 3) As Long
    Dim source(0 To 11) As Long
    Dim i As Long
    
    ' Create source array with values 0 to 11
    For i = 0 To 11
        source(i) = i
    Next i
    
    Call Arrays.AssignFrom(arr, source)
    
    ' Verify values were assigned in row-major order
    Dim expectedValue As Long
    expectedValue = 0
    Dim r As Long
    Dim c As Long
    For r = 0 To 2
        For c = 0 To 3
            m_asserter.IsTrue arr(r, c) = expectedValue, "ArraysTest.TestAssignFrom", "arr(" & r & "," & c & ") should be " & expectedValue
            expectedValue = expectedValue + 1
        Next c
    Next r
End Sub

Private Sub TestGetRow()
    Dim arr(0 To 2, 0 To 3) As Long
    Dim result As Variant
    Dim r As Long
    Dim c As Long
    
    ' Create 2D array
    For r = 0 To 2
        For c = 0 To 3
            arr(r, c) = r * 10 + c
        Next c
    Next r
    
    ' Get row 1 (second row)
    result = Arrays.GetRow(arr, 1)
    
    m_asserter.IsTrue LBound(result) = 0, "ArraysTest.TestGetRow", "Result should be zero-based"
    m_asserter.IsTrue Arrays.GetArrayLength(result) = 4, "ArraysTest.TestGetRow", "Result should have 4 elements"
    m_asserter.IsTrue result(0) = 10, "ArraysTest.TestGetRow", "result(0) should be 10"
    m_asserter.IsTrue result(1) = 11, "ArraysTest.TestGetRow", "result(1) should be 11"
    m_asserter.IsTrue result(2) = 12, "ArraysTest.TestGetRow", "result(2) should be 12"
    m_asserter.IsTrue result(3) = 13, "ArraysTest.TestGetRow", "result(3) should be 13"
End Sub

Private Sub TestSetRow()
    Dim arr(0 To 2, 0 To 3) As Long
    Dim row(0 To 3) As Long
    Dim r As Long
    
    ' Create target array
    r = 0
    arr(r, 0) = 0: arr(r, 1) = 0: arr(r, 2) = 0: arr(r, 3) = 0
    r = 1
    arr(r, 0) = 0: arr(r, 1) = 0: arr(r, 2) = 0: arr(r, 3) = 0
    r = 2
    arr(r, 0) = 0: arr(r, 1) = 0: arr(r, 2) = 0: arr(r, 3) = 0
    
    ' Create row to set
    row(0) = 100: row(1) = 101: row(2) = 102: row(3) = 103
    
    ' Set row 1 (second row)
    Call Arrays.SetRow(arr, 1, row)
    
    ' Verify row was set
    m_asserter.IsTrue arr(0, 0) = 0, "ArraysTest.TestSetRow", "arr(0,0) should be 0"
    m_asserter.IsTrue arr(1, 0) = 100, "ArraysTest.TestSetRow", "arr(1,0) should be 100"
    m_asserter.IsTrue arr(1, 1) = 101, "ArraysTest.TestSetRow", "arr(1,1) should be 101"
    m_asserter.IsTrue arr(1, 2) = 102, "ArraysTest.TestSetRow", "arr(1,2) should be 102"
    m_asserter.IsTrue arr(1, 3) = 103, "ArraysTest.TestSetRow", "arr(1,3) should be 103"
    m_asserter.IsTrue arr(2, 0) = 0, "ArraysTest.TestSetRow", "arr(2,0) should be 0"
End Sub
