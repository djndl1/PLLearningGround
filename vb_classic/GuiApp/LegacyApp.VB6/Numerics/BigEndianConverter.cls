VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BigEndianConverter"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' Windows API declaration for memory copying
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

' Fixed-size buffer structures for byte manipulation
Private Type ByteBuffer2
    bytes(0 To 1) As Byte
End Type

Private Type ByteBuffer4
    bytes(0 To 3) As Byte
End Type

Private Type ByteBuffer8
    bytes(0 To 7) As Byte
End Type

' BigEndianConverter provides functions for converting between native (little-endian)
' and big-endian byte order representations of various data types.
' This class uses the existing NativeConverter.ToBytes methods and performs byte swapping
' to achieve big-endian byte order.
'
' Since VB6 lacks unsigned integer types, this class focuses on signed Integer and Long types,
' as well as Single and Double floating-point types.

' ToBytesIntegerBE converts a 16-bit Integer value to a big-endian byte array.
' Args:
'   value (Integer): The 16-bit Integer value to convert to big-endian bytes.
' Returns:
'   Byte(): A 2-element byte array containing the big-endian representation.
Public Function ToBytesIntegerBE(ByVal value As Integer) As Byte()
Attribute ToBytesIntegerBE.VB_Description = "ToBytesIntegerBE converts a 16-bit Integer value to a big-endian byte array.\r\nArgs:\r\n  value (Integer): The 16-bit Integer value to convert to big-endian bytes.\r\nReturns:\r\n  Byte(): A 2-element byte array containing the big-endian representation."
    ' Get native (little-endian) bytes
    Dim nativeBytes() As Byte
    nativeBytes = NativeConverter.ToBytesInteger(value)

    ' Swap bytes for big-endian order
    Dim result(0 To 1) As Byte
    result(0) = nativeBytes(1)  ' High byte becomes first
    result(1) = nativeBytes(0)  ' Low byte becomes second

    ToBytesIntegerBE = result
End Function

' ToBytesLongBE converts a 32-bit Long value to a big-endian byte array.
' Args:
'   value (Long): The 32-bit Long value to convert to big-endian bytes.
' Returns:
'   Byte(): A 4-element byte array containing the big-endian representation.
Public Function ToBytesLongBE(ByVal value As Long) As Byte()
Attribute ToBytesLongBE.VB_Description = "ToBytesLongBE converts a 32-bit Long value to a big-endian byte array.\r\nArgs:\r\n  value (Long): The 32-bit Long value to convert to big-endian bytes.\r\nReturns:\r\n  Byte(): A 4-element byte array containing the big-endian representation."
    ' Get native (little-endian) bytes
    Dim nativeBytes() As Byte
    nativeBytes = NativeConverter.ToBytesLong(value)

    ' Swap bytes for big-endian order
    Dim result(0 To 3) As Byte
    result(0) = nativeBytes(3)  ' Byte 3 becomes first
    result(1) = nativeBytes(2)  ' Byte 2 becomes second
    result(2) = nativeBytes(1)  ' Byte 1 becomes third
    result(3) = nativeBytes(0)  ' Byte 0 becomes fourth

    ToBytesLongBE = result
End Function

' ToBytesSingleBE converts a 32-bit Single value to a big-endian byte array.
' Args:
'   value (Single): The 32-bit Single value to convert to big-endian bytes.
' Returns:
'   Byte(): A 4-element byte array containing the big-endian representation.
Public Function ToBytesSingleBE(ByVal value As Single) As Byte()
Attribute ToBytesSingleBE.VB_Description = "ToBytesSingleBE converts a 32-bit Single value to a big-endian byte array.\r\nArgs:\r\n  value (Single): The 32-bit Single value to convert to big-endian bytes.\r\nReturns:\r\n  Byte(): A 4-element byte array containing the big-endian representation."
    ' Get native (little-endian) bytes
    Dim nativeBytes() As Byte
    nativeBytes = NativeConverter.ToBytesSingle(value)

    ' Swap bytes for big-endian order
    Dim result(0 To 3) As Byte
    result(0) = nativeBytes(3)  ' Byte 3 becomes first
    result(1) = nativeBytes(2)  ' Byte 2 becomes second
    result(2) = nativeBytes(1)  ' Byte 1 becomes third
    result(3) = nativeBytes(0)  ' Byte 0 becomes fourth

    ToBytesSingleBE = result
End Function

' ToBytesDoubleBE converts a 64-bit Double value to a big-endian byte array.
' Args:
'   value (Double): The 64-bit Double value to convert to big-endian bytes.
' Returns:
'   Byte(): An 8-element byte array containing the big-endian representation.
Public Function ToBytesDoubleBE(ByVal value As Double) As Byte()
Attribute ToBytesDoubleBE.VB_Description = "ToBytesDoubleBE converts a 64-bit Double value to a big-endian byte array.\r\nArgs:\r\n  value (Double): The 64-bit Double value to convert to big-endian bytes.\r\nReturns:\r\n  Byte(): An 8-element byte array containing the big-endian representation."
    ' Get native (little-endian) bytes
    Dim nativeBytes() As Byte
    nativeBytes = NativeConverter.ToBytesDouble(value)

    ' Swap bytes for big-endian order
    Dim result(0 To 7) As Byte
    result(0) = nativeBytes(7)  ' Byte 7 becomes first
    result(1) = nativeBytes(6)  ' Byte 6 becomes second
    result(2) = nativeBytes(5)  ' Byte 5 becomes third
    result(3) = nativeBytes(4)  ' Byte 4 becomes fourth
    result(4) = nativeBytes(3)  ' Byte 3 becomes fifth
    result(5) = nativeBytes(2)  ' Byte 2 becomes sixth
    result(6) = nativeBytes(1)  ' Byte 1 becomes seventh
    result(7) = nativeBytes(0)  ' Byte 0 becomes eighth

    ToBytesDoubleBE = result
