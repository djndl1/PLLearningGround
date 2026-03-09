VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Arrays"
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

    copyLength = MinMax.MinLong(SliceLength(source), SliceLength(dest))

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

' Converts an array with any lower bound to a zero-based array.
' If the source array is already zero-based, returns a copy.
' Args:
'   source (Variant): The array to convert to zero-based.
' Returns:
'   Variant: A new zero-based array containing all elements from the source.
Public Function ToZeroBased(ByRef source As Variant) As Variant
    Dim lb As Long
    Dim ub As Long
    Dim length As Long
    Dim i As Long
    Dim result As Variant

    ' Check if source is an array
    Ensure.IsTrue IsArray(source), ErrorCodes.InvalidProcedureCall, "Arrays.ToZeroBased", "Source is not an array"

    ' Get bounds
    lb = LBound(source)
    ub = UBound(source)
    length = ub - lb + 1

    ' Check for multi-dimensional array
    Ensure.IsTrue GetArrayDimension(source) = 1, ErrorCodes.InvalidProcedureCall, "Arrays.ToZeroBased", "Array dimension must be 1"

    ' If already zero-based, just copy
    If lb = 0 Then
        ToZeroBased = source
        Exit Function
    End If

    ' Create new zero-based array and copy elements
    ReDim result(0 To length - 1)
    For i = 0 To length - 1
        If IsObject(source(lb + i)) Then
            Set result(i) = source(lb + i)
        Else
            result(i) = source(lb + i)
        End If
    Next i

    ToZeroBased = result
End Function

' Flattens a 2D array to a one-dimensional zero-based array.
' Elements are flattened row by row.
' Args:
'   source (Variant): The 2D array to flatten.
' Returns:
'   Variant: A one-dimensional zero-based array containing all elements.
Public Function Flatten(ByRef source As Variant) As Variant
    Dim rows As Long
    Dim cols As Long
    Dim r As Long
    Dim c As Long
    Dim result As Variant
    Dim index As Long

    ' Check if source is an array
    Ensure.IsTrue IsArray(source), ErrorCodes.InvalidProcedureCall, "Arrays.Flatten", "Source is not an array"

    rows = UBound(source, 1) - LBound(source, 1) + 1
    cols = UBound(source, 2) - LBound(source, 2) + 1

    ReDim result(0 To rows * cols - 1)

    index = 0
    For r = LBound(source, 1) To UBound(source, 1)
        For c = LBound(source, 2) To UBound(source, 2)
            If IsObject(source(r, c)) Then
                Set result(index) = source(r, c)
            Else
                result(index) = source(r, c)
            End If
            index = index + 1
        Next c
    Next r

    Flatten = result
End Function

' Assigns elements from a one-dimensional array to a 2D array.
' Elements are assigned row by row.
' Args:
'   target (Variant): The 2D array to assign elements to (passed ByRef to modify in place).
'   source (Variant): The one-dimensional array to copy from.
Public Sub AssignFrom(ByRef target As Variant, ByRef source As Variant)
    Dim rows As Long
    Dim cols As Long
    Dim r As Long
    Dim c As Long
    Dim index As Long

    ' Validate inputs
    Ensure.IsTrue IsArray(target), ErrorCodes.InvalidProcedureCall, "Arrays.AssignFrom", "Target is not an array"
    Ensure.IsTrue IsArray(source), ErrorCodes.InvalidProcedureCall, "Arrays.AssignFrom", "Source is not an array"

    rows = UBound(target, 1) - LBound(target, 1) + 1
    cols = UBound(target, 2) - LBound(target, 2) + 1

    Ensure.IsTrue UBound(source, 1) - LBound(source, 1) + 1 = rows * cols, _
        ErrorCodes.InvalidProcedureCall, "Arrays.AssignFrom", "Source array length does not match target array size"

    index = 0
    For r = LBound(target, 1) To UBound(target, 1)
        For c = LBound(target, 2) To UBound(target, 2)
            If IsObject(source(index)) Then
                Set target(r, c) = source(index)
            Else
                target(r, c) = source(index)
            End If
            index = index + 1
        Next c
    Next r
End Sub

