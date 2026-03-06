VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BitAccessor"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' Windows API declaration for memory copying
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

' Fixed-size buffer structures for byte manipulation (avoids heap allocation)
Private Type ByteBuffer2
    bytes(0 To 1) As Byte
End Type

Private Type ByteBuffer4
    bytes(0 To 3) As Byte
End Type

Private Type ByteBuffer8
    bytes(0 To 7) As Byte
End Type

' Bit length constants
Private Const ByteBitLength As Long = 8
Private Const IntegerBitLength As Long = 16
Private Const LongBitLength As Long = 32
Private Const DoubleBitLength As Long = 64

' Bit reverse lookup table for byte reversal
Private BitReverseTable256(0 To 255) As Byte

' Power of 2 lookup tables for efficient bit manipulation
' Avoids VB6 ^ operator which returns Double and causes overflow issues
Private PowerOf2TableByte(0 To 7) As Byte
Private PowerOf2TableInteger(0 To 15) As Integer
Private PowerOf2TableLong(0 To 31) As Long

' Reverses bits in a single byte (used for table initialization)
' This uses a lookup table approach for efficiency
Private Sub InitBitReverseTable()
    ' Pre-computed bit reversal table matching C# BitReverseTable256
    BitReverseTable256(0) = &H0
    BitReverseTable256(1) = &H80
    BitReverseTable256(2) = &H40
    BitReverseTable256(3) = &HC0
    BitReverseTable256(4) = &H20
    BitReverseTable256(5) = &HA0
    BitReverseTable256(6) = &H60
    BitReverseTable256(7) = &HE0
    BitReverseTable256(8) = &H10
    BitReverseTable256(9) = &H90
    BitReverseTable256(10) = &H50
    BitReverseTable256(11) = &HD0
    BitReverseTable256(12) = &H30
    BitReverseTable256(13) = &HB0
    BitReverseTable256(14) = &H70
    BitReverseTable256(15) = &HF0
    BitReverseTable256(16) = &H8
    BitReverseTable256(17) = &H88
    BitReverseTable256(18) = &H48
    BitReverseTable256(19) = &HC8
    BitReverseTable256(20) = &H28
    BitReverseTable256(21) = &HA8
    BitReverseTable256(22) = &H68
    BitReverseTable256(23) = &HE8
    BitReverseTable256(24) = &H18
    BitReverseTable256(25) = &H98
    BitReverseTable256(26) = &H58
    BitReverseTable256(27) = &HD8
    BitReverseTable256(28) = &H38
    BitReverseTable256(29) = &HB8
    BitReverseTable256(30) = &H78
    BitReverseTable256(31) = &HF8
    BitReverseTable256(32) = &H4
    BitReverseTable256(33) = &H84
    BitReverseTable256(34) = &H44
    BitReverseTable256(35) = &HC4
    BitReverseTable256(36) = &H24
    BitReverseTable256(37) = &HA4
    BitReverseTable256(38) = &H64
    BitReverseTable256(39) = &HE4
    BitReverseTable256(40) = &H14
    BitReverseTable256(41) = &H94
    BitReverseTable256(42) = &H54
    BitReverseTable256(43) = &HD4
    BitReverseTable256(44) = &H34
    BitReverseTable256(45) = &HB4
    BitReverseTable256(46) = &H74
    BitReverseTable256(47) = &HF4
    BitReverseTable256(48) = &HC
    BitReverseTable256(49) = &H8C
    BitReverseTable256(50) = &H4C
    BitReverseTable256(51) = &HCC
    BitReverseTable256(52) = &H2C
    BitReverseTable256(53) = &HAC
    BitReverseTable256(54) = &H6C
    BitReverseTable256(55) = &HEC
    BitReverseTable256(56) = &H1C
    BitReverseTable256(57) = &H9C
    BitReverseTable256(58) = &H5C
    BitReverseTable256(59) = &HDC
    BitReverseTable256(60) = &H3C
    BitReverseTable256(61) = &HBC
    BitReverseTable256(62) = &H7C
    BitReverseTable256(63) = &HFC
    BitReverseTable256(64) = &H2
    BitReverseTable256(65) = &H82
    BitReverseTable256(66) = &H42
    BitReverseTable256(67) = &HC2
    BitReverseTable256(68) = &H22
    BitReverseTable256(69) = &HA2
    BitReverseTable256(70) = &H62
    BitReverseTable256(71) = &HE2
    BitReverseTable256(72) = &H12
    BitReverseTable256(73) = &H92
    BitReverseTable256(74) = &H52
    BitReverseTable256(75) = &HD2
    BitReverseTable256(76) = &H32
    BitReverseTable256(77) = &HB2
    BitReverseTable256(78) = &H72
    BitReverseTable256(79) = &HF2
    BitReverseTable256(80) = &HA
    BitReverseTable256(81) = &H8A
    BitReverseTable256(82) = &H4A
    BitReverseTable256(83) = &HCA
    BitReverseTable256(84) = &H2A
    BitReverseTable256(85) = &HAA
    BitReverseTable256(86) = &H6A
    BitReverseTable256(87) = &HEA
    BitReverseTable256(88) = &H1A
    BitReverseTable256(89) = &H9A
    BitReverseTable256(90) = &H5A
    BitReverseTable256(91) = &HDA
    BitReverseTable256(92) = &H3A
    BitReverseTable256(93) = &HBA
    BitReverseTable256(94) = &H7A
    BitReverseTable256(95) = &HFA
    BitReverseTable256(96) = &H6
    BitReverseTable256(97) = &H86
    BitReverseTable256(98) = &H46
    BitReverseTable256(99) = &HC6
    BitReverseTable256(100) = &H26
    BitReverseTable256(101) = &HA6
    BitReverseTable256(102) = &H66
    BitReverseTable256(103) = &HE6
    BitReverseTable256(104) = &H16
    BitReverseTable256(105) = &H96
    BitReverseTable256(106) = &H56
    BitReverseTable256(107) = &HD6
    BitReverseTable256(108) = &H36
    BitReverseTable256(109) = &HB6
    BitReverseTable256(110) = &H76
    BitReverseTable256(111) = &HF6
    BitReverseTable256(112) = &HE
    BitReverseTable256(113) = &H8E
    BitReverseTable256(114) = &H4E
    BitReverseTable256(115) = &HCE
    BitReverseTable256(116) = &H2E
    BitReverseTable256(117) = &HAE
    BitReverseTable256(118) = &H6E
    BitReverseTable256(119) = &HEE
    BitReverseTable256(120) = &H1E
    BitReverseTable256(121) = &H9E
    BitReverseTable256(122) = &H5E
    BitReverseTable256(123) = &HDE
    BitReverseTable256(124) = &H3E
    BitReverseTable256(125) = &HBE
    BitReverseTable256(126) = &H7E
    BitReverseTable256(127) = &HFE
    BitReverseTable256(128) = &H1
    BitReverseTable256(129) = &H81
    BitReverseTable256(130) = &H41
    BitReverseTable256(131) = &HC1
    BitReverseTable256(132) = &H21
    BitReverseTable256(133) = &HA1
    BitReverseTable256(134) = &H61
    BitReverseTable256(135) = &HE1
    BitReverseTable256(136) = &H11
    BitReverseTable256(137) = &H91
    BitReverseTable256(138) = &H51
    BitReverseTable256(139) = &HD1
    BitReverseTable256(140) = &H31
    BitReverseTable256(141) = &HB1
    BitReverseTable256(142) = &H71
    BitReverseTable256(143) = &HF1
    BitReverseTable256(144) = &H9
    BitReverseTable256(145) = &H89
    BitReverseTable256(146) = &H49
    BitReverseTable256(147) = &HC9
    BitReverseTable256(148) = &H29
    BitReverseTable256(149) = &HA9
    BitReverseTable256(150) = &H69
    BitReverseTable256(151) = &HE9
    BitReverseTable256(152) = &H19
    BitReverseTable256(153) = &H99
    BitReverseTable256(154) = &H59
    BitReverseTable256(155) = &HD9
    BitReverseTable256(156) = &H39
    BitReverseTable256(157) = &HB9
    BitReverseTable256(158) = &H79
    BitReverseTable256(159) = &HF9
    BitReverseTable256(160) = &H5
    BitReverseTable256(161) = &H85
    BitReverseTable256(162) = &H45
    BitReverseTable256(163) = &HC5
    BitReverseTable256(164) = &H25
    BitReverseTable256(165) = &HA5
    BitReverseTable256(166) = &H65
    BitReverseTable256(167) = &HE5
    BitReverseTable256(168) = &H15
    BitReverseTable256(169) = &H95
    BitReverseTable256(170) = &H55
    BitReverseTable256(171) = &HD5
    BitReverseTable256(172) = &H35
    BitReverseTable256(173) = &HB5
    BitReverseTable256(174) = &H75
    BitReverseTable256(175) = &HF5
    BitReverseTable256(176) = &HD
    BitReverseTable256(177) = &H8D
    BitReverseTable256(178) = &H4D
    BitReverseTable256(179) = &HCD
    BitReverseTable256(180) = &H2D
    BitReverseTable256(181) = &HAD
    BitReverseTable256(182) = &H6D
    BitReverseTable256(183) = &HED
    BitReverseTable256(184) = &H1D
    BitReverseTable256(185) = &H9D
    BitReverseTable256(186) = &H5D
    BitReverseTable256(187) = &HDD
    BitReverseTable256(188) = &H3D
    BitReverseTable256(189) = &HBD
    BitReverseTable256(190) = &H7D
    BitReverseTable256(191) = &HFD
    BitReverseTable256(192) = &H3
    BitReverseTable256(193) = &H83
    BitReverseTable256(194) = &H43
    BitReverseTable256(195) = &HC3
    BitReverseTable256(196) = &H23
    BitReverseTable256(197) = &HA3
    BitReverseTable256(198) = &H63
    BitReverseTable256(199) = &HE3
    BitReverseTable256(200) = &H13
    BitReverseTable256(201) = &H93
    BitReverseTable256(202) = &H53
    BitReverseTable256(203) = &HD3
    BitReverseTable256(204) = &H33
    BitReverseTable256(205) = &HB3
    BitReverseTable256(206) = &H73
    BitReverseTable256(207) = &HF3
    BitReverseTable256(208) = &HB
    BitReverseTable256(209) = &H8B
    BitReverseTable256(210) = &H4B
    BitReverseTable256(211) = &HCB
    BitReverseTable256(212) = &H2B
    BitReverseTable256(213) = &HAB
    BitReverseTable256(214) = &H6B
    BitReverseTable256(215) = &HEB
    BitReverseTable256(216) = &H1B
    BitReverseTable256(217) = &H9B
    BitReverseTable256(218) = &H5B
    BitReverseTable256(219) = &HDB
    BitReverseTable256(220) = &H3B
    BitReverseTable256(221) = &HBB
    BitReverseTable256(222) = &H7B
    BitReverseTable256(223) = &HFB
    BitReverseTable256(224) = &H7
    BitReverseTable256(225) = &H87
    BitReverseTable256(226) = &H47
    BitReverseTable256(227) = &HC7
    BitReverseTable256(228) = &H27
    BitReverseTable256(229) = &HA7
    BitReverseTable256(230) = &H67
    BitReverseTable256(231) = &HE7
    BitReverseTable256(232) = &H17
    BitReverseTable256(233) = &H97
    BitReverseTable256(234) = &H57
    BitReverseTable256(235) = &HD7
    BitReverseTable256(236) = &H37
    BitReverseTable256(237) = &HB7
    BitReverseTable256(238) = &H77
    BitReverseTable256(239) = &HF7
    BitReverseTable256(240) = &HF
    BitReverseTable256(241) = &H8F
    BitReverseTable256(242) = &H4F
    BitReverseTable256(243) = &HCF
    BitReverseTable256(244) = &H2F
    BitReverseTable256(245) = &HAF
    BitReverseTable256(246) = &H6F
    BitReverseTable256(247) = &HEF
    BitReverseTable256(248) = &H1F
    BitReverseTable256(249) = &H9F
    BitReverseTable256(250) = &H5F
    BitReverseTable256(251) = &HDF
    BitReverseTable256(252) = &H3F
    BitReverseTable256(253) = &HBF
    BitReverseTable256(254) = &H7F
    BitReverseTable256(255) = &HFF
