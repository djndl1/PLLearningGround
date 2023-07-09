Option Explicit

Public Sub Run()
   DefaultVariantValueTest
   NullVariantTest
End Sub

Private Sub DefaultVariantValueTest()
   Dim v As Variant

   AssertThat.IsTrue IsEmpty(v), "Variant Should be empty"
   AssertThat.IsTrue VarType(v) = vbEmpty,"Variant Should be empty"

   Dim one As Long
   one = 1
   v = one
   AssertThat.IsTrue v = &1, "Should be 1"
   AssertThat.IsTrue VarType(v) = vbLong, "Should be Long"

   v = Empty
   AssertThat.IsTrue IsEmpty(v), "Variant Should be empty"
End Sub

Public Sub NullVariantTest()
   Dim v As Variant

   AssertThat.IsTrue VarType(v) = vbEmpty, "Variant Should be Empty"
   AssertThat.IsTrue IsEmpty(v), "Variant Should be Empty"
   v = Null

   AssertThat.IsTrue IsNull(v), "Variant Should be Empty"
   AssertThat.IsTrue VarType(v) = vbNull, "Variant Should be Null"
End Sub
