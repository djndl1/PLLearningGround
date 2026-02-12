Attribute VB_Name = "Arrays"
Option Explicit

Public Function GetArrayLength(ByRef arr As Variant) As Long
    GetArrayLength = UBound(arr) - LBound(arr) + 1
End Function

Public Sub ResizeArray(ByRef arr As Variant, ByVal newSize As Long)
    Dim l, u As Long
    l = LBound(arr)
    u = l + newSize - 1
    ReDim Preserve arr(u)
End Sub