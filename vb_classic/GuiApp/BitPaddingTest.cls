VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BitPaddingTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter

    ' PadZeroLeft tests (Byte to larger types)
    TestPadZeroLeftTo16Bits
    TestPadZeroLeftTo32Bits
    TestPadZeroLeftTo64Bits

    ' PadZeroRight tests (Byte to larger types)
    TestPadZeroRightTo16Bits
    TestPadZeroRightTo32Bits
    TestPadZeroRightTo64Bits

    ' PadZeroLeft tests (Integer to larger types)
    TestPadZeroLeftTo32BitsInteger
    TestPadZeroLeftTo64BitsInteger

    ' PadZeroRight tests (Integer to larger types)
    TestPadZeroRightTo32BitsInteger
    TestPadZeroRightTo64BitsInteger

    ' PadZeroLeft tests (Long to Double)
    TestPadZeroLeftTo64BitsLong

    ' PadZeroRight tests (Long to Double)
    TestPadZeroRightTo64BitsLong
End Sub

' ==================== BYTE COMPARISON HELPERS ====================

' Compares the bytes of two Double values
Private Sub AssertDoubleBytesEqual(ByVal expected As Double, ByVal actual As Double, ByVal site As String, ByVal message As String)
    Dim expectedBytes() As Byte
    Dim actualBytes() As Byte
    expectedBytes = NativeConverter.ToBytesDouble(expected)
    actualBytes = NativeConverter.ToBytesDouble(actual)

    Dim i As Long
    Dim msg As String
    For i = 0 To 7
        If expectedBytes(i) <> actualBytes(i) Then
            msg = message & " (expected: " & BytesToHex(expectedBytes) & ", actual: " & BytesToHex(actualBytes) & ")"
            m_asserter.IsTrue False, site, msg
            Exit Sub
        End If
    Next i
    m_asserter.IsTrue True, site, message
End Sub

' Converts byte array to hex string for debugging
Private Function BytesToHex(ByRef bytes() As Byte) As String
    Dim i As Long
    Dim result As String
    result = ""
    For i = 0 To 7
        If i > 0 Then result = result & " "
        result = result & Hex(bytes(i))
    Next i
    BytesToHex = result
End Function

' ==================== PAD ZERO LEFT BYTE ====================

Private Sub TestPadZeroLeftTo16Bits()
    m_asserter.AreEqual 1, BitAccessor.PadZeroLeftTo16Bits(1), "BitPaddingTest.PadZeroLeftTo16Bits", "1 -> 1"
    m_asserter.AreEqual 2, BitAccessor.PadZeroLeftTo16Bits(2), "BitPaddingTest.PadZeroLeftTo16Bits", "2 -> 2"
    m_asserter.AreEqual 211, BitAccessor.PadZeroLeftTo16Bits(211), "BitPaddingTest.PadZeroLeftTo16Bits", "211 -> 211"
End Sub

Private Sub TestPadZeroLeftTo32Bits()
    m_asserter.AreEqual 1&, BitAccessor.PadZeroLeftTo32Bits(1), "BitPaddingTest.PadZeroLeftTo32Bits", "1 -> 1"
    m_asserter.AreEqual 2&, BitAccessor.PadZeroLeftTo32Bits(2), "BitPaddingTest.PadZeroLeftTo32Bits", "2 -> 2"
    m_asserter.AreEqual 211&, BitAccessor.PadZeroLeftTo32Bits(211), "BitPaddingTest.PadZeroLeftTo32Bits", "211 -> 211"
    m_asserter.AreEqual &HAF&, BitAccessor.PadZeroLeftTo32Bits(&HAF), "BitPaddingTest.PadZeroLeftTo32Bits", "0xAF -> 0x000000AF"
End Sub

Private Sub TestPadZeroLeftTo64Bits()
    ' PadZeroLeft keeps numeric value, just converts to Double
    AssertDoubleBytesEqual CDbl(1), BitAccessor.PadZeroLeftTo64Bits(1), "BitPaddingTest.PadZeroLeftTo64Bits", "1 -> 1"
    AssertDoubleBytesEqual CDbl(2), BitAccessor.PadZeroLeftTo64Bits(2), "BitPaddingTest.PadZeroLeftTo64Bits", "2 -> 2"
    AssertDoubleBytesEqual CDbl(211), BitAccessor.PadZeroLeftTo64Bits(211), "BitPaddingTest.PadZeroLeftTo64Bits", "211 -> 211"
    AssertDoubleBytesEqual CDbl(175), BitAccessor.PadZeroLeftTo64Bits(&HAF), "BitPaddingTest.PadZeroLeftTo64Bits", "0xAF -> 175"
