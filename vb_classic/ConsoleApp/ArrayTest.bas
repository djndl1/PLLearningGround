Option Explicit

Private Type MyDUT
   A As Long
   B As Long
End Type


Public Sub Run()
   RedimensionPreserveTest
   FixedArrayTest
   DynamicArrayTest
   ArrayBoundaryTest
   UDTArrayTest
   ArrayInVariantTest
   ArrayAssignmentTest
   ByteArrayFromStringTest
End Sub

Private Sub FixedArrayTest()
   Console.WriteLine "FixedArrayTest Starts"
   Dim fixed(0 To 5) As Long ' not of 5 elements but 6
   ' or
   Dim fixed2(5) As Long' not of 5 elements but 6

   Dim i As Long
   For i = 0 To 5
      fixed(i) = i
      fixed2(i) = i * 2
   Next

   Dim fixed3 As Variant
   fixed3 = Array(0, 1, 2, 3, 4, 5)

   For i = 0 To 5
      AssertThat.IsTrue fixed(i) = i, "Array(i) = " & i
      AssertThat.IsTrue fixed2(i) = i * 2, "Array(i) = " & (i * 2)
      AssertThat.IsTrue fixed3(i) = i, "Array(i) = " & i
   Next

   Console.WriteLine "FixedArrayTest Ends"
End Sub

Private Sub DynamicArrayTest()
   Console.WriteLine "DynamicArrayTest"
   Dim dynArray() As Long ' dynamic array declaration only
   ReDim dynArray(10) ' actual allocation and definition

   Dim l As Long
   l = UBound(dynArray) - LBound(dynArray) + 1
   AssertThat.IsTrue l = 11, "DynamicArray should be of length 10"
End Sub

Private Sub ArrayBoundaryTest()
   Console.WriteLine "ArrayBoundaryTest"
   ReDim arr(1 To 10) As Long ' dynamic array definition

   Dim i As Long
   For i = 1 To 10
      arr(i) = i * 2
   Next

   AssertThat.IsTrue LBound(arr) = 1, "LBound = 1"
   AssertThat.IsTrue UBound(arr) = 10, "UBound = 10"
End Sub

Private Sub RedimensionPreserveTest()
   Console.WriteLine "RedimensionPreserveTest"
   Dim arr() As Long
   ReDim arr(1 To 10) As Long

   Dim i As Long
   For i = 1 To 10
      arr(i) = i * 2
   Next

   ReDim Preserve arr(1 To 5) As Long
   For i = LBound(arr) To UBound(arr)
      AssertThat.IsTrue (arr(i) = i * 2), "Value should be retained"
   Next

   ReDim arr(1 To 5, 1) As Long ' it's possible to change dimensions
   arr(1, 0) = 5
   AssertThat.isTrue arr(1, 0) = 5, ""

   Erase arr
End Sub

Private Sub UDTArrayTest()
   ReDim duts(5) AS MyDUT

   duts(1).A = 5
   duts(2).B = 5

   AssertThat.IsTrue duts(1).A = 5, "Should be 5"
   AssertThat.IsTrue duts(2).B = 5, "Should be 5"
End Sub

Private Sub ArrayInVariantTest()
   ReDim arr(5) As Long

   Dim v As Variant
   v = arr()

   v(5) = 5

   AssertThat.IsTrue v(5) = 5, "v(5) == 5"

   AssertThat.IsTrue VarType(v) = vbArray + vbLong, "Should be vbArray + vbLong"
   AssertThat.IsTrue TypeName(v) = "Long()", "should be Long()"
End Sub

Private Sub ByteArrayFromStringTest()
   Dim b() As Byte
   Dim s As String
   s = "ABC"
   b() = s

   Dim idx As Long
   For idx = LBound(b) To UBound(b)
      If idx mod 2 = 0 Then
         AssertThat.IsTrue b(idx) <> 0, "Should not be zero", "ByteArrayFromStringTest"
      End If
   next
End Sub

private Sub ArrayAssignmentTest()
   ReDim a(5) As Long

   Dim idx As Long
   For idx = 0 To 5
      a(idx) = idx
   Next

   Dim b() As Long
   b() = a()

   For idx = 0 To 5
      AssertThat.IsTrue b(idx) = idx, ""
      b(idx) = idx * 2
   Next

   ' it's copy assignment
   For idx = 0 To 5
      AssertThat.IsTrue a(idx) = idx, ""
      AssertThat.IsTrue b(idx) = idx * 2, ""
   Next
End Sub