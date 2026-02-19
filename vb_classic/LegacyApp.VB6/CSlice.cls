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
Attribute VB_Exposed = True
Option Explicit

Private m_slice As ArraySlice

Public Sub FromEmpty()
Attribute FromEmpty.VB_Description = "Initializes the slice as an empty array.\r\nCreates an underlying array with capacity for one element but sets the slice length to zero."
    ReDim arr(0) As Variant
    m_slice.m_ArrayData = arr
    m_slice.m_Length = 0
    m_slice.m_Start = LBound(arr)
End Sub

Public Sub Of(ByRef arr As Variant)
Attribute Of.VB_Description = "Initializes the slice to represent the entire array.\r\nThe slice will have the same bounds and length as the original array.\r\nArgs:\r\n  arr (Variant): The array to create a slice from."
    m_slice = Arrays.SliceOf(arr)
End Sub

Public Sub From(ByRef arr As Variant, ByVal startIndex As Long, ByVal Length As Long)
Attribute From.VB_Description = "Initializes the slice to represent a portion of the array.\r\nThe slice will start at the given index and span the specified length.\r\nArgs:\r\n  arr (Variant): The source array to create a slice from.\r\n  startIndex (Long): The starting index of the slice in the array.\r\n  length (Long): The number of elements to include in the slice."
    m_slice = Arrays.SliceFrom(arr, startIndex, Length)
End Sub

Public Sub Between(ByRef arr As Variant, ByVal startIndex As Long, ByVal endIndex As Long)
Attribute Between.VB_Description = "Initializes the slice to represent a portion of the array.\r\nThe slice will start at the given start index and end at the given end index (exclusive).\r\nArgs:\r\n  arr (Variant): The source array to create a slice from.\r\n  startIndex (Long): The starting index of the slice in the array (inclusive).\r\n  endIndex (Long): The ending index of the slice in the array (exclusive)."
    m_slice = Arrays.SliceBetween(arr, startIndex, endIndex)
End Sub

Public Property Get Length() As Long
Attribute Length.VB_Description = "Returns the number of elements in the slice.\r\nReturns:\r\n  Long: The number of elements currently in the slice."
    Length = Arrays.SliceLength(m_slice)
End Property

Public Property Get capacity() As Long
Attribute capacity.VB_Description = "Returns the underlying capacity of the slice.\r\nThis is the maximum number of elements the slice can hold without resizing.\r\nReturns:\r\n  Long: The capacity of the slice."
    capacity = Arrays.SliceCapacity(m_slice)
End Property

Public Sub Append(ByVal value As Variant)
Attribute Append.VB_Description = "Appends an element at the end of the slice.\r\nThe slice will be automatically resized if necessary.\r\nArgs:\r\n  value (Variant): The value to append to the slice."
    Call Arrays.SliceAppend(m_slice, value)
End Sub

Public Property Get Item(ByVal index As Long) As Variant
Attribute Item.VB_Description = "Gets the element at the specified index in the slice.\r\nArgs:\r\n  index (Long): The zero-based index of the element to get.\r\nReturns:\r\n  Variant: The element at the specified index."
    Item = Arrays.SliceGet(m_slice, index)
End Property

Public Property Let Item(ByVal index As Long, ByVal value As Variant)
Attribute Item.VB_Description = "Sets the value of the element at the specified index in the slice.\r\nArgs:\r\n  index (Long): The zero-based index of the element to set.\r\n  value (Variant): The value to set at the specified index."
    Call Arrays.SliceSet(m_slice, index, value)
End Property

Public Property Set Item(ByVal index As Long, ByVal value As Object)
Attribute Item.VB_Description = "Sets an object reference at the specified index in the slice.\r\nArgs:\r\n  index (Long): The zero-based index of the element to set.\r\n  value (Object): The object reference to set at the specified index."
    Call Arrays.SliceSet(m_slice, index, value)
End Property

Public Sub Insert(ByVal index As Long, ByVal value As Variant)
Attribute Insert.VB_Description = "Inserts an element at the specified index in the slice.\r\nExisting elements from the insertion point onward are shifted to make room.\r\nArgs:\r\n  index (Long): The zero-based index at which to insert the element.\r\n  value (Variant): The value to insert."
    Call Arrays.SliceInsert(m_slice, index, value)
End Sub

Public Sub Delete(ByVal index As Long)
Attribute Delete.VB_Description = "Deletes the element at the specified index from the slice.\r\nElements after the deletion point are shifted to fill the gap.\r\nArgs:\r\n  index (Long): The zero-based index of the element to delete."
    Call Arrays.SliceDelete(m_slice, index)
End Sub

Public Sub Clear()
Attribute Clear.VB_Description = "Removes all elements from the slice.\r\nThe slice length becomes zero but the underlying capacity is preserved."
    Call Arrays.SliceClear(m_slice)
End Sub

Public Sub Reserve(ByVal capacity As Long)
Attribute Reserve.VB_Description = "Reserves enough capacity for the specified number of elements.\r\nThis can improve performance when you know how many elements will be added.\r\nArgs:\r\n  capacity (Long): The minimum capacity to reserve."
    Call Arrays.SliceReserve(m_slice, capacity)
End Sub

Public Function ToArray() As Variant
Attribute ToArray.VB_Description = "Converts the slice to a standard VB array.\r\nReturns:\r\n  Variant: A new array containing all elements of the slice."
    Dim i As Long
    Dim result() As Variant
    ReDim result(Me.Length - 1)
    For i = 0 To Me.Length - 1
        result(i) = Me.Item(i)
    Next i
    ToArray = result
End Function
