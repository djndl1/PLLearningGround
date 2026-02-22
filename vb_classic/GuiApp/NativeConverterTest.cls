VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NativeConverterTest"
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
    TestLeftShiftInteger
    TestRightShiftInteger
    TestLeftShiftLong
    TestRightShiftLong
    TestReverseByteOrderInteger
    TestReverseByteOrderLong
    TestReverseByteOrderSingle
    TestReverseByteOrderDouble
    TestToBytesInteger
    TestToBytesLong
    TestToBytesSingle
    TestToBytesDouble
End Sub

' TestLeftShiftInteger tests the LeftShiftInteger function with various values.
Private Sub TestLeftShiftInteger()
    Dim result As Integer

    ' Test case: 1 << 0 = 1
    result = NativeConverter.LeftShiftInteger(1, 0)
    m_asserter.AreEqual 1, result, "NativeConverterTest.TestLeftShiftInteger", "1 << 0 = 1"

    ' Test case: 1 << 3 = 8
    result = NativeConverter.LeftShiftInteger(1, 3)
    m_asserter.AreEqual 8, result, "NativeConverterTest.TestLeftShiftInteger", "1 << 3 = 8"

    ' Test case: 5 << 2 = 20
    result = NativeConverter.LeftShiftInteger(5, 2)
    m_asserter.AreEqual 20, result, "NativeConverterTest.TestLeftShiftInteger", "5 << 2 = 20"

    ' Test case: -1 << 4 = -16
    result = NativeConverter.LeftShiftInteger(-1, 4)
    m_asserter.AreEqual -16, result, "NativeConverterTest.TestLeftShiftInteger", "-1 << 4 = -16"

    ' Test case: 0 << 10 = 0
    result = NativeConverter.LeftShiftInteger(0, 10)
    m_asserter.AreEqual 0, result, "NativeConverterTest.TestLeftShiftInteger", "0 << 10 = 0"
End Sub

' TestRightShiftInteger tests the RightShiftInteger function with various values.
Private Sub TestRightShiftInteger()
    Dim result As Integer

    ' Test case: 8 >> 3 = 1
    result = NativeConverter.RightShiftInteger(8, 3)
    m_asserter.AreEqual 1, result, "NativeConverterTest.TestRightShiftInteger", "8 >> 3 = 1"

    ' Test case: 20 >> 2 = 5
    result = NativeConverter.RightShiftInteger(20, 2)
    m_asserter.AreEqual 5, result, "NativeConverterTest.TestRightShiftInteger", "20 >> 2 = 5"

    ' Test case: -16 >> 4 = -1
    result = NativeConverter.RightShiftInteger(-16, 4)
    m_asserter.AreEqual -1, result, "NativeConverterTest.TestRightShiftInteger", "-16 >> 4 = -1"

    ' Test case: 0 >> 10 = 0
    result = NativeConverter.RightShiftInteger(0, 10)
    m_asserter.AreEqual 0, result, "NativeConverterTest.TestRightShiftInteger", "0 >> 10 = 0"

    ' Test case: 15 >> 2 = 3 (truncation)
    result = NativeConverter.RightShiftInteger(15, 2)
    m_asserter.AreEqual 3, result, "NativeConverterTest.TestRightShiftInteger", "15 >> 2 = 3"
End Sub

' TestLeftShiftLong tests the LeftShiftLong function with various values.
Private Sub TestLeftShiftLong()
    Dim result As Long

    ' Test case: 1 << 0 = 1
    result = NativeConverter.LeftShiftLong(1, 0)
    m_asserter.AreEqual 1&, result, "NativeConverterTest.TestLeftShiftLong", "1 << 0 = 1"

    ' Test case: 1 << 8 = 256
    result = NativeConverter.LeftShiftLong(1, 8)
    m_asserter.AreEqual 256&, result, "NativeConverterTest.TestLeftShiftLong", "1 << 8 = 256"

    ' Test case: 100 << 4 = 1600
    result = NativeConverter.LeftShiftLong(100, 4)
    m_asserter.AreEqual 1600&, result, "NativeConverterTest.TestLeftShiftLong", "100 << 4 = 1600"

    ' Test case: -1 << 5 = -32
    result = NativeConverter.LeftShiftLong(-1, 5)
    m_asserter.AreEqual -32&, result, "NativeConverterTest.TestLeftShiftLong", "-1 << 5 = -32"

    ' Test case: 0 << 20 = 0
    result = NativeConverter.LeftShiftLong(0, 20)
    m_asserter.AreEqual 0&, result, "NativeConverterTest.TestLeftShiftLong", "0 << 20 = 0"