End Function

' ToIntegerBE converts a big-endian byte array to a 16-bit Integer value.
' Args:
'   bytes (Byte()): A 2-element byte array containing big-endian bytes.
' Returns:
'   Integer: The 16-bit Integer value represented by the big-endian bytes.
Public Function ToIntegerBE(ByRef bytes() As Byte) As Integer
Attribute ToIntegerBE.VB_Description = "ToIntegerBE converts a big-endian byte array to a 16-bit Integer value.\r\nArgs:\r\n  bytes (Byte()): A 2-element byte array containing big-endian bytes.\r\nReturns:\r\n  Integer: The 16-bit Integer value represented by the big-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 2, "bytes"

    Dim buffer As ByteBuffer2

    ' Copy bytes to buffer in reverse order (big-endian to little-endian)
    buffer.bytes(0) = bytes(1)  ' Second byte becomes low byte
    buffer.bytes(1) = bytes(0)  ' First byte becomes high byte

    ' Copy the buffer to the result
    CopyMemory ToIntegerBE, buffer.bytes(0), 2
End Function

' ToLongBE converts a big-endian byte array to a 32-bit Long value.
' Args:
'   bytes (Byte()): A 4-element byte array containing big-endian bytes.
' Returns:
'   Long: The 32-bit Long value represented by the big-endian bytes.
Public Function ToLongBE(ByRef bytes() As Byte) As Long
Attribute ToLongBE.VB_Description = "ToLongBE converts a big-endian byte array to a 32-bit Long value.\r\nArgs:\r\n  bytes (Byte()): A 4-element byte array containing big-endian bytes.\r\nReturns:\r\n  Long: The 32-bit Long value represented by the big-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 4, "bytes"

    Dim buffer As ByteBuffer4

    ' Copy bytes to buffer in reverse order (big-endian to little-endian)
    buffer.bytes(0) = bytes(3)  ' Fourth byte becomes first
    buffer.bytes(1) = bytes(2)  ' Third byte becomes second
    buffer.bytes(2) = bytes(1)  ' Second byte becomes third
    buffer.bytes(3) = bytes(0)  ' First byte becomes fourth

    ' Copy the buffer to the result
    CopyMemory ToLongBE, buffer.bytes(0), 4
End Function

' ToSingleBE converts a big-endian byte array to a 32-bit Single value.
' Args:
'   bytes (Byte()): A 4-element byte array containing big-endian bytes.
' Returns:
'   Single: The 32-bit Single value represented by the big-endian bytes.
Public Function ToSingleBE(ByRef bytes() As Byte) As Single
Attribute ToSingleBE.VB_Description = "ToSingleBE converts a big-endian byte array to a 32-bit Single value.\r\nArgs:\r\n  bytes (Byte()): A 4-element byte array containing big-endian bytes.\r\nReturns:\r\n  Single: The 32-bit Single value represented by the big-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 4, "bytes"

    Dim buffer As ByteBuffer4

    ' Copy bytes to buffer in reverse order (big-endian to little-endian)
    buffer.bytes(0) = bytes(3)  ' Fourth byte becomes first
    buffer.bytes(1) = bytes(2)  ' Third byte becomes second
    buffer.bytes(2) = bytes(1)  ' Second byte becomes third
    buffer.bytes(3) = bytes(0)  ' First byte becomes fourth

    ' Copy the buffer to the result
    CopyMemory ToSingleBE, buffer.bytes(0), 4
End Function

' ToDoubleBE converts a big-endian byte array to a 64-bit Double value.
' Args:
'   bytes (Byte()): An 8-element byte array containing big-endian bytes.
' Returns:
'   Double: The 64-bit Double value represented by the big-endian bytes.
Public Function ToDoubleBE(ByRef bytes() As Byte) As Double
Attribute ToDoubleBE.VB_Description = "ToDoubleBE converts a big-endian byte array to a 64-bit Double value.\r\nArgs:\r\n  bytes (Byte()): An 8-element byte array containing big-endian bytes.\r\nReturns:\r\n  Double: The 64-bit Double value represented by the big-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 8, "bytes"

    Dim buffer As ByteBuffer8

    ' Copy bytes to buffer in reverse order (big-endian to little-endian)
    buffer.bytes(0) = bytes(7)  ' Eighth byte becomes first
    buffer.bytes(1) = bytes(6)  ' Seventh byte becomes second
    buffer.bytes(2) = bytes(5)  ' Sixth byte becomes third
    buffer.bytes(3) = bytes(4)  ' Fifth byte becomes fourth
    buffer.bytes(4) = bytes(3)  ' Fourth byte becomes fifth
    buffer.bytes(5) = bytes(2)  ' Third byte becomes sixth
    buffer.bytes(6) = bytes(1)  ' Second byte becomes seventh
    buffer.bytes(7) = bytes(0)  ' First byte becomes eighth

    ' Copy the buffer to the result
    CopyMemory ToDoubleBE, buffer.bytes(0), 8
End Function