End Sub

' Initializes power of 2 lookup tables
Private Sub InitPowerOf2Tables()
    ' Byte: 2^0 to 2^7
    PowerOf2TableByte(0) = &H1
    PowerOf2TableByte(1) = &H2
    PowerOf2TableByte(2) = &H4
    PowerOf2TableByte(3) = &H8
    PowerOf2TableByte(4) = &H10
    PowerOf2TableByte(5) = &H20
    PowerOf2TableByte(6) = &H40
    PowerOf2TableByte(7) = &H80

    ' Integer: 2^0 to 2^15
    PowerOf2TableInteger(0) = &H1
    PowerOf2TableInteger(1) = &H2
    PowerOf2TableInteger(2) = &H4
    PowerOf2TableInteger(3) = &H8
    PowerOf2TableInteger(4) = &H10
    PowerOf2TableInteger(5) = &H20
    PowerOf2TableInteger(6) = &H40
    PowerOf2TableInteger(7) = &H80
    PowerOf2TableInteger(8) = &H100
    PowerOf2TableInteger(9) = &H200
    PowerOf2TableInteger(10) = &H400
    PowerOf2TableInteger(11) = &H800
    PowerOf2TableInteger(12) = &H1000
    PowerOf2TableInteger(13) = &H2000
    PowerOf2TableInteger(14) = &H4000
    PowerOf2TableInteger(15) = &H8000

    ' Long: 2^0 to 2^31
    PowerOf2TableLong(0) = &H1
    PowerOf2TableLong(1) = &H2
    PowerOf2TableLong(2) = &H4
    PowerOf2TableLong(3) = &H8
    PowerOf2TableLong(4) = &H10
    PowerOf2TableLong(5) = &H20
    PowerOf2TableLong(6) = &H40
    PowerOf2TableLong(7) = &H80
    PowerOf2TableLong(8) = &H100
    PowerOf2TableLong(9) = &H200
    PowerOf2TableLong(10) = &H400
    PowerOf2TableLong(11) = &H800
    PowerOf2TableLong(12) = &H1000
    PowerOf2TableLong(13) = &H2000
    PowerOf2TableLong(14) = &H4000
    PowerOf2TableLong(15) = &H8000
    PowerOf2TableLong(16) = &H10000
    PowerOf2TableLong(17) = &H20000
    PowerOf2TableLong(18) = &H40000
    PowerOf2TableLong(19) = &H80000
    PowerOf2TableLong(20) = &H100000
    PowerOf2TableLong(21) = &H200000
    PowerOf2TableLong(22) = &H400000
    PowerOf2TableLong(23) = &H800000
    PowerOf2TableLong(24) = &H1000000
    PowerOf2TableLong(25) = &H2000000
    PowerOf2TableLong(26) = &H4000000
    PowerOf2TableLong(27) = &H8000000
    PowerOf2TableLong(28) = &H10000000
    PowerOf2TableLong(29) = &H20000000
    PowerOf2TableLong(30) = &H40000000
    PowerOf2TableLong(31) = &H80000000