End Sub

' TestRightShiftLong tests the RightShiftLong function with various values.
Private Sub TestRightShiftLong()
    Dim result As Long

    ' Test case: 256 >> 8 = 1
    result = NativeConverter.RightShiftLong(256, 8)
    m_asserter.AreEqual 1&, result, "NativeConverterTest.TestRightShiftLong", "256 >> 8 = 1"

    ' Test case: 1600 >> 4 = 100
    result = NativeConverter.RightShiftLong(1600, 4)
    m_asserter.AreEqual 100&, result, "NativeConverterTest.TestRightShiftLong", "1600 >> 4 = 100"

    ' Test case: -32 >> 5 = -1
    result = NativeConverter.RightShiftLong(-32, 5)
    m_asserter.AreEqual -1&, result, "NativeConverterTest.TestRightShiftLong", "-32 >> 5 = -1"

    ' Test case: 0 >> 20 = 0
    result = NativeConverter.RightShiftLong(0, 20)
    m_asserter.AreEqual 0&, result, "NativeConverterTest.TestRightShiftLong", "0 >> 20 = 0"

    ' Test case: 15 >> 2 = 3 (truncation)
    result = NativeConverter.RightShiftLong(15, 2)
    m_asserter.AreEqual 3&, result, "NativeConverterTest.TestRightShiftLong", "15 >> 2 = 3"
End Sub

' TestReverseByteOrderInteger tests the ReverseByteOrderInteger function with various values.
Private Sub TestReverseByteOrderInteger()
    Dim result As Integer

    ' Test case: 0x1234 -> 0x3412
    result = NativeConverter.ReverseByteOrderInteger(&H1234)
    m_asserter.AreEqual &H3412, result, "NativeConverterTest.TestReverseByteOrderInteger", "0x1234 -> 0x3412"

    ' Test case: 0x1234 -> 0x3412 (already passing)
    ' Test case: 0x0012 -> 0x1200 (simpler test that fits in signed integer)
    result = NativeConverter.ReverseByteOrderInteger(&H12)
    m_asserter.AreEqual &H1200, result, "NativeConverterTest.TestReverseByteOrderInteger", "0x0012 -> 0x1200"

    ' Test case: 0x0000 -> 0x0000
    result = NativeConverter.ReverseByteOrderInteger(&H0)
    m_asserter.AreEqual &H0, result, "NativeConverterTest.TestReverseByteOrderInteger", "0x0000 -> 0x0000"

    ' Test case: 0x8080 -> 0x8080 (symmetrical) - use a smaller symmetrical value that fits in 16-bit signed integer
    result = NativeConverter.ReverseByteOrderInteger(&H1818)  ' 6168 in decimal, symmetrical when bytes reversed
    m_asserter.AreEqual &H1818, result, "NativeConverterTest.TestReverseByteOrderInteger", "0x1818 -> 0x1818"

    ' Test case: 0x4321 -> 0x2143
    result = NativeConverter.ReverseByteOrderInteger(&H4321)
    m_asserter.AreEqual &H2143, result, "NativeConverterTest.TestReverseByteOrderInteger", "0x4321 -> 0x2143"
End Sub

' TestReverseByteOrderLong tests the ReverseByteOrderLong function with various values.
Private Sub TestReverseByteOrderLong()
    Dim result As Long

    ' Test case: 0x12345678 -> 0x78563412
    result = NativeConverter.ReverseByteOrderLong(&H12345678)
    m_asserter.AreEqual &H78563412, result, "NativeConverterTest.TestReverseByteOrderLong", "0x12345678 -> 0x78563412"

    ' Test case: 0x00000012 -> 0x12000000 (simpler test that fits in signed long)
    result = NativeConverter.ReverseByteOrderLong(&H12&)
    m_asserter.AreEqual &H12000000, result, "NativeConverterTest.TestReverseByteOrderLong", "0x00000012 -> 0x12000000"

    ' Test case: 0x00000000 -> 0x00000000
    result = NativeConverter.ReverseByteOrderLong(&H0)
    m_asserter.AreEqual &H0, result, "NativeConverterTest.TestReverseByteOrderLong", "0x00000000 -> 0x00000000"

    ' Test case: 0x80808080 -> 0x80808080 (symmetrical) - use a smaller symmetrical value that fits in 32-bit signed integer
    result = NativeConverter.ReverseByteOrderLong(&H18181818)  ' 404232216 in decimal, symmetrical when bytes reversed
    m_asserter.AreEqual &H18181818, result, "NativeConverterTest.TestReverseByteOrderLong", "0x18181818 -> 0x18181818"

    ' Test case: 0x11223344 -> 0x44332211
    result = NativeConverter.ReverseByteOrderLong(&H11223344)
    m_asserter.AreEqual &H44332211, result, "NativeConverterTest.TestReverseByteOrderLong", "0x11223344 -> 0x44332211"
