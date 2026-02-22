VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BigEndianConverterTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestToBytesIntegerBE
    TestToIntegerBE
    TestToBytesLongBE
    TestToLongBE
    TestToBytesSingleBE
    TestToSingleBE
    TestToBytesDoubleBE
    TestToDoubleBE
    TestInsufficientBytes
End Sub

' Test converting Integer to big-endian bytes and back
Private Sub TestToBytesIntegerBE()
    ' Test case 1: Positive value 1252
    Dim bytes1(0 To 1) As Byte
    bytes1(0) = 4
    bytes1(1) = 228
    Dim result1() As Byte
    result1 = BigEndianConverter.ToBytesIntegerBE(1252)
    m_asserter.IsTrue ArraysEqual(result1, bytes1), "BigEndianConverterTest.TestToBytesIntegerBE", "1252 should convert to [4, 228]"

    ' Test case 2: Negative value -1251
    Dim bytes2(0 To 1) As Byte
    bytes2(0) = 251
    bytes2(1) = 29
    Dim result2() As Byte
    result2 = BigEndianConverter.ToBytesIntegerBE(-1251)
    m_asserter.IsTrue ArraysEqual(result2, bytes2), "BigEndianConverterTest.TestToBytesIntegerBE", "-1251 should convert to [251, 29]"

    ' Test round-trip conversion
    Dim originalValue As Integer
    originalValue = 192
    Dim convertedBytes() As Byte
    Dim roundTripValue As Integer
    convertedBytes = BigEndianConverter.ToBytesIntegerBE(originalValue)
    roundTripValue = BigEndianConverter.ToIntegerBE(convertedBytes)
    m_asserter.AreEqual originalValue, roundTripValue, "BigEndianConverterTest.TestToBytesIntegerBE", "Round-trip conversion should preserve value"
End Sub

' Test converting big-endian bytes to Integer
Private Sub TestToIntegerBE()
    ' Test case 1: Positive value 1252
    Dim bytes1(0 To 1) As Byte
    bytes1(0) = 4
    bytes1(1) = 228
    Dim result1 As Integer
    result1 = BigEndianConverter.ToIntegerBE(bytes1)
    m_asserter.AreEqual result1, 1252, "BigEndianConverterTest.TestToIntegerBE", "[4, 228] should convert to 1252"

    ' Test case 2: Negative value -1251
    Dim bytes2(0 To 1) As Byte
    bytes2(0) = 251
    bytes2(1) = 29
    Dim result2 As Integer
    result2 = BigEndianConverter.ToIntegerBE(bytes2)
    m_asserter.AreEqual result2, -1251, "BigEndianConverterTest.TestToIntegerBE", "[251, 29] should convert to -1251"

    ' Test case 3: Value 192
    Dim bytes3(0 To 1) As Byte
    bytes3(0) = 0
    bytes3(1) = 192
    Dim result3 As Integer
    result3 = BigEndianConverter.ToIntegerBE(bytes3)
    m_asserter.AreEqual result3, 192, "BigEndianConverterTest.TestToIntegerBE", "[0, 192] should convert to 192"
End Sub

' Test converting Long to big-endian bytes and back
Private Sub TestToBytesLongBE()
    ' Test case 1: Positive value 192
    Dim bytes1(0 To 3) As Byte
    bytes1(0) = 0
    bytes1(1) = 0
    bytes1(2) = 0
    bytes1(3) = 192
    Dim result1() As Byte
    result1 = BigEndianConverter.ToBytesLongBE(192)
    m_asserter.IsTrue ArraysEqual(result1, bytes1), "BigEndianConverterTest.TestToBytesLongBE", "192 should convert to [0, 0, 0, 192]"

    ' Test case 2: Negative value -12510
    Dim bytes2(0 To 3) As Byte
    bytes2(0) = 255
    bytes2(1) = 255
    bytes2(2) = 207
    bytes2(3) = 34
    Dim result2() As Byte
    result2 = BigEndianConverter.ToBytesLongBE(-12510)
    m_asserter.IsTrue ArraysEqual(result2, bytes2), "BigEndianConverterTest.TestToBytesLongBE", "-12510 should convert to [255, 255, 207, 34]"

    ' Test round-trip conversion
    Dim originalValue As Long
    originalValue = 192
    Dim convertedBytes() As Byte
    Dim roundTripValue As Long
    convertedBytes = BigEndianConverter.ToBytesLongBE(originalValue)
    roundTripValue = BigEndianConverter.ToLongBE(convertedBytes)
    m_asserter.AreEqual originalValue, roundTripValue, "BigEndianConverterTest.TestToBytesLongBE", "Round-trip conversion should preserve value"