End Sub

' Class initialization - populate lookup tables
Private Sub Class_Initialize()
    InitBitReverseTable
    InitPowerOf2Tables
End Sub

' Asserts that bit index is within valid range
Private Sub AssertBitRange(ByVal index As Long, ByVal bitLength As Long)
    If index < 0 Or index >= bitLength Then
        Err.Raise ErrorCodes.InvalidProcedureCall, "BitAccessor.AssertBitRange", "Bit index " & CStr(index) & " out of range (0-" & CStr(bitLength - 1) & ")"
    End If
End Sub

' Computes 2^n as a Long using lookup table
Private Function PowerOf2Long(ByVal exponent As Long) As Long
    If exponent < 0 Or exponent > 31 Then
        Err.Raise ErrorCodes.Overflow, "BitAccessor.PowerOf2Long", "Exponent out of range"
    End If
    PowerOf2Long = PowerOf2TableLong(exponent)
End Function

' Computes 2^n as an Integer using lookup table
Private Function PowerOf2Integer(ByVal exponent As Long) As Integer
    If exponent < 0 Or exponent > 15 Then
        Err.Raise ErrorCodes.Overflow, "BitAccessor.PowerOf2Integer", "Exponent out of range"
    End If
    PowerOf2Integer = PowerOf2TableInteger(exponent)
