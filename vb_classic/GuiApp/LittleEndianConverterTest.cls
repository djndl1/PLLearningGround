VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "LittleEndianConverterTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestToBytesIntegerLE
    TestToIntegerLE
    TestToBytesLongLE
    TestToLongLE
    TestToBytesSingleLE
    TestToSingleLE
    TestToBytesDoubleLE
    TestToDoubleLE
    TestInsufficientBytes
End Sub

' Test converting Integer to little-endian bytes and back
Private Sub TestToBytesIntegerLE()
    ' Test case 1: Positive value 1252
    Dim bytes1(0 To 1) As Byte
    bytes1(0) = 228
    bytes1(1) = 4
    Dim result1() As Byte
    result1 = LittleEndianConverter.ToBytesIntegerLE(1252)
    m_asserter.IsTrue ArraysEqual(result1, bytes1), "LittleEndianConverterTest.TestToBytesIntegerLE", "1252 should convert to [228, 4]"

    ' Test case 2: Negative value -1251
    Dim bytes2(0 To 1) As Byte
    bytes2(0) = 29
    bytes2(1) = 251
    Dim result2() As Byte
    result2 = LittleEndianConverter.ToBytesIntegerLE(-1251)
    m_asserter.IsTrue ArraysEqual(result2, bytes2), "LittleEndianConverterTest.TestToBytesIntegerLE", "-1251 should convert to [29, 251]"

    ' Test round-trip conversion
    Dim originalValue As Integer
    originalValue = 192
    Dim convertedBytes() As Byte
    Dim roundTripValue As Integer
    convertedBytes = LittleEndianConverter.ToBytesIntegerLE(originalValue)
    roundTripValue = LittleEndianConverter.ToIntegerLE(convertedBytes)
    m_asserter.AreEqual originalValue, roundTripValue, "LittleEndianConverterTest.TestToBytesIntegerLE", "Round-trip conversion should preserve value"
End Sub

' Test converting little-endian bytes to Integer
Private Sub TestToIntegerLE()
    ' Test case 1: Positive value 1252
    Dim bytes1(0 To 1) As Byte
    bytes1(0) = 228
    bytes1(1) = 4
    Dim result1 As Integer
    result1 = LittleEndianConverter.ToIntegerLE(bytes1)
    m_asserter.AreEqual result1, 1252, "LittleEndianConverterTest.TestToIntegerLE", "[228, 4] should convert to 1252"

    ' Test case 2: Negative value -1251
    Dim bytes2(0 To 1) As Byte
    bytes2(0) = 29
    bytes2(1) = 251
    Dim result2 As Integer
    result2 = LittleEndianConverter.ToIntegerLE(bytes2)
    m_asserter.AreEqual result2, -1251, "LittleEndianConverterTest.TestToIntegerLE", "[29, 251] should convert to -1251"

    ' Test case 3: Value 192
    Dim bytes3(0 To 1) As Byte
    bytes3(0) = 192
    bytes3(1) = 0
    Dim result3 As Integer
    result3 = LittleEndianConverter.ToIntegerLE(bytes3)
    m_asserter.AreEqual result3, 192, "LittleEndianConverterTest.TestToIntegerLE", "[192, 0] should convert to 192"
End Sub