End Sub

' Test converting big-endian bytes to Long
Private Sub TestToLongBE()
    ' Test case 1: Positive value 192
    Dim bytes1(0 To 3) As Byte
    bytes1(0) = 0
    bytes1(1) = 0
    bytes1(2) = 0
    bytes1(3) = 192
    Dim result1 As Long
    result1 = BigEndianConverter.ToLongBE(bytes1)
    m_asserter.AreEqual result1, 192, "BigEndianConverterTest.TestToLongBE", "[0, 0, 0, 192] should convert to 192"

    ' Test case 2: Negative value -12510
    Dim bytes2(0 To 3) As Byte
    bytes2(0) = 255
    bytes2(1) = 255
    bytes2(2) = 207
    bytes2(3) = 34
    Dim result2 As Long
    result2 = BigEndianConverter.ToLongBE(bytes2)
    m_asserter.AreEqual result2, -12510, "BigEndianConverterTest.TestToLongBE", "[255, 255, 207, 34] should convert to -12510"
End Sub

' Test converting Single to big-endian bytes and back
Private Sub TestToBytesSingleBE()
    ' Test case: Value 2.6904930515036488e-43
    Dim bytes(0 To 3) As Byte
    bytes(0) = 0
    bytes(1) = 0
    bytes(2) = 0
    bytes(3) = 192
    Dim result() As Byte
    result = BigEndianConverter.ToBytesSingleBE(2.690493E-43!)
    m_asserter.IsTrue ArraysEqual(result, bytes), "BigEndianConverterTest.TestToBytesSingleBE", "2.6904930515036488e-43 should convert to [0, 0, 0, 192]"

    ' Test round-trip conversion
    Dim originalValue As Single
    originalValue = 2.690493E-43!
    Dim convertedBytes() As Byte
    Dim roundTripValue As Single
    convertedBytes = BigEndianConverter.ToBytesSingleBE(originalValue)
    roundTripValue = BigEndianConverter.ToSingleBE(convertedBytes)
    m_asserter.IsTrue Abs(originalValue - roundTripValue) < 0.0001, "BigEndianConverterTest.TestToBytesSingleBE", "Round-trip conversion should preserve value"
End Sub

' Test converting big-endian bytes to Single
Private Sub TestToSingleBE()
    ' Test case: Value 2.6904930515036488e-43
    Dim bytes(0 To 3) As Byte
    bytes(0) = 0
    bytes(1) = 0
    bytes(2) = 0
    bytes(3) = 192
    Dim result As Single
    result = BigEndianConverter.ToSingleBE(bytes)
    Dim expected As Single
    expected = 2.690493E-43!
    m_asserter.IsTrue Abs(result - expected) < 0.0001, "BigEndianConverterTest.TestToSingleBE", "[0, 0, 0, 192] should convert to 2.6904930515036488e-43"
End Sub

' Test converting Double to big-endian bytes and back
Private Sub TestToBytesDoubleBE()
    ' Test case: Value 4.1516e-320
    Dim bytes(0 To 7) As Byte
    bytes(0) = 0
    bytes(1) = 0
    bytes(2) = 0
    bytes(3) = 0
    bytes(4) = 0
    bytes(5) = 0
    bytes(6) = 32
    bytes(7) = 211
    Dim result() As Byte
    result = BigEndianConverter.ToBytesDoubleBE(4.15163362200399E-320)
    m_asserter.IsTrue ArraysEqual(result, bytes), "BigEndianConverterTest.TestToBytesDoubleBE", "4.1516e-320 should convert to [0, 0, 0, 0, 0, 0, 32, 211]"

    ' Test round-trip conversion
    Dim originalValue As Double
    originalValue = 4.15163362200399E-320
    Dim convertedBytes() As Byte
    Dim roundTripValue As Double
    convertedBytes = BigEndianConverter.ToBytesDoubleBE(originalValue)
    roundTripValue = BigEndianConverter.ToDoubleBE(convertedBytes)
    m_asserter.IsTrue Abs(originalValue - roundTripValue) < 0.0001, "BigEndianConverterTest.TestToBytesDoubleBE", "Round-trip conversion should preserve value"