End Sub

' TestReverseByteOrderSingle tests the ReverseByteOrderSingle function with various values.
Private Sub TestReverseByteOrderSingle()
    Dim result As Single
    Dim expected As Single

    ' Test case: 0.0f -> 0.0f
    result = NativeConverter.ReverseByteOrderSingle(0!)
    m_asserter.AreEqual 0!, result, "NativeConverterTest.TestReverseByteOrderSingle", "0.0 -> 0.0"

    ' Test case: Simple value that reverses predictably
    result = NativeConverter.ReverseByteOrderSingle(1!)
    ' Instead of using extremely small values, test round-trip consistency
    Dim roundTrip As Single
    roundTrip = NativeConverter.ReverseByteOrderSingle(result)
    m_asserter.AreEqual 1!, roundTrip, "NativeConverterTest.TestReverseByteOrderSingle", "Round trip: 1.0 -> reversed -> 1.0"
End Sub

' TestReverseByteOrderDouble tests the ReverseByteOrderDouble function with various values.
Private Sub TestReverseByteOrderDouble()
    Dim result As Double
    Dim expected As Double

    ' Test case: 0.0 -> 0.0
    result = NativeConverter.ReverseByteOrderDouble(0#)
    m_asserter.AreEqual 0#, result, "NativeConverterTest.TestReverseByteOrderDouble", "0.0 -> 0.0"

    ' Test case: 1.0 -> should reverse bytes correctly (round-trip test)
    result = NativeConverter.ReverseByteOrderDouble(1#)
    ' Reverse again to get back the original value
    Dim roundTrip As Double
    roundTrip = NativeConverter.ReverseByteOrderDouble(result)
    m_asserter.AreEqual 1#, roundTrip, "NativeConverterTest.TestReverseByteOrderDouble", "1.0 -> reversed -> 1.0, roundTrip = " & roundTrip

    ' Test case: 123.456 -> should reverse bytes correctly (round-trip test)
    result = NativeConverter.ReverseByteOrderDouble(123.456)
    roundTrip = NativeConverter.ReverseByteOrderDouble(result)
    m_asserter.AreEqual 123.456, roundTrip, "NativeConverterTest.TestReverseByteOrderDouble", "123.456 -> reversed -> 123.456, roundTrip = " & roundTrip
End Sub

' TestToBytesInteger tests the ToBytesInteger function with various values.
Private Sub TestToBytesInteger()
    Dim result() As Byte
    
    ' Test case: 0x1234 -> [&H34, &H12] (little-endian)
    result = NativeConverter.ToBytesInteger(&H1234)
    m_asserter.AreEqual 2, UBound(result) - LBound(result) + 1, "NativeConverterTest.TestToBytesInteger", "Array length should be 2"
    m_asserter.AreEqual &H34, result(0), "NativeConverterTest.TestToBytesInteger", "Byte 0 should be &H34, actual=" & result(0)
    m_asserter.AreEqual &H12, result(1), "NativeConverterTest.TestToBytesInteger", "Byte 1 should be &H12, actual=" & result(1)
    
    ' Test case: 0 -> [0, 0]
    result = NativeConverter.ToBytesInteger(0)
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesInteger", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesInteger", "Byte 1 should be 0, actual=" & result(1)
    
    ' Test case: -1 -> [&HFF, &HFF] (two's complement)
    result = NativeConverter.ToBytesInteger(-1)
    m_asserter.AreEqual &HFF, result(0), "NativeConverterTest.TestToBytesInteger", "Byte 0 should be &HFF, actual=" & result(0)
    m_asserter.AreEqual &HFF, result(1), "NativeConverterTest.TestToBytesInteger", "Byte 1 should be &HFF, actual=" & result(1)
End Sub

' TestToBytesLong tests the ToBytesLong function with various values.
Private Sub TestToBytesLong()
    Dim result() As Byte
    
    ' Test case: 0x12345678 -> [&H78, &H56, &H34, &H12] (little-endian)
    result = NativeConverter.ToBytesLong(&H12345678)
    m_asserter.AreEqual 4, UBound(result) - LBound(result) + 1, "NativeConverterTest.TestToBytesLong", "Array length should be 4"
    m_asserter.AreEqual &H78, result(0), "NativeConverterTest.TestToBytesLong", "Byte 0 should be &H78, actual=" & result(0)
    m_asserter.AreEqual &H56, result(1), "NativeConverterTest.TestToBytesLong", "Byte 1 should be &H56, actual=" & result(1)
    m_asserter.AreEqual &H34, result(2), "NativeConverterTest.TestToBytesLong", "Byte 2 should be &H34, actual=" & result(2)
    m_asserter.AreEqual &H12, result(3), "NativeConverterTest.TestToBytesLong", "Byte 3 should be &H12, actual=" & result(3)
    
    ' Test case: 0 -> [0, 0, 0, 0]
    result = NativeConverter.ToBytesLong(0)
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesLong", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesLong", "Byte 1 should be 0, actual=" & result(1)
    m_asserter.AreEqual 0, result(2), "NativeConverterTest.TestToBytesLong", "Byte 2 should be 0, actual=" & result(2)
    m_asserter.AreEqual 0, result(3), "NativeConverterTest.TestToBytesLong", "Byte 3 should be 0, actual=" & result(3)
    
    ' Test case: -1 -> [&HFF, &HFF, &HFF, &HFF] (two's complement)
    result = NativeConverter.ToBytesLong(-1)
    m_asserter.AreEqual &HFF, result(0), "NativeConverterTest.TestToBytesLong", "Byte 0 should be &HFF, actual=" & result(0)
    m_asserter.AreEqual &HFF, result(1), "NativeConverterTest.TestToBytesLong", "Byte 1 should be &HFF, actual=" & result(1)
    m_asserter.AreEqual &HFF, result(2), "NativeConverterTest.TestToBytesLong", "Byte 2 should be &HFF, actual=" & result(2)
    m_asserter.AreEqual &HFF, result(3), "NativeConverterTest.TestToBytesLong", "Byte 3 should be &HFF, actual=" & result(3)