' Test converting Long to little-endian bytes and back
Private Sub TestToBytesLongLE()
    ' Test case 1: Positive value 192
    Dim bytes1(0 To 3) As Byte
    bytes1(0) = 192
    bytes1(1) = 0
    bytes1(2) = 0
    bytes1(3) = 0
    Dim result1() As Byte
    result1 = LittleEndianConverter.ToBytesLongLE(192)
    m_asserter.IsTrue ArraysEqual(result1, bytes1), "LittleEndianConverterTest.TestToBytesLongLE", "192 should convert to [192, 0, 0, 0]"

    ' Test case 2: Negative value -12510
    Dim bytes2(0 To 3) As Byte
    bytes2(0) = 34
    bytes2(1) = 207
    bytes2(2) = 255
    bytes2(3) = 255
    Dim result2() As Byte
    result2 = LittleEndianConverter.ToBytesLongLE(-12510)
    m_asserter.IsTrue ArraysEqual(result2, bytes2), "LittleEndianConverterTest.TestToBytesLongLE", "-12510 should convert to [34, 207, 255, 255]"

    ' Test round-trip conversion
    Dim originalValue As Long
    originalValue = 192
    Dim convertedBytes() As Byte
    Dim roundTripValue As Long
    convertedBytes = LittleEndianConverter.ToBytesLongLE(originalValue)
    roundTripValue = LittleEndianConverter.ToLongLE(convertedBytes)
    m_asserter.AreEqual originalValue, roundTripValue, "LittleEndianConverterTest.TestToBytesLongLE", "Round-trip conversion should preserve value"
End Sub

' Test converting little-endian bytes to Long
Private Sub TestToLongLE()
    ' Test case 1: Positive value 192
    Dim bytes1(0 To 3) As Byte
    bytes1(0) = 192
    bytes1(1) = 0
    bytes1(2) = 0
    bytes1(3) = 0
    Dim result1 As Long
    result1 = LittleEndianConverter.ToLongLE(bytes1)
    m_asserter.AreEqual result1, 192, "LittleEndianConverterTest.TestToLongLE", "[192, 0, 0, 0] should convert to 192"

    ' Test case 2: Negative value -12510
    Dim bytes2(0 To 3) As Byte
    bytes2(0) = 34
    bytes2(1) = 207
    bytes2(2) = 255
    bytes2(3) = 255
    Dim result2 As Long
    result2 = LittleEndianConverter.ToLongLE(bytes2)
    m_asserter.AreEqual result2, -12510, "LittleEndianConverterTest.TestToLongLE", "[34, 207, 255, 255] should convert to -12510"
End Sub

' Test converting Single to little-endian bytes and back
Private Sub TestToBytesSingleLE()
    ' Test case: Value 2.6904930515036488e-43
    Dim bytes(0 To 3) As Byte
    bytes(0) = 192
    bytes(1) = 0
    bytes(2) = 0
    bytes(3) = 0
    Dim result() As Byte
    result = LittleEndianConverter.ToBytesSingleLE(2.690493E-43!)
    m_asserter.IsTrue ArraysEqual(result, bytes), "LittleEndianConverterTest.TestToBytesSingleLE", "2.6904930515036488e-43 should convert to [192, 0, 0, 0]"

    ' Test round-trip conversion
    Dim originalValue As Single
    originalValue = 2.690493E-43!
    Dim convertedBytes() As Byte
    Dim roundTripValue As Single
    convertedBytes = LittleEndianConverter.ToBytesSingleLE(originalValue)
    roundTripValue = LittleEndianConverter.ToSingleLE(convertedBytes)
    m_asserter.IsTrue Abs(originalValue - roundTripValue) < 0.0001, "LittleEndianConverterTest.TestToBytesSingleLE", "Round-trip conversion should preserve value"
End Sub

' Test converting little-endian bytes to Single
Private Sub TestToSingleLE()
    ' Test case: Value 2.6904930515036488e-43
    Dim bytes(0 To 3) As Byte
    bytes(0) = 192
    bytes(1) = 0
    bytes(2) = 0
    bytes(3) = 0
    Dim result As Single
    result = LittleEndianConverter.ToSingleLE(bytes)
    Dim expected As Single
    expected = 2.690493E-43!
    m_asserter.IsTrue Abs(result - expected) < 0.0001, "LittleEndianConverterTest.TestToSingleLE", "[192, 0, 0, 0] should convert to 2.6904930515036488e-43"
End Sub