' Gets a row from a 2D array as a one-dimensional zero-based array.
' Args:
'   source (Variant): The 2D array to get the row from.
'   rowNumber (Long): The zero-based row index.
' Returns:
'   Variant: A one-dimensional array containing the row elements.
Public Function GetRow(ByRef source As Variant, ByVal rowNumber As Long) As Variant
    Dim cols As Long
    Dim c As Long
    Dim result As Variant

    ' Validate input
    Ensure.IsTrue IsArray(source), ErrorCodes.InvalidProcedureCall, "Arrays.GetRow", "Source is not an array"

    cols = UBound(source, 2) - LBound(source, 2) + 1

    ' Adjust row number to actual bounds
    rowNumber = LBound(source, 1) + rowNumber

    ReDim result(0 To cols - 1)

    For c = 0 To cols - 1
        If IsObject(source(rowNumber, LBound(source, 2) + c)) Then
            Set result(c) = source(rowNumber, LBound(source, 2) + c)
        Else
            result(c) = source(rowNumber, LBound(source, 2) + c)
        End If
    Next c

    GetRow = result
End Function

' Sets a row in a 2D array from a one-dimensional array.
' Args:
'   target (Variant): The 2D array to set the row in.
'   rowNumber (Long): The zero-based row index.
'   row (Variant): The one-dimensional array containing the row data.
Public Sub SetRow(ByRef target As Variant, ByVal rowNumber As Long, ByRef row As Variant)
    Dim cols As Long
    Dim c As Long

    ' Validate inputs
    Ensure.IsTrue IsArray(target), ErrorCodes.InvalidProcedureCall, "Arrays.SetRow", "Target is not an array"
    Ensure.IsTrue IsArray(row), ErrorCodes.InvalidProcedureCall, "Arrays.SetRow", "Row is not an array"

    cols = UBound(target, 2) - LBound(target, 2) + 1

    Ensure.IsTrue UBound(row, 1) - LBound(row, 1) + 1 = cols, _
        ErrorCodes.InvalidProcedureCall, "Arrays.SetRow", "Row length does not match column count"

    ' Adjust row number to actual bounds
    rowNumber = LBound(target, 1) + rowNumber

    For c = 0 To cols - 1
        If IsObject(row(LBound(row, 1) + c)) Then
            Set target(rowNumber, LBound(target, 2) + c) = row(LBound(row, 1) + c)
        Else
            target(rowNumber, LBound(target, 2) + c) = row(LBound(row, 1) + c)
        End If
    Next c
End Sub

' Converts a zero-based array to a one-based array.
' VB6 arrays are naturally one-based, so this copies elements to a new one-based array.
' Args:
'   source (Variant): The zero-based array to convert.
' Returns:
'   Variant: A one-based array containing all elements from the source.
Public Function ToOneBased(ByRef source As Variant) As Variant
    Dim lb As Long
    Dim ub As Long
    Dim length As Long
    Dim i As Long
    Dim result As Variant

    ' Check if source is an array
    Ensure.IsTrue IsArray(source), ErrorCodes.InvalidProcedureCall, "Arrays.ToOneBased", "Source is not an array"

    ' Get bounds
    lb = LBound(source)
    ub = UBound(source)
    length = ub - lb + 1

    ' Check for multi-dimensional array
    Ensure.IsTrue GetArrayDimension(source) = 1, ErrorCodes.InvalidProcedureCall, "Arrays.ToOneBased", "Array must be 1-dimensional"

    ' If already one-based (lb = 1), just return copy
    If lb = 1 Then
        ToOneBased = source
        Exit Function
    End If

    ' Create new one-based array and copy elements
    ReDim result(1 To length)
    For i = 0 To length - 1
        If IsObject(source(lb + i)) Then
            Set result(i + 1) = source(lb + i)
        Else
            result(i + 1) = source(lb + i)
        End If
    Next i

    ToOneBased = result
End Function

' Gets the number of dimensions of an array.
' Args:
'   arr (Variant): The array to get the dimension count for.
' Returns:
'   Long: The number of dimensions in the array.
Private Function GetArrayDimension(ByRef arr As Variant) As Long
    Dim dimCount As Long
    Dim i As Long
    Dim tmp As Long

    On Error GoTo NotAnArray

    ' Attempt to get the UBound of each dimension
    ' If we can get UBound(1), there's at least 1 dimension
    ' Keep trying until we get an error
    dimCount = 0
    Do
        i = dimCount + 1
        tmp = UBound(arr, i)
        dimCount = i
    Loop

NotAnArray:
    GetArrayDimension = dimCount
End Function