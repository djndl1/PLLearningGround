VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NativeConverter"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' Windows API declaration for memory copying
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

' Fixed-size buffer structure for byte manipulation
Private Type ByteBuffer8
    bytes(0 To 7) As Byte
End Type

' Fixed-size buffer structure for 4-byte types
Private Type ByteBuffer4
    bytes(0 To 3) As Byte
End Type

' Fixed-size buffer structure for 2-byte types
Private Type ByteBuffer2
    bytes(0 To 1) As Byte
End Type

' NativeConverter provides bitwise operations and byte order manipulation utilities.
' This class implements functions for shifting bits and reversing byte order of integral types.
' Since VB6 lacks native bit shift operators, these functions use multiplication and division
' by powers of 2 to emulate bit shifting behavior.
'
' The class includes both 16-bit (Integer) and 32-bit (Long) versions of each operation
' to ensure type safety and optimal performance for different data sizes.

' LeftShiftInteger performs a left bit shift operation on a 16-bit Integer value.
' Args:
'   value (Integer): The value to be shifted left.
'   shift (Integer): The number of bits to shift (0-15).
' Returns:
'   Integer: The value shifted left by the specified number of bits.
Public Function LeftShiftInteger(ByVal value As Integer, ByVal shift As Integer) As Integer
Attribute LeftShiftInteger.VB_Description = "LeftShiftInteger performs a left bit shift operation on a 16-bit Integer value.\r\nArgs:\r\n  value (Integer): The value to be shifted left.\r\n  shift (Integer): The number of bits to shift (0-15).\r\nReturns:\r\n  Integer: The value shifted left by the specified number of bits."
    LeftShiftInteger = value * (2 ^ shift)
End Function

' RightShiftInteger performs a right bit shift operation on a 16-bit Integer value.
' Args:
'   value (Integer): The value to be shifted right.
'   shift (Integer): The number of bits to shift (0-15).
' Returns:
'   Integer: The value shifted right by the specified number of bits.
Public Function RightShiftInteger(ByVal value As Integer, ByVal shift As Integer) As Integer
Attribute RightShiftInteger.VB_Description = "RightShiftInteger performs a right bit shift operation on a 16-bit Integer value.\r\nArgs:\r\n  value (Integer): The value to be shifted right.\r\n  shift (Integer): The number of bits to shift (0-15).\r\nReturns:\r\n  Integer: The value shifted right by the specified number of bits."
    RightShiftInteger = value \ (2 ^ shift)
End Function

' LeftShiftLong performs a left bit shift operation on a 32-bit Long value.
' Args:
'   value (Long): The value to be shifted left.
'   shift (Integer): The number of bits to shift (0-31).
' Returns:
'   Long: The value shifted left by the specified number of bits.
Public Function LeftShiftLong(ByVal value As Long, ByVal shift As Integer) As Long
Attribute LeftShiftLong.VB_Description = "LeftShiftLong performs a left bit shift operation on a 32-bit Long value.\r\nArgs:\r\n  value (Long): The value to be shifted left.\r\n  shift (Integer): The number of bits to shift (0-31).\r\nReturns:\r\n  Long: The value shifted left by the specified number of bits."
    LeftShiftLong = value * (2 ^ shift)
End Function

' RightShiftLong performs a right bit shift operation on a 32-bit Long value.
' Args:
'   value (Long): The value to be shifted right.
'   shift (Integer): The number of bits to shift (0-31).
' Returns:
'   Long: The value shifted right by the specified number of bits.
Public Function RightShiftLong(ByVal value As Long, ByVal shift As Integer) As Long
Attribute RightShiftLong.VB_Description = "RightShiftLong performs a right bit shift operation on a 32-bit Long value.\r\nArgs:\r\n  value (Long): The value to be shifted right.\r\n  shift (Integer): The number of bits to shift (0-31).\r\nReturns:\r\n  Long: The value shifted right by the specified number of bits."
    RightShiftLong = value \ (2 ^ shift)
End Function

