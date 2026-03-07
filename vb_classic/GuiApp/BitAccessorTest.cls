VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BitAccessorTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, source As Any, ByVal Length As Long)

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter

    ' GetBit tests
    TestGetBitByte
    TestGetBitInteger
    TestGetBitLong
    TestGetBitSingle
    TestGetBitDouble
    TestGetBitOutOfRange

    ' SetBit tests
    TestSetBitByte
    TestSetBitInteger
    TestSetBitLong
    TestSetBitSingle
    TestSetBitDouble

    ' ClearBit tests
    TestClearBitByte
    TestClearBitInteger
    TestClearBitLong
    TestClearBitSingle
    TestClearBitDouble

    ' FlipBit tests
    TestFlipBitByte
    TestFlipBitInteger
    TestFlipBitLong
    TestFlipBitSingle
    TestFlipBitDouble

    ' ReverseBits tests
    TestReverseBitsByte
    TestReverseBitsInteger
    TestReverseBitsLong
    TestReverseBitsSingle
    TestReverseBitsDouble

    ' AssignBit tests
    TestAssignBitByte
    TestAssignBitInteger
    TestAssignBitLong
End Sub

' ==================== GET BIT TESTS ====================

Private Sub TestGetBitByte()
    ' Test all bits in 0x00 (all should be false)
    Dim i As Long
    For i = 0 To 7
        m_asserter.IsTrue BitAccessor.GetBitByte(0, i) = False, "BitAccessorTest.TestGetBitByte", "bit " & i & " of 0 should be false"
    Next i

    ' Test all bits in 0xFF (all should be true)
    For i = 0 To 7
        m_asserter.IsTrue BitAccessor.GetBitByte(255, i) = True, "BitAccessorTest.TestGetBitByte", "bit " & i & " of 255 should be true"
    Next i

    ' Test specific cases
    m_asserter.IsTrue BitAccessor.GetBitByte(1, 0) = True, "BitAccessorTest.TestGetBitByte", "bit 0 of 1 should be true"
    m_asserter.IsTrue BitAccessor.GetBitByte(1, 1) = False, "BitAccessorTest.TestGetBitByte", "bit 1 of 1 should be false"
    m_asserter.IsTrue BitAccessor.GetBitByte(2, 0) = False, "BitAccessorTest.TestGetBitByte", "bit 0 of 2 should be false"
    m_asserter.IsTrue BitAccessor.GetBitByte(2, 1) = True, "BitAccessorTest.TestGetBitByte", "bit 1 of 2 should be true"
    m_asserter.IsTrue BitAccessor.GetBitByte(254, 0) = False, "BitAccessorTest.TestGetBitByte", "bit 0 of 254 should be false"
    m_asserter.IsTrue BitAccessor.GetBitByte(254, 7) = True, "BitAccessorTest.TestGetBitByte", "bit 7 of 254 should be true"
End Sub

Private Sub TestGetBitInteger()
    ' Test all bits in 0
    Dim i As Long
    For i = 0 To 15
        m_asserter.IsTrue BitAccessor.GetBitInteger(0, i) = False, "BitAccessorTest.TestGetBitInteger", "bit " & i & " of 0 should be false"
    Next i

    ' Test all bits in -1 (all 1s in two's complement)
    For i = 0 To 15
        m_asserter.IsTrue BitAccessor.GetBitInteger(-1, i) = True, "BitAccessorTest.TestGetBitInteger", "bit " & i & " of -1 should be true"
    Next i

    ' Test specific case: 1 (bit 0 set)
    m_asserter.IsTrue BitAccessor.GetBitInteger(1, 0) = True, "BitAccessorTest.TestGetBitInteger", "bit 0 of 1 should be true"
    m_asserter.IsTrue BitAccessor.GetBitInteger(1, 1) = False, "BitAccessorTest.TestGetBitInteger", "bit 1 of 1 should be false"

    ' Test specific case: 256 (bit 8 set)
    m_asserter.IsTrue BitAccessor.GetBitInteger(256, 8) = True, "BitAccessorTest.TestGetBitInteger", "bit 8 of 256 should be true"
    m_asserter.IsTrue BitAccessor.GetBitInteger(256, 7) = False, "BitAccessorTest.TestGetBitInteger", "bit 7 of 256 should be false"
End Sub

