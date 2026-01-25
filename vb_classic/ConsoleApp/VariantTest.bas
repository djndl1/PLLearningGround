Attribute VB_Name = "VariantTest"
Option Explicit

Public Sub Run()
   EqvTest
   DefaultVariantValueTest
   NullVariantTest
   EmptyCharStringVariantTest
   ErrorVariantTest
End Sub

Private Sub EqvTest()
    Console.WriteLine "EqvTest"

    Dim OneEqvOne As Integer
    OneEqvOne = 1 Eqv 1
    Console.WriteLine vbTab & "1 Eqv 1 is " & OneEqvOne
    AssertThat.IsTrue (OneEqvOne = -1), "1 Eqv 1 should be " & OneEqvOne

    Dim TwoEqvOne As Integer
    TwoEqvOne = 2 Eqv 1
    Console.WriteLine vbTab & "2 Eqv 1 is " & TwoEqvOne
    AssertThat.IsTrue (TwoEqvOne = -4), "2 Eqv 1 should be " & TwoEqvOne

    Dim TwoEqvZero As Integer
    TwoEqvZero = 2 Eqv 0
    Console.WriteLine vbTab & "2 Eqv 0 is " & TwoEqvZero
    AssertThat.IsTrue (TwoEqvZero = -3), "2 Eqv 0 should be " & TwoEqvZero

    Dim ZeroEqvZero As Integer
    ZeroEqvZero = 0 Eqv 0
    Console.WriteLine vbTab & "0 Eqv 0 is " & ZeroEqvZero
    AssertThat.IsTrue (ZeroEqvZero = -1), "0 Eqv 0 should be " & ZeroEqvZero

    AssertThat.IsTrue (True Eqv False = False), "True Eqv False should be False"
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
   Console.WriteLine "EmptyCharStringVariantTest"
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