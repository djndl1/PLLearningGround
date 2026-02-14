VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSliceTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestOf
    TestFrom
    TestBetween
    TestFromEmpty
End Sub

Private Sub TestOf()
    Dim arr(5) As Long
    Dim i As Long
    For i = 0 To 5
        arr(i) = i * 10
    Next i
    
    Dim slice As CSlice
    Set slice = New CSlice
    slice.Of arr
    
    m_asserter.IsTrue slice.Length = 6, "CSliceTest.TestOf", "Length should be 6"
    m_asserter.IsTrue slice.Item(0) = 0, "CSliceTest.TestOf", "First element should be 0"
    m_asserter.IsTrue slice.Item(5) = 50, "CSliceTest.TestOf", "Last element should be 50"
End Sub

Private Sub TestFrom()
    Dim arr(10) As Long
    Dim i As Long
    For i = 0 To 10
        arr(i) = i * 10
    Next i
    
    Dim slice As CSlice
    Set slice = New CSlice
    slice.From arr, 2, 5
    
    m_asserter.IsTrue slice.Length = 5, "CSliceTest.TestFrom", "Length should be 5"
    m_asserter.IsTrue slice.Item(0) = 20, "CSliceTest.TestFrom", "First element should be 20"
    m_asserter.IsTrue slice.Item(4) = 60, "CSliceTest.TestFrom", "Last element should be 60"
End Sub

Private Sub TestBetween()
    Dim arr(10) As Long
    Dim i As Long
    For i = 0 To 10
        arr(i) = i * 10
    Next i
    
    Dim slice As CSlice
    Set slice = New CSlice
    slice.Between arr, 3, 8
    
    m_asserter.IsTrue slice.Length = 5, "CSliceTest.TestBetween", "Length should be 5"
    m_asserter.IsTrue slice.Item(0) = 30, "CSliceTest.TestBetween", "First element should be 30"
    m_asserter.IsTrue slice.Item(4) = 70, "CSliceTest.TestBetween", "Last element should be 70"
End Sub

Private Sub TestFromEmpty()
    Dim slice As CSlice
    Set slice = New CSlice
    slice.FromEmpty
    
    m_asserter.IsTrue slice.Length = 0, "CSliceTest.TestFromEmpty", "Length should be 0"
    slice.Append 42
    m_asserter.IsTrue slice.Length = 1, "CSliceTest.TestFromEmpty", "Length should be 1 after append"
    m_asserter.IsTrue slice.Item(0) = 42, "CSliceTest.TestFromEmpty", "Appended element should be 42"
End Sub