End Sub

' ==================== PAD ZERO RIGHT BYTE ====================

Private Sub TestPadZeroRightTo16Bits()
    m_asserter.AreEqual 256, BitAccessor.PadZeroRightTo16Bits(1), "BitPaddingTest.PadZeroRightTo16Bits", "1 -> 256"
    m_asserter.AreEqual 512, BitAccessor.PadZeroRightTo16Bits(2), "BitPaddingTest.PadZeroRightTo16Bits", "2 -> 512"
    m_asserter.AreEqual &HD300, BitAccessor.PadZeroRightTo16Bits(&HD3), "BitPaddingTest.PadZeroRightTo16Bits", "0xd3 -> 0xd300"
End Sub

Private Sub TestPadZeroRightTo32Bits()
    m_asserter.AreEqual 16777216, BitAccessor.PadZeroRightTo32Bits(1), "BitPaddingTest.PadZeroRightTo32Bits", "1 -> 16777216"
    m_asserter.AreEqual 33554432, BitAccessor.PadZeroRightTo32Bits(2), "BitPaddingTest.PadZeroRightTo32Bits", "2 -> 33554432"
    m_asserter.AreEqual &HD3000000, BitAccessor.PadZeroRightTo32Bits(&HD3), "BitPaddingTest.PadZeroRightTo32Bits", "0xd3 -> 0xd3000000"
End Sub

Private Sub TestPadZeroRightTo64Bits()
    ' PadZeroRight: value * 2^56 (shifts byte to upper 8 bits as numeric value)
    AssertDoubleBytesEqual CDbl(1) * 72057594037927936#, BitAccessor.PadZeroRightTo64Bits(1), "BitPaddingTest.PadZeroRightTo64Bits", "1 -> value * 2^56"
    AssertDoubleBytesEqual CDbl(2) * 72057594037927936#, BitAccessor.PadZeroRightTo64Bits(2), "BitPaddingTest.PadZeroRightTo64Bits", "2 -> value * 2^56"
    AssertDoubleBytesEqual CDbl(211) * 72057594037927936#, BitAccessor.PadZeroRightTo64Bits(&HD3), "BitPaddingTest.PadZeroRightTo64Bits", "0xD3 -> value * 2^56"
    AssertDoubleBytesEqual CDbl(175) * 72057594037927936#, BitAccessor.PadZeroRightTo64Bits(&HAF), "BitPaddingTest.PadZeroRightTo64Bits", "0xAF -> value * 2^56"
End Sub

' ==================== PAD ZERO LEFT INTEGER ====================

Private Sub TestPadZeroLeftTo32BitsInteger()
    m_asserter.AreEqual 1&, BitAccessor.PadZeroLeftTo32BitsInteger(1), "BitPaddingTest.PadZeroLeftTo32BitsInteger", "1 -> 1"
    m_asserter.AreEqual 2&, BitAccessor.PadZeroLeftTo32BitsInteger(2), "BitPaddingTest.PadZeroLeftTo32BitsInteger", "2 -> 2"
    m_asserter.AreEqual &HEFAF&, BitAccessor.PadZeroLeftTo32BitsInteger(&HEFAF), "BitPaddingTest.PadZeroLeftTo32BitsInteger", "0xEFAF -> 0x0000EFAF"
    m_asserter.AreEqual 65535, BitAccessor.PadZeroLeftTo32BitsInteger(-1), "BitPaddingTest.PadZeroLeftTo32BitsInteger", "-1 (0xFFFF) -> 0x0000FFFF"
End Sub

Private Sub TestPadZeroLeftTo64BitsInteger()
    ' PadZeroLeft: Integer converted to Double (numeric, not bits)
    AssertDoubleBytesEqual CDbl(1), BitAccessor.PadZeroLeftTo64BitsInteger(1), "BitPaddingTest.PadZeroLeftTo64BitsInteger", "1 -> 1"
    AssertDoubleBytesEqual CDbl(2), BitAccessor.PadZeroLeftTo64BitsInteger(2), "BitPaddingTest.PadZeroLeftTo64BitsInteger", "2 -> 2"
    AssertDoubleBytesEqual CDbl(&HEFAF), BitAccessor.PadZeroLeftTo64BitsInteger(&HEFAF), "BitPaddingTest.PadZeroLeftTo64BitsInteger", "0xEFAF -> 61359"
    AssertDoubleBytesEqual CDbl(-4177), BitAccessor.PadZeroLeftTo64BitsInteger(-4177), "BitPaddingTest.PadZeroLeftTo64BitsInteger", "-4177 -> -4177"
End Sub

' ==================== PAD ZERO RIGHT INTEGER ====================

