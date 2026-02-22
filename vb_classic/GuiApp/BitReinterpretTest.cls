VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BitReinterpretTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

' Run executes all test methods in this test class.
' Args:
'   myasserter (Asserter): The asserter instance to use for test assertions.
Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestSingleToLong
    TestLongToSingle
    TestSpecialFloatValues
    TestRoundTripConversion
End Sub

' TestSingleToLong tests the AsLong function with various Single values.
Private Sub TestSingleToLong()
    Dim result As Long

    ' Test case: 0.0f -> 0
    result = BitReinterpret.AsLong(0!)
    m_asserter.AreEqual 0&, result, "BitReinterpretTest.TestSingleToLong", "0.0 -> 0, actual=" & result

    ' Test case: -678901.531f -> -920273064
    result = BitReinterpret.AsLong(-678901.5!)
    m_asserter.AreEqual -920273064, result, "BitReinterpretTest.TestSingleToLong", "-678901.531 -> -920273064, actual=" & result

    ' Test case: 1.0f -> 1065353216
    result = BitReinterpret.AsLong(1!)
    m_asserter.AreEqual 1065353216, result, "BitReinterpretTest.TestSingleToLong", "1.0 -> 1065353216, actual=" & result

    ' Test case: -1.0f -> -1082130432
    result = BitReinterpret.AsLong(-1!)
    m_asserter.AreEqual -1082130432, result, "BitReinterpretTest.TestSingleToLong", "-1.0 -> -1082130432, actual=" & result

    ' Test case: 3.1415927f -> 1078530011
    result = BitReinterpret.AsLong(3.1415927!)
    m_asserter.AreEqual 1078530011, result, "BitReinterpretTest.TestSingleToLong", "3.1415927 -> 1078530011, actual=" & result
End Sub

' TestLongToSingle tests the AsSingle function with various Long values.
Private Sub TestLongToSingle()
    Dim result As Single

    ' Test case: 0 -> 0.0f
    result = BitReinterpret.AsSingle(0&)
    m_asserter.AreEqual 0!, result, "BitReinterpretTest.TestLongToSingle", "0 -> 0.0, actual=" & result

    ' Test case: -920273064 -> -678901.531f
    result = BitReinterpret.AsSingle(-920273064)
    m_asserter.IsTrue Abs(result - (-678901.5!)) < 0.01, "BitReinterpretTest.TestLongToSingle", "-920273064 -> -678901.531, actual=" & result

    ' Test case: 1065353216 -> 1.0f
    result = BitReinterpret.AsSingle(1065353216)
    m_asserter.AreEqual 1!, result, "BitReinterpretTest.TestLongToSingle", "1065353216 -> 1.0, actual=" & result

    ' Test case: -1082130432 -> -1.0f
    result = BitReinterpret.AsSingle(-1082130432)
    m_asserter.AreEqual -1!, result, "BitReinterpretTest.TestLongToSingle", "-1082130432 -> -1.0, actual=" & result

    ' Test case: 1078530011 -> 3.1415927f
    result = BitReinterpret.AsSingle(1078530011)
    m_asserter.IsTrue Abs(result - 3.1415927!) < 0.0000001, "BitReinterpretTest.TestLongToSingle", "1078530011 -> 3.1415927, actual=" & result
End Sub