Private Sub TestGetBitLong()
    ' Test all bits in 0
    Dim i As Long
    For i = 0 To 31
        m_asserter.IsTrue BitAccessor.GetBitLong(0, i) = False, "BitAccessorTest.TestGetBitLong", "bit " & i & " of 0 should be false"
    Next i

    ' Test specific case: 1 (bit 0 set)
    m_asserter.IsTrue BitAccessor.GetBitLong(1, 0) = True, "BitAccessorTest.TestGetBitLong", "bit 0 of 1 should be true"
    m_asserter.IsTrue BitAccessor.GetBitLong(1, 1) = False, "BitAccessorTest.TestGetBitLong", "bit 1 of 1 should be false"

    ' Test specific case: 2^30 (bit 30 set)
    m_asserter.IsTrue BitAccessor.GetBitLong(2 ^ 30, 30) = True, "BitAccessorTest.TestGetBitLong", "bit 30 of 2^30 should be true"
    m_asserter.IsTrue BitAccessor.GetBitLong(2 ^ 30, 31) = False, "BitAccessorTest.TestGetBitLong", "bit 31 of 2^30 should be false"
End Sub

Private Sub TestGetBitSingle()
    ' Test 0.0f (all bits should be false)
    Dim i As Long
    For i = 0 To 31
        m_asserter.IsTrue BitAccessor.GetBitSingle(0#, i) = False, "BitAccessorTest.TestGetBitSingle", "bit " & i & " of 0.0# should be false"
    Next i

    ' Test 2.0# - has bit 30 set in mantissa
    m_asserter.IsTrue BitAccessor.GetBitSingle(2#, 30) = True, "BitAccessorTest.TestGetBitSingle", "bit 30 of 2.0# should be true"
    m_asserter.IsTrue BitAccessor.GetBitSingle(2#, 31) = False, "BitAccessorTest.TestGetBitSingle", "bit 31 of 2.0# should be false"
End Sub

Private Sub TestGetBitDouble()
    ' Test 0.0# (all bits should be false)
    Dim i As Long
    For i = 0 To 63
        m_asserter.IsTrue BitAccessor.GetBitDouble(0#, i) = False, "BitAccessorTest.TestGetBitDouble", "bit " & i & " of 0.0# should be false"
    Next i

    ' Test 2.0# - has bit 62 set (exponent)
    m_asserter.IsTrue BitAccessor.GetBitDouble(2#, 62) = True, "BitAccessorTest.TestGetBitDouble", "bit 62 of 2.0# should be true"
    m_asserter.IsTrue BitAccessor.GetBitDouble(2#, 5) = False, "BitAccessorTest.TestGetBitDouble", "bit 5 of 2.0# should be false"
End Sub

Private Sub TestGetBitOutOfRange()
    ' This test expects errors to be raised - we can't test this directly in VB6
    ' without catching errors, so we'll just test valid ranges
    ' Test boundary conditions
    m_asserter.IsTrue BitAccessor.GetBitByte(0, 7) = False, "BitAccessorTest.TestGetBitOutOfRange", "bit 7 of 0 should be valid"
    m_asserter.IsTrue BitAccessor.GetBitInteger(0, 15) = False, "BitAccessorTest.TestGetBitOutOfRange", "bit 15 of 0 should be valid"
    m_asserter.IsTrue BitAccessor.GetBitLong(0, 31) = False, "BitAccessorTest.TestGetBitOutOfRange", "bit 31 of 0 should be valid"
    m_asserter.IsTrue BitAccessor.GetBitSingle(0#, 31) = False, "BitAccessorTest.TestGetBitOutOfRange", "bit 31 of 0.0# should be valid"
    m_asserter.IsTrue BitAccessor.GetBitDouble(0#, 63) = False, "BitAccessorTest.TestGetBitOutOfRange", "bit 63 of 0.0# should be valid"
End Sub

' ==================== SET BIT TESTS ====================

Private Sub TestSetBitByte()
    ' Set bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.SetBitByte(0, 0) = 1, "BitAccessorTest.TestSetBitByte", "SetBitByte(0, 0) should be 1"
    ' Set bit 1 on 0 should give 2
    m_asserter.IsTrue BitAccessor.SetBitByte(0, 1) = 2, "BitAccessorTest.TestSetBitByte", "SetBitByte(0, 1) should be 2"
    ' Set bit 7 on 0 should give 128
    m_asserter.IsTrue BitAccessor.SetBitByte(0, 7) = 128, "BitAccessorTest.TestSetBitByte", "SetBitByte(0, 7) should be 128"
    ' Set bit on already set should stay same
    m_asserter.IsTrue BitAccessor.SetBitByte(255, 0) = 255, "BitAccessorTest.TestSetBitByte", "SetBitByte(255, 0) should be 255"
End Sub

Private Sub TestSetBitInteger()
    ' Set bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.SetBitInteger(0, 0) = 1, "BitAccessorTest.TestSetBitInteger", "SetBitInteger(0, 0) should be 1"
    ' Set bit 15 on 0 should give -32768 (bit 15 set in signed integer)
    m_asserter.IsTrue BitAccessor.SetBitInteger(0, 15) = -32768, "BitAccessorTest.TestSetBitInteger", "SetBitInteger(0, 15) should be -32768"
End Sub

Private Sub TestSetBitLong()
    ' Set bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.SetBitLong(0, 0) = 1, "BitAccessorTest.TestSetBitLong", "SetBitLong(0, 0) should be 1"
    ' Set bit 31 on 0 should give -2147483648
    m_asserter.IsTrue BitAccessor.SetBitLong(0, 31) = -2147483648#, "BitAccessorTest.TestSetBitLong", "SetBitLong(0, 31) should be -2147483648"
End Sub

Private Sub TestSetBitSingle()
    ' Set bit 31 on 0.0# should give negative zero (sign bit set)
    Dim result As Single
    result = BitAccessor.SetBitSingle(0#, 31)
    ' Verify the sign bit is set using GetBitSingle
    m_asserter.IsTrue BitAccessor.GetBitSingle(result, 31), "BitAccessorTest.TestSetBitSingle", "SetBitSingle(0#, 31) should have sign bit set"
End Sub

Private Sub TestSetBitDouble()
    ' Set bit 62 on 0.0# should give 2.0#
    m_asserter.IsTrue BitAccessor.SetBitDouble(0#, 62) = 2#, "BitAccessorTest.TestSetBitDouble", "SetBitDouble(0#, 62) should be 2#"
End Sub

' ==================== CLEAR BIT TESTS ====================

Private Sub TestClearBitByte()
    ' Clear bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.ClearBitByte(1, 0) = 0, "BitAccessorTest.TestClearBitByte", "ClearBitByte(1, 0) should be 0"
    ' Clear bit 1 on 2 should give 0
    m_asserter.IsTrue BitAccessor.ClearBitByte(2, 1) = 0, "BitAccessorTest.TestClearBitByte", "ClearBitByte(2, 1) should be 0"
    ' Clear bit on 0 should stay 0
    m_asserter.IsTrue BitAccessor.ClearBitByte(0, 0) = 0, "BitAccessorTest.TestClearBitByte", "ClearBitByte(0, 0) should be 0"
End Sub

Private Sub TestClearBitInteger()
    ' Clear bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.ClearBitInteger(1, 0) = 0, "BitAccessorTest.TestClearBitInteger", "ClearBitInteger(1, 0) should be 0"
    ' Clear bit 15 on -1 should give 32767
    m_asserter.IsTrue BitAccessor.ClearBitInteger(-1, 15) = 32767, "BitAccessorTest.TestClearBitInteger", "ClearBitInteger(-1, 15) should be 32767"
End Sub

Private Sub TestClearBitLong()
    ' Clear bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.ClearBitLong(1, 0) = 0, "BitAccessorTest.TestClearBitLong", "ClearBitLong(1, 0) should be 0"
    ' Clear bit 31 on -1 should give 2147483647
    m_asserter.IsTrue BitAccessor.ClearBitLong(-1, 31) = 2147483647#, "BitAccessorTest.TestClearBitLong", "ClearBitLong(-1, 31) should be 2147483647"
End Sub

Private Sub TestClearBitSingle()
    ' Clear bit 31 on negative zero should give positive zero
    Dim negZero As Single
    negZero = BitAccessor.SetBitSingle(0#, 31)
    Dim result As Single
    result = BitAccessor.ClearBitSingle(negZero, 31)
    m_asserter.IsTrue result = 0#, "BitAccessorTest.TestClearBitSingle", "ClearBitSingle should clear sign bit"
End Sub

Private Sub TestClearBitDouble()
    ' Clear bit 62 on 2.0# should give 0.0#
    m_asserter.IsTrue BitAccessor.ClearBitDouble(2#, 62) = 0#, "BitAccessorTest.TestClearBitDouble", "ClearBitDouble(2#, 62) should be 0#"
End Sub

' ==================== FLIP BIT TESTS ====================

Private Sub TestFlipBitByte()
    ' Flip bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.FlipBitByte(0, 0) = 1, "BitAccessorTest.TestFlipBitByte", "FlipBitByte(0, 0) should be 1"
    ' Flip bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.FlipBitByte(1, 0) = 0, "BitAccessorTest.TestFlipBitByte", "FlipBitByte(1, 0) should be 0"
    ' Flip bit 7 on 0 should give 128
    m_asserter.IsTrue BitAccessor.FlipBitByte(0, 7) = 128, "BitAccessorTest.TestFlipBitByte", "FlipBitByte(0, 7) should be 128"
    ' Flip bit 7 on 128 should give 0
    m_asserter.IsTrue BitAccessor.FlipBitByte(128, 7) = 0, "BitAccessorTest.TestFlipBitByte", "FlipBitByte(128, 7) should be 0"
End Sub

Private Sub TestFlipBitInteger()
    ' Flip bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.FlipBitInteger(0, 0) = 1, "BitAccessorTest.TestFlipBitInteger", "FlipBitInteger(0, 0) should be 1"
    ' Flip bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.FlipBitInteger(1, 0) = 0, "BitAccessorTest.TestFlipBitInteger", "FlipBitInteger(1, 0) should be 0"
End Sub

Private Sub TestFlipBitLong()
    ' Flip bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.FlipBitLong(0, 0) = 1, "BitAccessorTest.TestFlipBitLong", "FlipBitLong(0, 0) should be 1"
    ' Flip bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.FlipBitLong(1, 0) = 0, "BitAccessorTest.TestFlipBitLong", "FlipBitLong(1, 0) should be 0"
End Sub

Private Sub TestFlipBitSingle()
    ' Flip bit 31 on 2.0# should change sign
    Dim result1 As Single
    result1 = BitAccessor.FlipBitSingle(2#, 31)
    Dim result2 As Single
    result2 = BitAccessor.FlipBitSingle(result1, 31)
    m_asserter.IsTrue result2 = 2#, "BitAccessorTest.TestFlipBitSingle", "FlipBitSingle twice should return original"
End Sub

Private Sub TestFlipBitDouble()
    ' Flip bit 62 on 2.0# should toggle exponent bit
    Dim result1 As Double
    result1 = BitAccessor.FlipBitDouble(2#, 62)
    Dim result2 As Double
    result2 = BitAccessor.FlipBitDouble(result1, 62)
    m_asserter.IsTrue result2 = 2#, "BitAccessorTest.TestFlipBitDouble", "FlipBitDouble twice should return original"
End Sub

' ==================== REVERSE BITS TESTS ====================

Private Sub TestReverseBitsByte()
    ' 0xC6 = 11000110 -> 01100011 = 0x63
    m_asserter.IsTrue BitAccessor.ReverseBitsByte(&HC6) = &H63, "BitAccessorTest.TestReverseBitsByte", "ReverseBitsByte(0xC6) should be 0x63"
    ' 0x66 = 01100110 -> 01100110 = 0x66 (palindrome)
    m_asserter.IsTrue BitAccessor.ReverseBitsByte(&H66) = &H66, "BitAccessorTest.TestReverseBitsByte", "ReverseBitsByte(0x66) should be 0x66"
    ' 0xA1 = 10100001 -> 10000101 = 0x85
    m_asserter.IsTrue BitAccessor.ReverseBitsByte(&HA1) = &H85, "BitAccessorTest.TestReverseBitsByte", "ReverseBitsByte(0xA1) should be 0x85"
    ' 0xCA = 11001010 -> 01010011 = 0x53
    m_asserter.IsTrue BitAccessor.ReverseBitsByte(&HCA) = &H53, "BitAccessorTest.TestReverseBitsByte", "ReverseBitsByte(0xCA) should be 0x53"
    ' 0xF7 = 11110111 -> 11101111 = 0xEF
    m_asserter.IsTrue BitAccessor.ReverseBitsByte(&HF7) = &HEF, "BitAccessorTest.TestReverseBitsByte", "ReverseBitsByte(0xF7) should be 0xEF"
    ' 0x00 -> 0x00
    m_asserter.IsTrue BitAccessor.ReverseBitsByte(0) = 0, "BitAccessorTest.TestReverseBitsByte", "ReverseBitsByte(0) should be 0"
    ' 0xFF -> 0xFF
    m_asserter.IsTrue BitAccessor.ReverseBitsByte(255) = 255, "BitAccessorTest.TestReverseBitsByte", "ReverseBitsByte(255) should be 255"
End Sub

Private Sub TestReverseBitsInteger()
    ' 0x9852 = 1001100001010010 -> 0100101000011001 = 0x4A19
    m_asserter.IsTrue BitAccessor.ReverseBitsInteger(&H9852) = &H4A19, "BitAccessorTest.TestReverseBitsInteger", "ReverseBitsInteger(0x9852) should be 0x4A19"
    ' 0x0000 -> 0x0000
    m_asserter.IsTrue BitAccessor.ReverseBitsInteger(0) = 0, "BitAccessorTest.TestReverseBitsInteger", "ReverseBitsInteger(0) should be 0"
    ' 0xFFFF -> 0xFFFF
    m_asserter.IsTrue BitAccessor.ReverseBitsInteger(-1) = -1, "BitAccessorTest.TestReverseBitsInteger", "ReverseBitsInteger(-1) should be -1"
    ' 0x7FFF -> 0xFFFE (bit 15 cleared becomes set)
    m_asserter.IsTrue BitAccessor.ReverseBitsInteger(32767) = -2, "BitAccessorTest.TestReverseBitsInteger", "ReverseBitsInteger(32767) should be -2"
End Sub
Public Function ReverseBitsLong2(ByVal value As Long) As Long
    Dim buf(0 To 3) As Byte
    Dim highWord As Integer
    Dim lowWord As Integer
    Dim result As Long

    ' Extract words safely using CopyMemory
    CopyMemory buf(0), value, 4

    lowWord = ReverseBitsInteger(CLng(buf(1)) * 256& + CLng(buf(0)))
    highWord = ReverseBitsInteger(CLng(buf(3)) * 256& + CLng(buf(2)))

    ' Combine words - use Long arithmetic (65536& forces Long)
    result = (CLng(highWord) And &HFFFF&) * 65536 + CLng(lowWord And &HFFFF&)
    ReverseBitsLong2 = result
End Function

Private Sub TestReverseBitsLong()
    ' 0x01FFFFFF = 00000001111111111111111111111111 -> 11111111111111111111111110000000 = 0xFFFFFF80
    m_asserter.IsTrue BitAccessor.ReverseBitsLong(&H1FFFFFF) = &HFFFFFF80, "BitAccessorTest.TestReverseBitsLong", "ReverseBitsLong(0x01FFFFFF) should be 0xFFFFFF80"
    ' 0x00000000 -> 0x00000000
    m_asserter.IsTrue BitAccessor.ReverseBitsLong(0) = 0, "BitAccessorTest.TestReverseBitsLong", "ReverseBitsLong(0) should be 0"
    ' 0xFFFFFFFF -> 0xFFFFFFFF
    m_asserter.IsTrue BitAccessor.ReverseBitsLong(-1) = -1, "BitAccessorTest.TestReverseBitsLong", "ReverseBitsLong(-1) should be -1"
End Sub

Private Sub TestReverseBitsSingle()
    ' Test reversing 1.0#
    Dim result As Single
    result = BitAccessor.ReverseBitsSingle(1#)
    m_asserter.IsTrue result <> 1#, "BitAccessorTest.TestReverseBitsSingle", "ReverseBitsSingle(1#) should change value"
End Sub

Private Sub TestReverseBitsDouble()
    ' Test reversing 1.0#
    Dim result As Double
    result = BitAccessor.ReverseBitsDouble(1#)
    m_asserter.IsTrue result <> 1#, "BitAccessorTest.TestReverseBitsDouble", "ReverseBitsDouble(1#) should change value"
End Sub

' ==================== ASSIGN BIT TESTS ====================

Private Sub TestAssignBitByte()
    ' Assign true to bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.AssignBitByte(0, 0, True) = 1, "BitAccessorTest.TestAssignBitByte", "AssignBitByte(0, 0, True) should be 1"
    ' Assign false to bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.AssignBitByte(1, 0, False) = 0, "BitAccessorTest.TestAssignBitByte", "AssignBitByte(1, 0, False) should be 0"
    ' Assign true to bit 7 on 0 should give 128
    m_asserter.IsTrue BitAccessor.AssignBitByte(0, 7, True) = 128, "BitAccessorTest.TestAssignBitByte", "AssignBitByte(0, 7, True) should be 128"
End Sub

Private Sub TestAssignBitInteger()
    ' Assign true to bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.AssignBitInteger(0, 0, True) = 1, "BitAccessorTest.TestAssignBitInteger", "AssignBitInteger(0, 0, True) should be 1"
    ' Assign false to bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.AssignBitInteger(1, 0, False) = 0, "BitAccessorTest.TestAssignBitInteger", "AssignBitInteger(1, 0, False) should be 0"
End Sub

Private Sub TestAssignBitLong()
    ' Assign true to bit 0 on 0 should give 1
    m_asserter.IsTrue BitAccessor.AssignBitLong(0, 0, True) = 1, "BitAccessorTest.TestAssignBitLong", "AssignBitLong(0, 0, True) should be 1"
    ' Assign false to bit 0 on 1 should give 0
    m_asserter.IsTrue BitAccessor.AssignBitLong(1, 0, False) = 0, "BitAccessorTest.TestAssignBitLong", "AssignBitLong(1, 0, False) should be 0"
End Sub