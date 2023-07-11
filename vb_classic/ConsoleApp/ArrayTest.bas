Option Explicit

Public Sub Run()
   FixedArrayTest
   DynamicArrayTest
   ArrayBoundaryTest
End Sub

Private Sub FixedArrayTest()
   Dim fixed(0 To 5) As Long ' not of 5 elements but 6
   ' or
   Dim fixed2(5) As Long' not of 5 elements but 6

   Dim i As Long
   For i = 0 To 6
      fixed(i) = i
      fixed2(i) = i * 2
   Next

   Dim fixed3 As Variant
   fixed3 = Array(0, 1, 2, 3, 4, 5)

   For i = 0 To 6
      AssertThat.IsTrue fixed(i) = i, "Array(i) = " & i
      AssertThat.IsTrue fixed2(i) = i * 2, "Array(i) = " & (i * 2)
      AssertThat.IsTrue fixed3(i) = i, "Array(i) = " & i
   Next
End Sub

Private Sub DynamicArrayTest()
   Dim dynArray() As Long ' dynamic array declaration only
   ReDim dynArray(10) ' actual allocation and definition

   Dim l As Long
   l = UBound(dynArray) - LBound(dynArray) + 1
   AssertThat.IsTrue l = 11, "DynamicArray should be of length 10"
End Sub

Private Sub ArrayBoundaryTest()
   ReDim arr(1 To 10) As Long ' dynamic array definition

   Dim i As Long
   For i = 1 To 10
      arr(i) = i * 2
   Next

   AssertThat.IsTrue LBound(arr) = 1, "LBound = 1"
   AssertThat.IsTrue UBound(arr) = 10, "UBound = 10"
End Sub