Private Sub TestPadZeroRightTo32BitsInteger()
    m_asserter.AreEqual 65536, BitAccessor.PadZeroRightTo32BitsInteger(1), "BitPaddingTest.PadZeroRightTo32BitsInteger", "1 -> 65536"
    m_asserter.AreEqual 131072, BitAccessor.PadZeroRightTo32BitsInteger(2), "BitPaddingTest.PadZeroRightTo32BitsInteger", "2 -> 131072"
    m_asserter.AreEqual &HD30000, BitAccessor.PadZeroRightTo32BitsInteger(&HD3), "BitPaddingTest.PadZeroRightTo32BitsInteger", "0x00D3 -> 0x00D30000"
    m_asserter.AreEqual -271384576, BitAccessor.PadZeroRightTo32BitsInteger(-4141), "BitPaddingTest.PadZeroRightTo32BitsInteger", "-4141 -> -271384576"
End Sub

Private Sub TestPadZeroRightTo64BitsInteger()
    ' PadZeroRight: Integer * 2^48 (shifts to upper 16 bits as numeric)
    Dim val As Double
    val = 281474976710656#  ' 1 * 2^48
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsInteger(1), "BitPaddingTest.PadZeroRightTo64BitsInteger", "1 -> value * 2^48"

    val = 562949953421312#  ' 2 * 2^48
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsInteger(2), "BitPaddingTest.PadZeroRightTo64BitsInteger", "2 -> value * 2^48"

    val = CDbl(211) * 281474976710656#
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsInteger(CInt(&HD3)), "BitPaddingTest.PadZeroRightTo64BitsInteger", "0x00D3 -> value * 2^48"

    val = CDbl(-4141) * 281474976710656#
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsInteger(-4141), "BitPaddingTest.PadZeroRightTo64BitsInteger", "-4141 -> value * 2^48"
End Sub

' ==================== PAD ZERO LEFT LONG ====================

Private Sub TestPadZeroLeftTo64BitsLong()
    ' PadZeroLeft: Long converted to Double (numeric, not bits)
    AssertDoubleBytesEqual CDbl(1), BitAccessor.PadZeroLeftTo64BitsLong(1), "BitPaddingTest.PadZeroLeftTo64BitsLong", "1 -> 1"
    AssertDoubleBytesEqual CDbl(2), BitAccessor.PadZeroLeftTo64BitsLong(2), "BitPaddingTest.PadZeroLeftTo64BitsLong", "2 -> 2"
    AssertDoubleBytesEqual CDbl(&HEFAF), BitAccessor.PadZeroLeftTo64BitsLong(&HEFAF), "BitPaddingTest.PadZeroLeftTo64BitsLong", "0xEFAF -> value"
    AssertDoubleBytesEqual CDbl(&HEFEFEFAF), BitAccessor.PadZeroLeftTo64BitsLong(&HEFEFEFAF), "BitPaddingTest.PadZeroLeftTo64BitsLong", "0xEFEFEFAF -> value"
    AssertDoubleBytesEqual CDbl(-269488209), BitAccessor.PadZeroLeftTo64BitsLong(-269488209), "BitPaddingTest.PadZeroLeftTo64BitsLong", "-269488209 -> value"
End Sub

' ==================== PAD ZERO RIGHT LONG ====================

Private Sub TestPadZeroRightTo64BitsLong()
    ' PadZeroRight: Long * 2^32 (shifts to upper 32 bits as numeric)
    Dim val As Double

    val = 4294967296#  ' 1 * 2^32
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsLong(1), "BitPaddingTest.PadZeroRightTo64BitsLong", "1 -> value * 2^32"

    val = 8589934592#  ' 2 * 2^32
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsLong(2), "BitPaddingTest.PadZeroRightTo64BitsLong", "2 -> value * 2^32"

    val = CDbl(&HAF) * 4294967296#
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsLong(&HAF), "BitPaddingTest.PadZeroRightTo64BitsLong", "0xAF -> value * 2^32"

    val = CDbl(&HEFAF) * 4294967296#
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsLong(&HEFAF), "BitPaddingTest.PadZeroRightTo64BitsLong", "0xEFAF -> value * 2^32"

    val = CDbl(&HEFEFEFAF) * 4294967296#
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsLong(&HEFEFEFAF), "BitPaddingTest.PadZeroRightTo64BitsLong", "0xEFEFEFAF -> value * 2^32"

    val = CDbl(-269488209) * 4294967296#
    AssertDoubleBytesEqual val, BitAccessor.PadZeroRightTo64BitsLong(-269488209), "BitPaddingTest.PadZeroRightTo64BitsLong", "-269488209 -> value * 2^32"
End Sub