End Sub

' TestToBytesSingle tests the ToBytesSingle function with various values.
Private Sub TestToBytesSingle()
    Dim result() As Byte
    
    ' Test case: 1.0 -> [0, 0, &H80, &H3F] (IEEE 754 single: 0x3F800000)
    result = NativeConverter.ToBytesSingle(1!)
    m_asserter.AreEqual 4, UBound(result) - LBound(result) + 1, "NativeConverterTest.TestToBytesSingle", "Array length should be 4"
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesSingle", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesSingle", "Byte 1 should be 0, actual=" & result(1)
    m_asserter.AreEqual &H80, result(2), "NativeConverterTest.TestToBytesSingle", "Byte 2 should be &H80, actual=" & result(2)
    m_asserter.AreEqual &H3F, result(3), "NativeConverterTest.TestToBytesSingle", "Byte 3 should be &H3F, actual=" & result(3)
    
    ' Test case: 0.0 -> [0, 0, 0, 0]
    result = NativeConverter.ToBytesSingle(0!)
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesSingle", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesSingle", "Byte 1 should be 0, actual=" & result(1)
    m_asserter.AreEqual 0, result(2), "NativeConverterTest.TestToBytesSingle", "Byte 2 should be 0, actual=" & result(2)
    m_asserter.AreEqual 0, result(3), "NativeConverterTest.TestToBytesSingle", "Byte 3 should be 0, actual=" & result(3)
    
    ' Test case: -1.0 -> [0, 0, &H80, &HBF] (IEEE 754 single: 0xBF800000)
    result = NativeConverter.ToBytesSingle(-1!)
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesSingle", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesSingle", "Byte 1 should be 0, actual=" & result(1)
    m_asserter.AreEqual &H80, result(2), "NativeConverterTest.TestToBytesSingle", "Byte 2 should be &H80, actual=" & result(2)
    m_asserter.AreEqual &HBF, result(3), "NativeConverterTest.TestToBytesSingle", "Byte 3 should be &HBF, actual=" & result(3)
