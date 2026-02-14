VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSlice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_slice As ArraySlice

Public Sub FromEmpty()
    ReDim arr(0) As Variant
    m_slice.m_ArrayData = arr
    m_slice.m_Length = 0
    m_slice.m_Start = LBound(arr)
End Sub

Public Sub Of(ByRef arr As Variant)
    m_slice = Arrays.SliceOf(arr)
End Sub

Public Sub From(ByRef arr As Variant, ByVal startIndex As Long, ByVal length As Long)
    m_slice = Arrays.SliceFrom(arr, startIndex, length)
End Sub

Public Sub Between(ByRef arr As Variant, ByVal startIndex As Long, ByVal endIndex As Long)
    m_slice = Arrays.SliceBetween(arr, startIndex, endIndex)
End Sub

Public Property Get Length() As Long
    Length = Arrays.SliceLength(m_slice)
End Property

Public Property Get Capacity() As Long
    Capacity = Arrays.SliceCapacity(m_slice)
End Property

Public Sub Append(value As Variant)
    Call Arrays.SliceAppend(m_slice, value)
End Sub

Public Property Get Item(index As Long) As Variant
    Item = Arrays.SliceGet(m_slice, index)
End Property

Public Property Let Item(index As Long, value As Variant)
    Call Arrays.SliceSet(m_slice, index, value)
End Property

Public Property Set Item(index As Long, value As Object)
    Call Arrays.SliceSet(m_slice, index, value)
End Property

Public Sub Insert(index As Long, value As Variant)
    Call Arrays.SliceInsert(m_slice, index, value)
End Sub

Public Sub Delete(index As Long)
    Call Arrays.SliceDelete(m_slice, index)
End Sub

Public Sub Clear()
    Call Arrays.SliceClear(m_slice)
End Sub

Public Sub Reserve(capacity As Long)
    Call Arrays.SliceReserve(m_slice, capacity)
End Sub

Public Function ToArray() As Variant
    Dim i As Long
    Dim result() As Variant
    ReDim result(Me.Length - 1)
    For i = 0 To Me.Length - 1
        result(i) = Me.Item(i)
    Next i
    ToArray = result
End Function