End Function

' Computes 2^n as a Byte using lookup table
Private Function PowerOf2Byte(ByVal exponent As Long) As Byte
    If exponent < 0 Or exponent > 7 Then
        Err.Raise ErrorCodes.Overflow, "BitAccessor.PowerOf2Byte", "Exponent out of range"
    End If
    PowerOf2Byte = PowerOf2TableByte(exponent)
End Function

' ==================== GET BIT ====================

' Gets a bit at the specified index from a Byte value
' Args:
'   value (Byte): The byte value to get the bit from
'   index (Long): The bit index (0 = LSB, 7 = MSB)
' Returns:
'   Boolean: True if the bit is 1, False if 0
Public Function GetBitByte(ByVal value As Byte, ByVal index As Long) As Boolean
    AssertBitRange index, ByteBitLength
    GetBitByte = (value And PowerOf2Byte(index)) <> 0
End Function

' Gets a bit at the specified index from an Integer value
' Args:
'   value (Integer): The integer value to get the bit from
'   index (Long): The bit index (0 = LSB, 15 = MSB)
' Returns:
'   Boolean: True if the bit is 1, False if 0
Public Function GetBitInteger(ByVal value As Integer, ByVal index As Long) As Boolean
    AssertBitRange index, IntegerBitLength
    GetBitInteger = (value And PowerOf2Integer(index)) <> 0
End Function

' Gets a bit at the specified index from a Long value
' Args:
'   value (Long): The long value to get the bit from
'   index (Long): The bit index (0 = LSB, 31 = MSB)
' Returns:
'   Boolean: True if the bit is 1, False if 0
Public Function GetBitLong(ByVal value As Long, ByVal index As Long) As Boolean
    AssertBitRange index, LongBitLength
    GetBitLong = (value And PowerOf2Long(index)) <> 0
End Function

' Gets a bit at the specified index from a Single value (floating point)
' Args:
'   value (Single): The single value to get the bit from
'   index (Long): The bit index (0 = LSB, 31 = MSB)
' Returns:
'   Boolean: True if the bit is 1, False if 0
Public Function GetBitSingle(ByVal value As Single, ByVal index As Long) As Boolean
    AssertBitRange index, LongBitLength
    GetBitSingle = GetBitLong(BitReinterpret.AsLong(value), index)
End Function

' Gets the low 32 bits of a Double (mantissa portion)
Private Function GetDoubleLow(ByVal value As Double) As Long
    CopyMemory GetDoubleLow, value, 4
End Function

' Gets the high 32 bits of a Double (exponent and sign portion)
Private Function GetDoubleHigh(ByVal value As Double) As Long
    Dim buf As ByteBuffer8
    CopyMemory buf.bytes(0), value, 8
    ' Copy the high 4 bytes directly to result using CopyMemory
    CopyMemory GetDoubleHigh, buf.bytes(4), 4
End Function

' Gets a bit at the specified index from a Double value (floating point)
' Args:
'   value (Double): The double value to get the bit from
'   index (Long): The bit index (0 = LSB, 63 = MSB)
' Returns:
'   Boolean: True if the bit is 1, False if 0
Public Function GetBitDouble(ByVal value As Double, ByVal index As Long) As Boolean
    AssertBitRange index, DoubleBitLength
    If index < LongBitLength Then
        GetBitDouble = GetBitLong(GetDoubleLow(value), index)
    Else
        GetBitDouble = GetBitLong(GetDoubleHigh(value), index - LongBitLength)
    End If
End Function

' ==================== SET BIT ====================

' Sets a bit at the specified index in a Byte value
' Args:
'   value (Byte): The original byte value
'   index (Long): The bit index to set (0 = LSB, 7 = MSB)
' Returns:
'   Byte: The byte value with the specified bit set to 1
Public Function SetBitByte(ByVal value As Byte, ByVal index As Long) As Byte
    AssertBitRange index, ByteBitLength
    SetBitByte = value Or PowerOf2Byte(index)
End Function

' Sets a bit at the specified index in an Integer value
' Args:
'   value (Integer): The original integer value
'   index (Long): The bit index to set (0 = LSB, 15 = MSB)
' Returns:
'   Integer: The integer value with the specified bit set to 1
Public Function SetBitInteger(ByVal value As Integer, ByVal index As Long) As Integer
    AssertBitRange index, IntegerBitLength
    SetBitInteger = value Or PowerOf2Integer(index)