' Test converting Double to little-endian bytes and back
Private Sub TestToBytesDoubleLE()
    ' Test case: Value 4.1516e-320
    Dim bytes(0 To 7) As Byte
    bytes(0) = 211
    bytes(1) = 32
    bytes(2) = 0
    bytes(3) = 0
    bytes(4) = 0
    bytes(5) = 0
    bytes(6) = 0
    bytes(7) = 0
    Dim result() As Byte
    result = LittleEndianConverter.ToBytesDoubleLE(4.15163362200399E-320)
    m_asserter.IsTrue ArraysEqual(result, bytes), "LittleEndianConverterTest.TestToBytesDoubleLE", "4.1516e-320 should convert to [211, 32, 0, 0, 0, 0, 0, 0]"

    ' Test round-trip conversion
    Dim originalValue As Double
    originalValue = 4.15163362200399E-320
    Dim convertedBytes() As Byte
    Dim roundTripValue As Double
    convertedBytes = LittleEndianConverter.ToBytesDoubleLE(originalValue)
    roundTripValue = LittleEndianConverter.ToDoubleLE(convertedBytes)
    m_asserter.IsTrue Abs(originalValue - roundTripValue) < 0.0001, "LittleEndianConverterTest.TestToBytesDoubleLE", "Round-trip conversion should preserve value"
End Sub

' Test converting little-endian bytes to Double
Private Sub TestToDoubleLE()
    ' Test case: Value 4.1516e-320
    Dim bytes(0 To 7) As Byte
    bytes(0) = 211
    bytes(1) = 32
    bytes(2) = 0
    bytes(3) = 0
    bytes(4) = 0
    bytes(5) = 0
    bytes(6) = 0
    bytes(7) = 0
    Dim result As Double
    result = LittleEndianConverter.ToDoubleLE(bytes)
    Dim expected As Double
    expected = 4.15163362200399E-320
    m_asserter.IsTrue Abs(result - expected) < 0.0001, "LittleEndianConverterTest.TestToDoubleLE", "[211, 32, 0, 0, 0, 0, 0, 0] should convert to 4.1516e-320"
End Sub

' Test error handling for insufficient bytes
Private Sub TestInsufficientBytes()
    TestEmptyBytesForInteger
    TestOneByteForInteger
    TestThreeBytesForLong
End Sub

' Test with empty array for Integer
Private Sub TestEmptyBytesForInteger()
    ' Create an empty array by not initializing it
    Dim emptyBytes() As Byte
    On Error GoTo ErrorHandler
    Dim result As Integer
    result = LittleEndianConverter.ToIntegerLE(emptyBytes)
    m_asserter.IsTrue False, "LittleEndianConverterTest.TestEmptyBytesForInteger", "Should have thrown error for empty bytes"
    Exit Sub

ErrorHandler:
    m_asserter.IsTrue True, "LittleEndianConverterTest.TestEmptyBytesForInteger", "Correctly handled empty bytes for Integer"
End Sub

' Test with 1 byte for Integer (needs 2)
Private Sub TestOneByteForInteger()
    Dim oneByte(0) As Byte
    oneByte(0) = 0
    On Error GoTo ErrorHandler
    Dim result As Integer
    result = LittleEndianConverter.ToIntegerLE(oneByte)
    m_asserter.IsTrue False, "LittleEndianConverterTest.TestOneByteForInteger", "Should have thrown error for 1 byte"
    Exit Sub

ErrorHandler:
    m_asserter.IsTrue True, "LittleEndianConverterTest.TestOneByteForInteger", "Correctly handled insufficient bytes for Integer"
End Sub

' Test with 3 bytes for Long (needs 4)
Private Sub TestThreeBytesForLong()
    Dim threeBytes(0 To 2) As Byte
    threeBytes(0) = 0
    threeBytes(1) = 1
    threeBytes(2) = 2
    On Error GoTo ErrorHandler
    Dim result As Long
    result = LittleEndianConverter.ToLongLE(threeBytes)
    m_asserter.IsTrue False, "LittleEndianConverterTest.TestThreeBytesForLong", "Should have thrown error for 3 bytes"
    Exit Sub

ErrorHandler:
    m_asserter.IsTrue True, "LittleEndianConverterTest.TestThreeBytesForLong", "Correctly handled insufficient bytes for Long"
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
