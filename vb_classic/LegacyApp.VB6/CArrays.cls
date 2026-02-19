VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CArrays"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Public Type ArraySlice
    m_ArrayData As Variant
    m_Length As Long
    m_Start As Long
End Type

' GetArrayLength returns the number of elements in the array.
' Args:
'   arr (Variant): The array whose length is to be determined.
' Returns:
'   Long: The number of elements in the array.
Public Function GetArrayLength(ByRef arr As Variant) As Long
    GetArrayLength = UBound(arr) - LBound(arr) + 1
End Function

' ResizeArray resizes a dynamic array to the specified new size.
' The array will be resized preserving existing elements up to the new size.
' If the new size is smaller, elements beyond the new size will be lost.
' Args:
'   arr (Variant): Reference to the array to be resized.
'   newSize (Long): The new size for the array.
Public Sub ResizeArray(ByRef arr As Variant, ByVal newSize As Long)
    Dim l, u As Long
    l = LBound(arr)
    u = l + newSize - 1
    ReDim Preserve arr(u)
End Sub

' Creates an ArraySlice structure representing the entire array.
' The ArraySlice will have the same bounds and length as the original array.
' Args:
'   arr (Variant): The array to create a slice from.
' Returns:
'   ArraySlice: A slice representing the entire array.
Public Function SliceOf(ByRef arr As Variant) As ArraySlice
    Dim sls As ArraySlice
    sls.m_ArrayData = arr
    sls.m_Length = GetArrayLength(arr)
    sls.m_Start = LBound(arr)
    SliceOf = sls
End Function

' Creates an ArraySlice structure representing a portion of the array.
' The ArraySlice will start at the given index and span the specified length.
' Args:
'   arr (Variant): The source array to create a slice from.
'   startIndex (Long): The starting index of the slice in the array.
'   length (Long): The number of elements to include in the slice.
' Returns:
'   ArraySlice: A slice representing the specified portion of the array.
Public Function SliceFrom(ByRef arr As Variant, ByVal startIndex As Long, ByVal Length As Long) As ArraySlice
    Dim sls As ArraySlice
    sls.m_ArrayData = arr
    sls.m_Length = Length
    sls.m_Start = startIndex
    SliceFrom = sls
End Function

' Creates an ArraySlice structure representing a portion of the array.
' The ArraySlice will start at the given start index and end at the given end index (exclusive).
' Args:
'   arr (Variant): The source array to create a slice from.
'   startIndex (Long): The starting index of the slice in the array (inclusive).
'   endIndex (Long): The ending index of the slice in the array (exclusive).
' Returns:
'   ArraySlice: A slice representing the specified portion of the array.
Public Function SliceBetween(ByRef arr As Variant, ByVal startIndex As Long, ByVal endIndex As Long) As ArraySlice
    Dim sls As ArraySlice
    sls.m_ArrayData = arr
    sls.m_Length = endIndex - startIndex
    sls.m_Start = startIndex
    SliceBetween = sls
End Function

' Returns the underlying capacity of the slice, which is the length
' of the underlying array from the slice's starting index to the end of the array.
' Args:
'   sls (ArraySlice): The slice whose capacity should be computed.
' Returns:
'   Long: The number of elements from the slice's start index to the end of the array.
Public Function SliceCapacity(ByRef sls As ArraySlice) As Long
    SliceCapacity = GetArrayLength(sls.m_ArrayData) - (LengthBeforeStart(sls))
End Function

' Returns the length of the slice, which is the number of elements currently in use.
' Args:
'   sls (ArraySlice): The slice whose length should be returned.
' Returns:
'   Long: The number of elements in the slice.
Public Function SliceLength(ByRef sls As ArraySlice) As Long
    SliceLength = sls.m_Length
End Function

' Returns the element at the specified index within the slice.
' Args:
'   sls (ArraySlice): The slice to retrieve the element from.
'   index (Long): The zero-based index within the slice.
' Returns:
'   Variant: The element at the specified index.
Public Function SliceGet(ByRef sls As ArraySlice, ByVal index As Long) As Variant
    Dim realIndex As Long
    realIndex = sls.m_Start + index
    If IsObject(sls.m_ArrayData(realIndex)) Then
        Set SliceGet = sls.m_ArrayData(realIndex)
    Else
        SliceGet = sls.m_ArrayData(realIndex)
    End If
End Function