End Function

' Sets a bit at the specified index in a Long value
' Args:
'   value (Long): The original long value
'   index (Long): The bit index to set (0 = LSB, 31 = MSB)
' Returns:
'   Long: The long value with the specified bit set to 1
Public Function SetBitLong(ByVal value As Long, ByVal index As Long) As Long
    AssertBitRange index, LongBitLength
    SetBitLong = value Or PowerOf2Long(index)
End Function

' Sets a bit at the specified index in a Single value
' Args:
'   value (Single): The original single value
'   index (Long): The bit index to set (0 = LSB, 31 = MSB)
' Returns:
'   Single: The single value with the specified bit set to 1
Public Function SetBitSingle(ByVal value As Single, ByVal index As Long) As Single
    AssertBitRange index, LongBitLength
    Dim bits As Long
    bits = BitReinterpret.AsLong(value)
    bits = SetBitLong(bits, index)
    SetBitSingle = BitReinterpret.AsSingle(bits)
End Function

' Sets a bit at the specified index in a Double value
' Args:
'   value (Double): The original double value
'   index (Long): The bit index to set (0 = LSB, 63 = MSB)
' Returns:
'   Double: The double value with the specified bit set to 1
Public Function SetBitDouble(ByVal value As Double, ByVal index As Long) As Double
    AssertBitRange index, DoubleBitLength
    If index < LongBitLength Then
        SetBitDouble = MakeDouble(GetDoubleHigh(value), SetBitLong(GetDoubleLow(value), index))
    Else
        SetBitDouble = MakeDouble(SetBitLong(GetDoubleHigh(value), index - LongBitLength), GetDoubleLow(value))
    End If
End Function

' ==================== CLEAR BIT ====================

' Clears a bit at the specified index in a Byte value
' Args:
'   value (Byte): The original byte value
'   index (Long): The bit index to clear (0 = LSB, 7 = MSB)
' Returns:
'   Byte: The byte value with the specified bit set to 0
Public Function ClearBitByte(ByVal value As Byte, ByVal index As Long) As Byte
    AssertBitRange index, ByteBitLength
    ClearBitByte = value And Not PowerOf2Byte(index)
End Function

' Clears a bit at the specified index in an Integer value
' Args:
'   value (Integer): The original integer value
'   index (Long): The bit index to clear (0 = LSB, 15 = MSB)
' Returns:
'   Integer: The integer value with the specified bit set to 0
Public Function ClearBitInteger(ByVal value As Integer, ByVal index As Long) As Integer
    AssertBitRange index, IntegerBitLength
    ClearBitInteger = value And Not PowerOf2Integer(index)
End Function

' Clears a bit at the specified index in a Long value
' Args:
'   value (Long): The original long value
'   index (Long): The bit index to clear (0 = LSB, 31 = MSB)
' Returns:
'   Long: The long value with the specified bit set to 0
Public Function ClearBitLong(ByVal value As Long, ByVal index As Long) As Long
    AssertBitRange index, LongBitLength
    ClearBitLong = value And Not PowerOf2Long(index)
End Function

' Clears a bit at the specified index in a Single value
' Args:
'   value (Single): The original single value
'   index (Long): The bit index to clear (0 = LSB, 31 = MSB)
' Returns:
'   Single: The single value with the specified bit set to 0
Public Function ClearBitSingle(ByVal value As Single, ByVal index As Long) As Single
    AssertBitRange index, LongBitLength
    Dim bits As Long
    bits = BitReinterpret.AsLong(value)
    bits = ClearBitLong(bits, index)
    ClearBitSingle = BitReinterpret.AsSingle(bits)
End Function

' Clears a bit at the specified index in a Double value
' Args:
'   value (Double): The original double value
'   index (Long): The bit index to clear (0 = LSB, 63 = MSB)
' Returns:
'   Double: The double value with the specified bit set to 0
Public Function ClearBitDouble(ByVal value As Double, ByVal index As Long) As Double
    AssertBitRange index, DoubleBitLength
    If index < LongBitLength Then
        ClearBitDouble = MakeDouble(GetDoubleHigh(value), ClearBitLong(GetDoubleLow(value), index))
    Else
        ClearBitDouble = MakeDouble(ClearBitLong(GetDoubleHigh(value), index - LongBitLength), GetDoubleLow(value))
    End If
End Function

' ==================== FLIP BIT ====================

' Flips a bit at the specified index in a Byte value
' Args:
'   value (Byte): The original byte value
'   index (Long): The bit index to flip (0 = LSB, 7 = MSB)
' Returns:
'   Byte: The byte value with the specified bit flipped
Public Function FlipBitByte(ByVal value As Byte, ByVal index As Long) As Byte
    AssertBitRange index, ByteBitLength
    FlipBitByte = value Xor PowerOf2Byte(index)
End Function

' Flips a bit at the specified index in an Integer value
' Args:
'   value (Integer): The original integer value
'   index (Long): The bit index to flip (0 = LSB, 15 = MSB)
' Returns:
'   Integer: The integer value with the specified bit flipped
Public Function FlipBitInteger(ByVal value As Integer, ByVal index As Long) As Integer
    AssertBitRange index, IntegerBitLength
    FlipBitInteger = value Xor PowerOf2Integer(index)
