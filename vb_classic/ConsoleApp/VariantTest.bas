Option Explicit

Public Sub Run()
   DefaultVariantValueTest
   NullVariantTest
   EmptyCharStringVariantTest
   ErrorVariantTest
End Sub

Private Sub ErrorVariantTest()
   Console.WriteLine "ErrorVariantTest"

   Dim v As Variant
   v = CVErr(15)

   AssertThat.IsTrue VarType(v) = vbError, "Variant should be Error"
   AssertThat.IsTrue IsError(v), "Variant should be Error"

End Sub

Private Sub DefaultVariantValueTest()
   Console.WriteLine "DefaultVariantTest"

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



Public Sub EmptyCharStringVariantTest()
   Console.WriteLine "ErrorVariantTest"
   Dim v As Variant

   v = vbNullChar
   AssertThat.IsTrue VarType(v) = vbString, "Variant should be String"

   v = vbNullString
   AssertThat.IsTrue VarType(v) = vbString, "Variant should be String"
End Sub



Public Sub NullVariantTest()
   Console.WriteLine "NullVariantTest"
   Dim v As Variant

   AssertThat.IsTrue VarType(v) = vbEmpty, "Variant Should be Empty"
   AssertThat.IsTrue IsEmpty(v), "Variant Should be Empty"
   v = Null

   AssertThat.IsTrue IsNull(v), "Variant Should be Empty"
   AssertThat.IsTrue VarType(v) = vbNull, "Variant Should be Null"
End Sub