' Sets the element at the specified index within the slice.
' Args:
'   sls (ArraySlice): The slice to set the element in.
'   index (Long): The zero-based index within the slice.
'   value (Variant): The value to set at the specified index.
Public Sub SliceSet(ByRef sls As ArraySlice, ByVal index As Long, ByVal value As Variant)
    Dim realIndex As Long
    realIndex = sls.m_Start + index
    If IsObject(value) Then
        Set sls.m_ArrayData(realIndex) = value
    Else
        sls.m_ArrayData(realIndex) = value
    End If
End Sub

Private Function LengthBeforeStart(ByRef sls As ArraySlice) As Long
    LengthBeforeStart = sls.m_Start - LBound(sls.m_ArrayData)
End Function

' Reserves enough space for the specified capacity in the slice.
' Args:
'   sls (ArraySlice): The slice to reserve capacity for.
'   capacity (Long): The minimum capacity to reserve.
Public Sub SliceReserve(ByRef sls As ArraySlice, ByVal capacity As Long)
    If SliceCapacity(sls) >= capacity Then
        Exit Sub
    End If

    Dim newSizeOfArray As Long
    newSizeOfArray = LengthBeforeStart(sls) + capacity
    ResizeArray sls.m_ArrayData, newSizeOfArray
End Sub

Private Sub EnsureEnoughCapcityForSlice(ByRef sls As ArraySlice)
    Dim newSizeOfArray As Long
    If SliceCapacity(sls) = SliceLength(sls) Then
        newSizeOfArray = LengthBeforeStart(sls) + 2 * SliceCapacity(sls)
        ResizeArray sls.m_ArrayData, newSizeOfArray
    End If
End Sub

' Appends an element at the back of the slice.
' Args:
'   sls (ArraySlice): The slice to append to.
'   value (Variant): The value to append.
Public Sub SliceAppend(ByRef sls As ArraySlice, ByVal value As Variant)
    EnsureEnoughCapcityForSlice sls

    Dim pastEndIndex As Long
    pastEndIndex = sls.m_Start + sls.m_Length
    If IsObject(value) Then
        Set sls.m_ArrayData(pastEndIndex) = value
    Else
        sls.m_ArrayData(pastEndIndex) = value
    End If
    sls.m_Length = sls.m_Length + 1
End Sub

Public Sub SliceClear(ByRef sls As ArraySlice)
    sls.m_Length = 0
End Sub

' Deletes an element from the slice at the specified index.
' Args:
'   sls (ArraySlice): The slice to delete from.
'   index (Long): The index of the element to delete.
Public Sub SliceDelete(ByRef sls As ArraySlice, ByVal index As Long)
    Dim i As Long
    Dim sourceIndex As Long
    Dim destIndex As Long

    For i = index + 1 To sls.m_Length - 1
        sourceIndex = sls.m_Start + i
        destIndex = sls.m_Start + i - 1
        If IsObject(sls.m_ArrayData(sourceIndex)) Then
            Set sls.m_ArrayData(destIndex) = sls.m_ArrayData(sourceIndex)
        Else
            sls.m_ArrayData(destIndex) = sls.m_ArrayData(sourceIndex)
        End If
    Next i

    sls.m_Length = sls.m_Length - 1
End Sub

' Copies elements from the source slice to the destination slice.
' Args:
'   dest (ArraySlice): The destination slice to copy to.
'   source (ArraySlice): The source slice to copy from.
Public Sub SliceCopy(ByRef dest As ArraySlice, ByRef source As ArraySlice)
    Dim copyLength As Long
    Dim i As Long

    copyLength = MinLong(SliceLength(source), SliceLength(dest))

    For i = 0 To copyLength - 1
        SliceSet dest, i, SliceGet(source, i)
    Next i
End Sub

' Inserts an element into the slice at the specified index.
' Args:
'   sls (ArraySlice): The slice to insert into.
'   index (Long): The index at which to insert the element.
'   value (Variant): The value to insert.
Public Sub SliceInsert(ByRef sls As ArraySlice, ByVal index As Long, ByVal value As Variant)
    EnsureEnoughCapcityForSlice sls

    Dim i As Long
    For i = sls.m_Length - 1 To index Step -1
        If IsObject(sls.m_ArrayData(sls.m_Start + i)) Then
            Set sls.m_ArrayData(sls.m_Start + i + 1) = sls.m_ArrayData(sls.m_Start + i)
        Else
            sls.m_ArrayData(sls.m_Start + i + 1) = sls.m_ArrayData(sls.m_Start + i)
        End If
    Next i

    If IsObject(value) Then
        Set sls.m_ArrayData(sls.m_Start + index) = value
    Else
        sls.m_ArrayData(sls.m_Start + index) = value
    End If

    sls.m_Length = sls.m_Length + 1
End Sub