End Function

' Flips a bit at the specified index in a Long value
' Args:
'   value (Long): The original long value
'   index (Long): The bit index to flip (0 = LSB, 31 = MSB)
' Returns:
'   Long: The long value with the specified bit flipped
Public Function FlipBitLong(ByVal value As Long, ByVal index As Long) As Long
    AssertBitRange index, LongBitLength
    FlipBitLong = value Xor PowerOf2Long(index)
End Function

' Flips a bit at the specified index in a Single value
' Args:
'   value (Single): The original single value
'   index (Long): The bit index to flip (0 = LSB, 31 = MSB)
' Returns:
'   Single: The single value with the specified bit flipped
Public Function FlipBitSingle(ByVal value As Single, ByVal index As Long) As Single
    AssertBitRange index, LongBitLength
    Dim bits As Long
    bits = BitReinterpret.AsLong(value)
    bits = FlipBitLong(bits, index)
    FlipBitSingle = BitReinterpret.AsSingle(bits)
End Function

' Flips a bit at the specified index in a Double value
' Args:
'   value (Double): The original double value
'   index (Long): The bit index to flip (0 = LSB, 63 = MSB)
' Returns:
'   Double: The double value with the specified bit flipped
Public Function FlipBitDouble(ByVal value As Double, ByVal index As Long) As Double
    AssertBitRange index, DoubleBitLength
    If index < LongBitLength Then
        FlipBitDouble = MakeDouble(GetDoubleHigh(value), FlipBitLong(GetDoubleLow(value), index))
    Else
        FlipBitDouble = MakeDouble(FlipBitLong(GetDoubleHigh(value), index - LongBitLength), GetDoubleLow(value))
    End If
End Function

' ==================== ASSIGN BIT ====================

' Assigns a bit value at the specified index in a Byte value
' Args:
'   value (Byte): The original byte value
'   index (Long): The bit index to assign (0 = LSB, 7 = MSB)
'   bitValue (Boolean): The bit value to set (True = 1, False = 0)
' Returns:
'   Byte: The byte value with the specified bit assigned
Public Function AssignBitByte(ByVal value As Byte, ByVal index As Long, ByVal bitValue As Boolean) As Byte
    If bitValue Then
        AssignBitByte = SetBitByte(value, index)
    Else
        AssignBitByte = ClearBitByte(value, index)
    End If
End Function

' Assigns a bit value at the specified index in an Integer value
' Args:
'   value (Integer): The original integer value
'   index (Long): The bit index to assign (0 = LSB, 15 = MSB)
'   bitValue (Boolean): The bit value to set (True = 1, False = 0)
' Returns:
'   Integer: The integer value with the specified bit assigned
Public Function AssignBitInteger(ByVal value As Integer, ByVal index As Long, ByVal bitValue As Boolean) As Integer
    If bitValue Then
        AssignBitInteger = SetBitInteger(value, index)
    Else
        AssignBitInteger = ClearBitInteger(value, index)
    End If
End Function

' Assigns a bit value at the specified index in a Long value
' Args:
'   value (Long): The original long value
'   index (Long): The bit index to assign (0 = LSB, 31 = MSB)
'   bitValue (Boolean): The bit value to set (True = 1, False = 0)
' Returns:
'   Long: The long value with the specified bit assigned
Public Function AssignBitLong(ByVal value As Long, ByVal index As Long, ByVal bitValue As Boolean) As Long
    If bitValue Then
        AssignBitLong = SetBitLong(value, index)
    Else
        AssignBitLong = ClearBitLong(value, index)
    End If
End Function

' Assigns a bit value at the specified index in a Single value
' Args:
'   value (Single): The original single value
'   index (Long): The bit index to assign (0 = LSB, 31 = MSB)
'   bitValue (Boolean): The bit value to set (True = 1, False = 0)
' Returns:
'   Single: The single value with the specified bit assigned
Public Function AssignBitSingle(ByVal value As Single, ByVal index As Long, ByVal bitValue As Boolean) As Boolean
    If bitValue Then
        AssignBitSingle = SetBitSingle(value, index)
    Else
        AssignBitSingle = ClearBitSingle(value, index)
    End If
End Function

' Assigns a bit value at the specified index in a Double value
' Args:
'   value (Double): The original double value
'   index (Long): The bit index to assign (0 = LSB, 63 = MSB)
'   bitValue (Boolean): The bit value to set (True = 1, False = 0)
' Returns:
'   Double: The double value with the specified bit assigned
Public Function AssignBitDouble(ByVal value As Double, ByVal index As Long, ByVal bitValue As Boolean) As Double
    If bitValue Then
        AssignBitDouble = SetBitDouble(value, index)
    Else
        AssignBitDouble = ClearBitDouble(value, index)
    End If
End Function

' ==================== REVERSE BITS ====================

' Reverses all bits in a Byte value (bit order reversal)
' Args:
'   value (Byte): The byte value to reverse
' Returns:
'   Byte: The byte value with bit order reversed
Public Function ReverseBitsByte(ByVal value As Byte) As Byte
    ReverseBitsByte = BitReverseTable256(value)