' TestSpecialFloatValues tests the bit reinterpretation with special floating-point values.
Private Sub TestSpecialFloatValues()
    Dim result As Long
    Dim floatResult As Single

    ' Test case: Positive infinity (using known bit pattern)
    ' Instead of division by zero, use the known IEEE 754 bit pattern for +Infinity
    result = BitReinterpret.AsLong(BitReinterpret.AsSingle(CLng(&H7F800000)))
    m_asserter.AreEqual CLng(&H7F800000), result, "BitReinterpretTest.TestSpecialFloatValues", "+Infinity -> 0x7F800000, actual=" & Hex(result)

    ' Test case: Negative infinity (using known bit pattern)
    ' Instead of division by zero, use the known IEEE 754 bit pattern for -Infinity
    result = BitReinterpret.AsLong(BitReinterpret.AsSingle(CLng(&HFF800000)))
    m_asserter.AreEqual CLng(&HFF800000), result, "BitReinterpretTest.TestSpecialFloatValues", "-Infinity -> 0xFF800000, actual=" & Hex(result)

    ' Test case: NaN (Not a Number) (using known bit pattern)
    ' Use a known NaN bit pattern (exponent all 1s, significand non-zero)
    result = BitReinterpret.AsLong(BitReinterpret.AsSingle(CLng(&H7FFFFFFF)))
    Call m_asserter.IsTrue((result And CLng(&H7F800000)) = CLng(&H7F800000), "BitReinterpretTest.TestSpecialFloatValues", "NaN has exponent bits set, actual=" & Hex(result) & ", exponent bits=" & Hex(result And CLng(&H7F800000)))
    Call m_asserter.IsTrue((result And CLng(&H7FFFFF)) <> 0, "BitReinterpretTest.TestSpecialFloatValues", "NaN has non-zero significand, actual=" & Hex(result) & ", significand=" & Hex(result And CLng(&H7FFFFF)))

    ' Test case: Convert infinity bit pattern back to float
    floatResult = BitReinterpret.AsSingle(CLng(&H7F800000))
    ' Check if the float value is infinite by testing the bit pattern
    Dim floatAsLong As Long
    floatAsLong = BitReinterpret.AsLong(floatResult)
    m_asserter.IsTrue floatAsLong = CLng(&H7F800000), "BitReinterpretTest.TestSpecialFloatValues", "0x7F800000 -> +Infinity, actual=" & Hex(floatAsLong)

    floatResult = BitReinterpret.AsSingle(CLng(&HFF800000))
    floatAsLong = BitReinterpret.AsLong(floatResult)
    m_asserter.IsTrue floatAsLong = CLng(&HFF800000), "BitReinterpretTest.TestSpecialFloatValues", "0xFF800000 -> -Infinity, actual=" & Hex(floatAsLong)
End Sub

' TestRoundTripConversion tests that converting back and forth preserves the bit pattern.
Private Sub TestRoundTripConversion()
    Dim originalFloat As Single
    Dim intermediateLong As Long
    Dim finalFloat As Single

    ' Test case: Normal positive number
    originalFloat = 123.456!
    intermediateLong = BitReinterpret.AsLong(originalFloat)
    finalFloat = BitReinterpret.AsSingle(intermediateLong)
    m_asserter.AreEqual originalFloat, finalFloat, "BitReinterpretTest.TestRoundTripConversion", "Round trip: 123.456, original=" & originalFloat & ", final=" & finalFloat

    ' Test case: Normal negative number
    originalFloat = -987.654!
    intermediateLong = BitReinterpret.AsLong(originalFloat)
    finalFloat = BitReinterpret.AsSingle(intermediateLong)
    m_asserter.AreEqual originalFloat, finalFloat, "BitReinterpretTest.TestRoundTripConversion", "Round trip: -987.654, original=" & originalFloat & ", final=" & finalFloat

    ' Test case: Zero
    originalFloat = 0!
    intermediateLong = BitReinterpret.AsLong(originalFloat)
    finalFloat = BitReinterpret.AsSingle(intermediateLong)
    m_asserter.AreEqual originalFloat, finalFloat, "BitReinterpretTest.TestRoundTripConversion", "Round trip: 0.0, original=" & originalFloat & ", final=" & finalFloat

    ' Test case: Very small number
    originalFloat = 1.175494E-38!   ' Smallest normalized single
    intermediateLong = BitReinterpret.AsLong(originalFloat)
    finalFloat = BitReinterpret.AsSingle(intermediateLong)
    m_asserter.AreEqual originalFloat, finalFloat, "BitReinterpretTest.TestRoundTripConversion", "Round trip: 1.1754944E-38, original=" & originalFloat & ", final=" & finalFloat

    ' Test case: Very large number
    originalFloat = 3.402823E+38!   ' Largest normalized single
    intermediateLong = BitReinterpret.AsLong(originalFloat)
    finalFloat = BitReinterpret.AsSingle(intermediateLong)
    m_asserter.AreEqual originalFloat, finalFloat, "BitReinterpretTest.TestRoundTripConversion", "Round trip: 3.4028235E+38, original=" & originalFloat & ", final=" & finalFloat
End Sub