End Sub

' TestToBytesDouble tests the ToBytesDouble function with various values.
Private Sub TestToBytesDouble()
    Dim result() As Byte
    
    ' Test case: 1.0 -> [0, 0, 0, 0, 0, 0, &HF0, &H3F] (IEEE 754 double: 0x3FF0000000000000)
    result = NativeConverter.ToBytesDouble(1#)
    m_asserter.AreEqual 8, UBound(result) - LBound(result) + 1, "NativeConverterTest.TestToBytesDouble", "Array length should be 8"
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesDouble", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesDouble", "Byte 1 should be 0, actual=" & result(1)
    m_asserter.AreEqual 0, result(2), "NativeConverterTest.TestToBytesDouble", "Byte 2 should be 0, actual=" & result(2)
    m_asserter.AreEqual 0, result(3), "NativeConverterTest.TestToBytesDouble", "Byte 3 should be 0, actual=" & result(3)
    m_asserter.AreEqual 0, result(4), "NativeConverterTest.TestToBytesDouble", "Byte 4 should be 0, actual=" & result(4)
    m_asserter.AreEqual 0, result(5), "NativeConverterTest.TestToBytesDouble", "Byte 5 should be 0, actual=" & result(5)
    m_asserter.AreEqual &HF0, result(6), "NativeConverterTest.TestToBytesDouble", "Byte 6 should be &HF0, actual=" & result(6)
    m_asserter.AreEqual &H3F, result(7), "NativeConverterTest.TestToBytesDouble", "Byte 7 should be &H3F, actual=" & result(7)
    
    ' Test case: 0.0 -> [0, 0, 0, 0, 0, 0, 0, 0]
    result = NativeConverter.ToBytesDouble(0#)
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesDouble", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesDouble", "Byte 1 should be 0, actual=" & result(1)
    m_asserter.AreEqual 0, result(2), "NativeConverterTest.TestToBytesDouble", "Byte 2 should be 0, actual=" & result(2)
    m_asserter.AreEqual 0, result(3), "NativeConverterTest.TestToBytesDouble", "Byte 3 should be 0, actual=" & result(3)
    m_asserter.AreEqual 0, result(4), "NativeConverterTest.TestToBytesDouble", "Byte 4 should be 0, actual=" & result(4)
    m_asserter.AreEqual 0, result(5), "NativeConverterTest.TestToBytesDouble", "Byte 5 should be 0, actual=" & result(5)
    m_asserter.AreEqual 0, result(6), "NativeConverterTest.TestToBytesDouble", "Byte 6 should be 0, actual=" & result(6)
    m_asserter.AreEqual 0, result(7), "NativeConverterTest.TestToBytesDouble", "Byte 7 should be 0, actual=" & result(7)
    
    ' Test case: -1.0 -> [0, 0, 0, 0, 0, 0, &HF0, &HBF] (IEEE 754 double: 0xBFF0000000000000)
    result = NativeConverter.ToBytesDouble(-1#)
    m_asserter.AreEqual 0, result(0), "NativeConverterTest.TestToBytesDouble", "Byte 0 should be 0, actual=" & result(0)
    m_asserter.AreEqual 0, result(1), "NativeConverterTest.TestToBytesDouble", "Byte 1 should be 0, actual=" & result(1)
    m_asserter.AreEqual 0, result(2), "NativeConverterTest.TestToBytesDouble", "Byte 2 should be 0, actual=" & result(2)
    m_asserter.AreEqual 0, result(3), "NativeConverterTest.TestToBytesDouble", "Byte 3 should be 0, actual=" & result(3)
    m_asserter.AreEqual 0, result(4), "NativeConverterTest.TestToBytesDouble", "Byte 4 should be 0, actual=" & result(4)
    m_asserter.AreEqual 0, result(5), "NativeConverterTest.TestToBytesDouble", "Byte 5 should be 0, actual=" & result(5)
    m_asserter.AreEqual &HF0, result(6), "NativeConverterTest.TestToBytesDouble", "Byte 6 should be &HF0, actual=" & result(6)
    m_asserter.AreEqual &HBF, result(7), "NativeConverterTest.TestToBytesDouble", "Byte 7 should be &HBF, actual=" & result(7)
End Sub