End Function

' Reverses all bits in an Integer value (bit order reversal)
' Args:
'   value (Integer): The integer value to reverse
' Returns:
'   Integer: The integer value with bit order reversed
Public Function ReverseBitsInteger(ByVal value As Integer) As Integer
    Dim buf As ByteBuffer2
    Dim resultBytes As ByteBuffer2

    ' Extract bytes safely using CopyMemory
    CopyMemory buf.bytes(0), value, 2

    ' Reverse each byte, then swap positions (low becomes high, high becomes low)
    resultBytes.bytes(0) = ReverseBitsByte(buf.bytes(1))
    resultBytes.bytes(1) = ReverseBitsByte(buf.bytes(0))

    CopyMemory ReverseBitsInteger, resultBytes.bytes(0), 2
End Function

' Reverses all bits in a Long value (bit order reversal)
' Args:
'   value (Long): The long value to reverse
' Returns:
'   Long: The long value with bit order reversed
Public Function ReverseBitsLong(ByVal value As Long) As Long
    Dim buf As ByteBuffer4
    Dim reversedBytes As ByteBuffer4

    ' Extract bytes safely using CopyMemory
    CopyMemory buf.bytes(0), value, 4

    ' Reverse each byte, then reverse the byte order
    reversedBytes.bytes(0) = ReverseBitsByte(buf.bytes(3))
    reversedBytes.bytes(1) = ReverseBitsByte(buf.bytes(2))
    reversedBytes.bytes(2) = ReverseBitsByte(buf.bytes(1))
    reversedBytes.bytes(3) = ReverseBitsByte(buf.bytes(0))

    CopyMemory ReverseBitsLong, reversedBytes.bytes(0), 4
End Function

' Reverses all bits in a Single value (bit order reversal)
' Args:
'   value (Single): The single value to reverse
' Returns:
'   Single: The single value with bit order reversed
Public Function ReverseBitsSingle(ByVal value As Single) As Single
    Dim buf As ByteBuffer4
    Dim reversedBytes As ByteBuffer4

    ' Extract bytes using CopyMemory
    CopyMemory buf.bytes(0), value, 4

    ' Reverse each byte, then reverse the byte order
    reversedBytes.bytes(0) = ReverseBitsByte(buf.bytes(3))
    reversedBytes.bytes(1) = ReverseBitsByte(buf.bytes(2))
    reversedBytes.bytes(2) = ReverseBitsByte(buf.bytes(1))
    reversedBytes.bytes(3) = ReverseBitsByte(buf.bytes(0))

    CopyMemory ReverseBitsSingle, reversedBytes.bytes(0), 4
End Function

' Reverses all bits in a Double value (bit order reversal)
' Args:
'   value (Double): The double value to reverse
' Returns:
'   Double: The double value with bit order reversed
Public Function ReverseBitsDouble(ByVal value As Double) As Double
    Dim buf As ByteBuffer8
    Dim reversedBytes As ByteBuffer8
    Dim i As Long

    ' Extract bytes using CopyMemory
    CopyMemory buf.bytes(0), value, 8

    ' Reverse each byte, then reverse the byte order
    For i = 0 To 7
        reversedBytes.bytes(i) = ReverseBitsByte(buf.bytes(7 - i))
    Next i

    CopyMemory ReverseBitsDouble, reversedBytes.bytes(0), 8
End Function

' Makes a Double from two Long values
Private Function MakeDouble(ByVal high As Long, ByVal low As Long) As Double
    Dim buf As ByteBuffer8

    buf.bytes(0) = low And &HFF
    buf.bytes(1) = NativeConverter.RightShiftLong(low, 8) And &HFF
    buf.bytes(2) = NativeConverter.RightShiftLong(low, 16) And &HFF
    buf.bytes(3) = NativeConverter.RightShiftLong(low, 24) And &HFF

    buf.bytes(4) = high And &HFF
    buf.bytes(5) = NativeConverter.RightShiftLong(high, 8) And &HFF
    buf.bytes(6) = NativeConverter.RightShiftLong(high, 16) And &HFF
    buf.bytes(7) = NativeConverter.RightShiftLong(high, 24) And &HFF

    CopyMemory MakeDouble, buf.bytes(0), 8
End Function

' ==================== PADDING ====================

' Pads a Byte value with zeros on the left to 16-bit Integer
' Args:
'   value (Byte): The byte value to pad
' Returns:
'   Integer: The byte value in the lower 8 bits with upper 8 bits zero
Public Function PadZeroLeftTo16Bits(ByVal value As Byte) As Integer
    Dim buf As ByteBuffer2
    buf.bytes(0) = value
    CopyMemory PadZeroLeftTo16Bits, buf.bytes(0), 2
End Function

' Pads a Byte value with zeros on the left to 32-bit Long
' Args:
'   value (Byte): The byte value to pad
' Returns:
'   Long: The byte value in the lower 8 bits with upper 24 bits zero
Public Function PadZeroLeftTo32Bits(ByVal value As Byte) As Long
    Dim buf As ByteBuffer4
    buf.bytes(0) = value
    CopyMemory PadZeroLeftTo32Bits, buf.bytes(0), 4
End Function