' ReverseByteOrderInteger reverses the byte order of a 16-bit Integer value.
' This function swaps the high and low bytes of the input value.
' Args:
'   value (Integer): The 16-bit Integer value whose byte order is to be reversed.
' Returns:
'   Integer: The value with bytes reversed (big-endian to little-endian or vice versa).
Public Function ReverseByteOrderInteger(ByVal value As Integer) As Integer
Attribute ReverseByteOrderInteger.VB_Description = "ReverseByteOrderInteger reverses the byte order of a 16-bit Integer value.\r\nThis function swaps the high and low bytes of the input value.\r\nArgs:\r\n  value (Integer): The 16-bit Integer value whose byte order is to be reversed.\r\nReturns:\r\n  Integer: The value with bytes reversed (big-endian to little-endian or vice versa)."
    ' For 16-bit Integer: swap the two bytes using bitwise operations
    Dim lowByte As Integer
    Dim highByte As Integer

    ' Extract low byte (bits 0-7) and high byte (bits 8-15)
    lowByte = value And &HFF
    highByte = RightShiftInteger(value And &HFF00, 8)

    ' Combine with bytes swapped
    ReverseByteOrderInteger = LeftShiftInteger(lowByte, 8) Or highByte
End Function

' ReverseByteOrderLong reverses the byte order of a 32-bit Long value.
' This function reverses the order of all 4 bytes in the input value.
' Args:
'   value (Long): The 32-bit Long value whose byte order is to be reversed.
' Returns:
'   Long: The value with bytes reversed (big-endian to little-endian or vice versa).
Public Function ReverseByteOrderLong(ByVal value As Long) As Long
Attribute ReverseByteOrderLong.VB_Description = "ReverseByteOrderLong reverses the byte order of a 32-bit Long value.\r\nThis function reverses the order of all 4 bytes in the input value.\r\nArgs:\r\n  value (Long): The 32-bit Long value whose byte order is to be reversed.\r\nReturns:\r\n  Long: The value with bytes reversed (big-endian to little-endian or vice versa)."
    ' For 32-bit Long: reverse all 4 bytes using bitwise operations
    Dim byte0 As Long  ' bits 0-7
    Dim byte1 As Long  ' bits 8-15
    Dim byte2 As Long  ' bits 16-23
    Dim byte3 As Long  ' bits 24-31

    ' Extract each byte
    byte0 = value And &HFF&
    byte1 = RightShiftLong(value And &HFF00&, 8)
    byte2 = RightShiftLong(value And &HFF0000, 16)
    byte3 = RightShiftLong(value And &HFF000000, 24)

    ' Combine with bytes in reverse order using left shifts
    ReverseByteOrderLong = LeftShiftLong(byte0, 24) Or LeftShiftLong(byte1, 16) Or LeftShiftLong(byte2, 8) Or byte3
End Function

' ReverseByteOrderSingle reverses the byte order of a 32-bit Single floating-point value.
' This function reverses the order of all 4 bytes in the IEEE 754 single-precision value.
' Args:
'   value (Single): The 32-bit Single value whose byte order is to be reversed.
' Returns:
'   Single: The value with bytes reversed (big-endian to little-endian or vice versa).
Public Function ReverseByteOrderSingle(ByVal value As Single) As Single
Attribute ReverseByteOrderSingle.VB_Description = "ReverseByteOrderSingle reverses the byte order of a 32-bit Single floating-point value.\r\nThis function reverses the order of all 4 bytes in the IEEE 754 single-precision value.\r\nArgs:\r\n  value (Single): The 32-bit Single value whose byte order is to be reversed.\r\nReturns:\r\n  Single: The value with bytes reversed (big-endian to little-endian or vice versa)."
    ' Use CopyMemory API to manipulate the bytes of the Single value
    Dim longValue As Long
    Dim reversedLong As Long

    ' Copy the Single value's memory representation to a Long
    CopyMemory longValue, value, 4

    ' Reverse the byte order using the existing Long function
    reversedLong = ReverseByteOrderLong(longValue)

    ' Copy the reversed bytes back to a Single
    CopyMemory ReverseByteOrderSingle, reversedLong, 4
End Function