End Sub

' Test converting big-endian bytes to Double
Private Sub TestToDoubleBE()
    ' Test case: Value 4.1516e-320
    Dim bytes(0 To 7) As Byte
    bytes(0) = 0
    bytes(1) = 0
    bytes(2) = 0
    bytes(3) = 0
    bytes(4) = 0
    bytes(5) = 0
    bytes(6) = 32
    bytes(7) = 211
    Dim result As Double
    result = BigEndianConverter.ToDoubleBE(bytes)
    Dim expected As Double
    expected = 4.15163362200399E-320
    m_asserter.IsTrue Abs(result - expected) < 0.0001, "BigEndianConverterTest.TestToDoubleBE", "[0, 0, 0, 0, 0, 0, 32, 211] should convert to 4.1516e-320"
End Sub

' Test error handling for insufficient bytes
Private Sub TestInsufficientBytes()
    TestEmptyBytesForInteger
    TestOneByteForInteger
    TestThreeBytesForLong
End Sub

' Test with empty array for Integer
Private Sub TestEmptyBytesForInteger()
    ' Create an empty array (0 elements)
    Dim emptyBytes() As Byte
    ReDim emptyBytes(0 To 0)
    On Error GoTo ErrorHandler
    Dim result As Integer
    result = BigEndianConverter.ToIntegerBE(emptyBytes)
    m_asserter.IsTrue False, "BigEndianConverterTest.TestEmptyBytesForInteger", "Should have thrown error for empty bytes"
    Exit Sub

ErrorHandler:
    m_asserter.IsTrue True, "BigEndianConverterTest.TestEmptyBytesForInteger", "Correctly handled empty bytes for Integer"
End Sub

' Test with 1 byte for Integer (needs 2)
Private Sub TestOneByteForInteger()
    Dim oneByte(0) As Byte
    oneByte(0) = 0
    On Error GoTo ErrorHandler
    Dim result As Integer
    result = BigEndianConverter.ToIntegerBE(oneByte)
    m_asserter.IsTrue False, "BigEndianConverterTest.TestOneByteForInteger", "Should have thrown error for 1 byte"
    Exit Sub

ErrorHandler:
    m_asserter.IsTrue True, "BigEndianConverterTest.TestOneByteForInteger", "Correctly handled insufficient bytes for Integer"
End Sub

' Test with 3 bytes for Long (needs 4)
Private Sub TestThreeBytesForLong()
    Dim threeBytes(0 To 2) As Byte
    threeBytes(0) = 0
    threeBytes(1) = 1
    threeBytes(2) = 2
    On Error GoTo ErrorHandler
    Dim result As Long
    result = BigEndianConverter.ToLongBE(threeBytes)
    m_asserter.IsTrue False, "BigEndianConverterTest.TestThreeBytesForLong", "Should have thrown error for 3 bytes"
    Exit Sub

ErrorHandler:
    m_asserter.IsTrue True, "BigEndianConverterTest.TestThreeBytesForLong", "Correctly handled insufficient bytes for Long"
End Sub

' Helper function to compare two byte arrays
Private Function ArraysEqual(arr1() As Byte, arr2() As Byte) As Boolean
    If LBound(arr1) <> LBound(arr2) Or UBound(arr1) <> UBound(arr2) Then
        ArraysEqual = False
        Exit Function
    End If

    Dim i As Integer
    For i = LBound(arr1) To UBound(arr1)
        If arr1(i) <> arr2(i) Then
            ArraysEqual = False
            Exit Function
        End If
    Next i

    ArraysEqual = True
End Function