' Pads a Byte value with zeros on the left to 64-bit Double
' Args:
'   value (Byte): The byte value to pad
' Returns:
'   Double: The byte value in the lower 8 bits with upper 56 bits zero
Public Function PadZeroLeftTo64Bits(ByVal value As Byte) As Double
    ' Simply return the byte as Double (already zero-padded on left)
    PadZeroLeftTo64Bits = CDbl(value)
End Function

' Pads a Byte value with zeros on the right to 16-bit Integer
' Args:
'   value (Byte): The byte value to pad
' Returns:
'   Integer: The byte value in the upper 8 bits with lower 8 bits zero
Public Function PadZeroRightTo16Bits(ByVal value As Byte) As Integer
    Dim buf As ByteBuffer2
    buf.bytes(1) = value
    CopyMemory PadZeroRightTo16Bits, buf.bytes(0), 2
End Function

' Pads a Byte value with zeros on the right to 32-bit Long
' Args:
'   value (Byte): The byte value to pad
' Returns:
'   Double: The byte value in the upper 8 bits with lower 24 bits zero (as Double to handle unsigned 32-bit range)
Public Function PadZeroRightTo32Bits(ByVal value As Byte) As Long
    Dim buf As ByteBuffer4
    buf.bytes(3) = value
    CopyMemory PadZeroRightTo32Bits, buf.bytes(0), 4
End Function

' Pads a Byte value with zeros on the right to 64-bit Double
' Args:
'   value (Byte): The byte value to pad
' Returns:
'   Double: The byte value in the upper 8 bits with lower 56 bits zero
Public Function PadZeroRightTo64Bits(ByVal value As Byte) As Double
    ' Shift left by 56 bits (value * 2^56)
    PadZeroRightTo64Bits = CDbl(value) * 72057594037927936#
End Function

' Pads an Integer value with zeros on the left to 32-bit Long
' Args:
'   value (Integer): The integer value to pad
' Returns:
'   Long: The integer value zero-extended to 32 bits (as unsigned pattern)
Public Function PadZeroLeftTo32BitsInteger(ByVal value As Integer) As Long
    ' Zero-extend: treat as unsigned 16-bit, convert to 32-bit
    PadZeroLeftTo32BitsInteger = CLng(value And &HFFFF&)
End Function

' Pads an Integer value with zeros on the left to 64-bit Double
' Args:
'   value (Integer): The integer value to pad
' Returns:
'   Double: The integer value in the lower 16 bits with upper 48 bits zero
Public Function PadZeroLeftTo64BitsInteger(ByVal value As Integer) As Double
    ' Return the integer as Double (already zero-padded on left)
    PadZeroLeftTo64BitsInteger = CDbl(value)
End Function

' Pads an Integer value with zeros on the right to 32-bit Long
' Args:
'   value (Integer): The integer value to pad
' Returns:
'   Long: The integer value zero-extended then shifted to upper 16 bits
Public Function PadZeroRightTo32BitsInteger(ByVal value As Integer) As Long
    PadZeroRightTo32BitsInteger = CLng(value) * 65536
End Function

' Pads an Integer value with zeros on the right to 64-bit Double
' Args:
'   value (Integer): The integer value to pad
' Returns:
'   Double: The integer value in the upper 16 bits with lower 48 bits zero
Public Function PadZeroRightTo64BitsInteger(ByVal value As Integer) As Double
    ' Shift left by 48 bits (value * 2^48)
    PadZeroRightTo64BitsInteger = CDbl(value) * 281474976710656#
End Function

' Pads a Long value with zeros on the left to 64-bit Double
' Args:
'   value (Long): The long value to pad
' Returns:
'   Double: The long value in the lower 32 bits with upper 32 bits zero
Public Function PadZeroLeftTo64BitsLong(ByVal value As Long) As Double
    ' Return the long as Double (already zero-padded on left)
    PadZeroLeftTo64BitsLong = CDbl(value)
End Function

' Pads a Long value with zeros on the right to 64-bit Double
' Args:
'   value (Long): The long value to pad
' Returns:
'   Double: The long value in the upper 32 bits with lower 32 bits zero
Public Function PadZeroRightTo64BitsLong(ByVal value As Long) As Double
    ' Shift left by 32 bits (value * 2^32)
    PadZeroRightTo64BitsLong = CDbl(value) * 4294967296#
End Function

' Converts a Long value to Double by preserving bit pattern (for testing)
' Args:
'   value (Long): The long value to reinterpret
' Returns:
'   Double: The bits of the long interpreted as a Double
Public Function LongBitsAsDouble(ByVal value As Long) As Double
    Dim buf As ByteBuffer8
    CopyMemory buf.bytes(0), value, 4
    CopyMemory LongBitsAsDouble, buf.bytes(0), 8
End Function

' Converts two Long values (low and high 32 bits) to Double preserving bit pattern
' Args:
'   lowBits (Long): Lower 32 bits
'   highBits (Long): Upper 32 bits
' Returns:
'   Double: The 64-bit pattern interpreted as a Double
Public Function ULongBitsAsDouble(ByVal lowBits As Long, ByVal highBits As Long) As Double
    Dim buf As ByteBuffer8
    CopyMemory buf.bytes(0), lowBits, 4
    CopyMemory buf.bytes(4), highBits, 4
    CopyMemory ULongBitsAsDouble, buf.bytes(0), 8
End Function