VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "LittleEndianConverter"
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

' LittleEndianConverter provides functions for converting between native (little-endian)
' and little-endian byte order representations of various data types.
' Since Windows uses little-endian byte order by default, these functions are essentially
' wrappers around the NativeConverter methods, providing a consistent API with BigEndianConverter.
'
' Since VB6 lacks unsigned integer types, this class focuses on signed Integer and Long types,
' as well as Single and Double floating-point types.

' ToBytesIntegerLE converts a 16-bit Integer value to a little-endian byte array.
' Args:
'   value (Integer): The 16-bit Integer value to convert to little-endian bytes.
' Returns:
'   Byte(): A 2-element byte array containing the little-endian representation.
Public Function ToBytesIntegerLE(ByVal value As Integer) As Byte()
Attribute ToBytesIntegerLE.VB_Description = "ToBytesIntegerLE converts a 16-bit Integer value to a little-endian byte array.\r\nArgs:\r\n  value (Integer): The 16-bit Integer value to convert to little-endian bytes.\r\nReturns:\r\n  Byte(): A 2-element byte array containing the little-endian representation."
    ' On little-endian systems, native bytes are already in little-endian order
    ToBytesIntegerLE = NativeConverter.ToBytesInteger(value)
End Function

' ToBytesLongLE converts a 32-bit Long value to a little-endian byte array.
' Args:
'   value (Long): The 32-bit Long value to convert to little-endian bytes.
' Returns:
'   Byte(): A 4-element byte array containing the little-endian representation.
Public Function ToBytesLongLE(ByVal value As Long) As Byte()
Attribute ToBytesLongLE.VB_Description = "ToBytesLongLE converts a 32-bit Long value to a little-endian byte array.\r\nArgs:\r\n  value (Long): The 32-bit Long value to convert to little-endian bytes.\r\nReturns:\r\n  Byte(): A 4-element byte array containing the little-endian representation."
    ' On little-endian systems, native bytes are already in little-endian order
    ToBytesLongLE = NativeConverter.ToBytesLong(value)
End Function

' ToBytesSingleLE converts a 32-bit Single value to a little-endian byte array.
' Args:
'   value (Single): The 32-bit Single value to convert to little-endian bytes.
' Returns:
'   Byte(): A 4-element byte array containing the little-endian representation.
Public Function ToBytesSingleLE(ByVal value As Single) As Byte()
Attribute ToBytesSingleLE.VB_Description = "ToBytesSingleLE converts a 32-bit Single value to a little-endian byte array.\r\nArgs:\r\n  value (Single): The 32-bit Single value to convert to little-endian bytes.\r\nReturns:\r\n  Byte(): A 4-element byte array containing the little-endian representation."
    ' On little-endian systems, native bytes are already in little-endian order
    ToBytesSingleLE = NativeConverter.ToBytesSingle(value)
End Function

' ToBytesDoubleLE converts a 64-bit Double value to a little-endian byte array.
' Args:
'   value (Double): The 64-bit Double value to convert to little-endian bytes.
' Returns:
'   Byte(): An 8-element byte array containing the little-endian representation.
Public Function ToBytesDoubleLE(ByVal value As Double) As Byte()
Attribute ToBytesDoubleLE.VB_Description = "ToBytesDoubleLE converts a 64-bit Double value to a little-endian byte array.\r\nArgs:\r\n  value (Double): The 64-bit Double value to convert to little-endian bytes.\r\nReturns:\r\n  Byte(): An 8-element byte array containing the little-endian representation."
    ' On little-endian systems, native bytes are already in little-endian order
    ToBytesDoubleLE = NativeConverter.ToBytesDouble(value)
End Function

' ToIntegerLE converts a little-endian byte array to a 16-bit Integer value.
' Args:
'   bytes (Byte()): A 2-element byte array containing little-endian bytes.
' Returns:
'   Integer: The 16-bit Integer value represented by the little-endian bytes.
Public Function ToIntegerLE(ByRef bytes() As Byte) As Integer
Attribute ToIntegerLE.VB_Description = "ToIntegerLE converts a little-endian byte array to a 16-bit Integer value.\r\nArgs:\r\n  bytes (Byte()): A 2-element byte array containing little-endian bytes.\r\nReturns:\r\n  Integer: The 16-bit Integer value represented by the little-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 2, "bytes"

    ' Copy bytes directly to the result (little-endian order is native)
    CopyMemory ToIntegerLE, bytes(0), 2
End Function

' ToLongLE converts a little-endian byte array to a 32-bit Long value.
' Args:
'   bytes (Byte()): A 4-element byte array containing little-endian bytes.
' Returns:
'   Long: The 32-bit Long value represented by the little-endian bytes.
Public Function ToLongLE(ByRef bytes() As Byte) As Long
Attribute ToLongLE.VB_Description = "ToLongLE converts a little-endian byte array to a 32-bit Long value.\r\nArgs:\r\n  bytes (Byte()): A 4-element byte array containing little-endian bytes.\r\nReturns:\r\n  Long: The 32-bit Long value represented by the little-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 4, "bytes"

    ' Copy bytes directly to the result (little-endian order is native)
    CopyMemory ToLongLE, bytes(0), 4
End Function

' ToSingleLE converts a little-endian byte array to a 32-bit Single value.
' Args:
'   bytes (Byte()): A 4-element byte array containing little-endian bytes.
' Returns:
'   Single: The 32-bit Single value represented by the little-endian bytes.
Public Function ToSingleLE(ByRef bytes() As Byte) As Single
Attribute ToSingleLE.VB_Description = "ToSingleLE converts a little-endian byte array to a 32-bit Single value.\r\nArgs:\r\n  bytes (Byte()): A 4-element byte array containing little-endian bytes.\r\nReturns:\r\n  Single: The 32-bit Single value represented by the little-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 4, "bytes"

    ' Copy bytes directly to the result (little-endian order is native)
    CopyMemory ToSingleLE, bytes(0), 4
End Function

' ToDoubleLE converts a little-endian byte array to a 64-bit Double value.
' Args:
'   bytes (Byte()): An 8-element byte array containing little-endian bytes.
' Returns:
'   Double: The 64-bit Double value represented by the little-endian bytes.
Public Function ToDoubleLE(ByRef bytes() As Byte) As Double
Attribute ToDoubleLE.VB_Description = "ToDoubleLE converts a little-endian byte array to a 64-bit Double value.\r\nArgs:\r\n  bytes (Byte()): An 8-element byte array containing little-endian bytes.\r\nReturns:\r\n  Double: The 64-bit Double value represented by the little-endian bytes."
    ' Validate array size
    Ensure.GreaterThanOrEqual Arrays.GetArrayLength(bytes), 8, "bytes"

    ' Copy bytes directly to the result (little-endian order is native)
    CopyMemory ToDoubleLE, bytes(0), 8
End Function