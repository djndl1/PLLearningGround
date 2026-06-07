VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSliceFactory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' CSliceFactory is the OOP factory class for CSlice. It is an instance class
' (NOT predeclared or singleton), following the FileTimeDateTimeFactory
' pattern. CSlice itself is PublicNotCreatable (Exposed and PredeclaredId
' but not Creatable) so it can only be created from a factory instance.
' Callers should use:
'   Dim factory As New CSliceFactory
'   Set slice = factory.Of(arr)
'
' The 4 factory methods mirror the 4 Friend init Subs on CSlice (FromEmpty,
' Of, From, Between) and return a fully-initialized CSlice.

Public Function FromEmpty() As CSlice
Attribute FromEmpty.VB_Description = "Creates a new CSlice initialized as an empty slice (length 0, capacity 1).\r\nReturns:\r\n  CSlice: A new empty slice."
    Dim result As New CSlice
    result.FromEmpty
    Set FromEmpty = result
End Function

Public Function Of(ByRef arr As Variant) As CSlice
Attribute Of.VB_Description = "Creates a new CSlice representing the entire array.\r\nArgs:\r\n  arr (Variant): The array to create a slice from.\r\nReturns:\r\n  CSlice: A new slice spanning the whole array."
    Dim result As New CSlice
    result.Of arr
    Set Of = result
End Function

Public Function From(ByRef arr As Variant, ByVal startIndex As Long, ByVal Length As Long) As CSlice
Attribute From.VB_Description = "Creates a new CSlice representing a portion of the array.\r\nArgs:\r\n  arr (Variant): The source array.\r\n  startIndex (Long): The starting index of the slice in the array.\r\n  length (Long): The number of elements to include in the slice.\r\nReturns:\r\n  CSlice: A new slice of the requested range."
    Dim result As New CSlice
    result.From arr, startIndex, Length
    Set From = result
End Function

Public Function Between(ByRef arr As Variant, ByVal startIndex As Long, ByVal endIndex As Long) As CSlice
Attribute Between.VB_Description = "Creates a new CSlice representing a portion of the array between two indices.\r\nArgs:\r\n  arr (Variant): The source array.\r\n  startIndex (Long): The starting index of the slice in the array (inclusive).\r\n  endIndex (Long): The ending index of the slice in the array (exclusive).\r\nReturns:\r\n  CSlice: A new slice of the requested range."
    Dim result As New CSlice
    result.Between arr, startIndex, endIndex
    Set Between = result
End Function