' ReverseByteOrderDouble reverses the byte order of a 64-bit Double floating-point value.
' This function reverses the order of all 8 bytes in the IEEE 754 double-precision value.
' Args:
'   value (Double): The 64-bit Double value whose byte order is to be reversed.
' Returns:
'   Double: The value with bytes reversed (big-endian to little-endian or vice versa).
Public Function ReverseByteOrderDouble(ByVal value As Double) As Double
Attribute ReverseByteOrderDouble.VB_Description = "ReverseByteOrderDouble reverses the byte order of a 64-bit Double floating-point value.\r\nThis function reverses the order of all 8 bytes in the IEEE 754 double-precision value.\r\nArgs:\r\n  value (Double): The 64-bit Double value whose byte order is to be reversed.\r\nReturns:\r\n  Double: The value with bytes reversed (big-endian to little-endian or vice versa)."
    ' Use CopyMemory API to manipulate the bytes of the Double value
    Dim buffer As ByteBuffer8
    Dim temp As Byte
    Dim i As Integer

    ' Copy the Double value's memory representation to the fixed buffer
    CopyMemory buffer.bytes(0), value, 8

    ' Reverse the byte order in-place by swapping bytes from both ends
    For i = 0 To 3
        temp = buffer.bytes(i)
        buffer.bytes(i) = buffer.bytes(7 - i)
        buffer.bytes(7 - i) = temp
    Next i

    ' Copy the reversed bytes back to a Double
    CopyMemory ReverseByteOrderDouble, buffer.bytes(0), 8
End Function

' ToBytesInteger converts a 16-bit Integer value to a byte array representing its memory layout.
' Args:
'   value (Integer): The 16-bit Integer value to convert to bytes.
' Returns:
'   Byte(): A 2-element byte array containing the bytes of the Integer value.
Public Function ToBytesInteger(ByVal value As Integer) As Byte()
Attribute ToBytesInteger.VB_Description = "ToBytesInteger converts a 16-bit Integer value to a byte array representing its memory layout.\r\nArgs:\r\n  value (Integer): The 16-bit Integer value to convert to bytes.\r\nReturns:\r\n  Byte(): A 2-element byte array containing the bytes of the Integer value."
    Dim result(0 To 1) As Byte

    ' Copy the Integer value's memory representation directly to the result array
    CopyMemory result(0), value, 2

    ToBytesInteger = result
End Function

' ToBytesLong converts a 32-bit Long value to a byte array representing its memory layout.
' Args:
'   value (Long): The 32-bit Long value to convert to bytes.
' Returns:
'   Byte(): A 4-element byte array containing the bytes of the Long value.
Public Function ToBytesLong(ByVal value As Long) As Byte()
Attribute ToBytesLong.VB_Description = "ToBytesLong converts a 32-bit Long value to a byte array representing its memory layout.\r\nArgs:\r\n  value (Long): The 32-bit Long value to convert to bytes.\r\nReturns:\r\n  Byte(): A 4-element byte array containing the bytes of the Long value."
    Dim result(0 To 3) As Byte

    ' Copy the Long value's memory representation directly to the result array
    CopyMemory result(0), value, 4

    ToBytesLong = result
End Function

' ToBytesSingle converts a 32-bit Single value to a byte array representing its memory layout.
' Args:
'   value (Single): The 32-bit Single value to convert to bytes.
' Returns:
'   Byte(): A 4-element byte array containing the bytes of the Single value.
Public Function ToBytesSingle(ByVal value As Single) As Byte()
Attribute ToBytesSingle.VB_Description = "ToBytesSingle converts a 32-bit Single value to a byte array representing its memory layout.\r\nArgs:\r\n  value (Single): The 32-bit Single value to convert to bytes.\r\nReturns:\r\n  Byte(): A 4-element byte array containing the bytes of the Single value."
    Dim result(0 To 3) As Byte

    ' Copy the Single value's memory representation directly to the result array
    CopyMemory result(0), value, 4

    ToBytesSingle = result
End Function

' ToBytesDouble converts a 64-bit Double value to a byte array representing its memory layout.
' Args:
'   value (Double): The 64-bit Double value to convert to bytes.
' Returns:
'   Byte(): An 8-element byte array containing the bytes of the Double value.
Public Function ToBytesDouble(ByVal value As Double) As Byte()
Attribute ToBytesDouble.VB_Description = "ToBytesDouble converts a 64-bit Double value to a byte array representing its memory layout.\r\nArgs:\r\n  value (Double): The 64-bit Double value to convert to bytes.\r\nReturns:\r\n  Byte(): An 8-element byte array containing the bytes of the Double value."
    Dim result(0 To 7) As Byte

    ' Copy the Double value's memory representation directly to the result array
    CopyMemory result(0), value, 8

    ToBytesDouble = result
End Function