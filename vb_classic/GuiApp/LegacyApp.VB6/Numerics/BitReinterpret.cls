VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BitReinterpret"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' Windows API declaration for memory copying
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

' BitReinterpret provides functions for reinterpreting the bit patterns of floating-point
' values as integral types and vice versa. This is useful for low-level bit manipulation
' and type punning operations without changing the underlying bit representation.
'
' Since VB6 lacks 64-bit and unsigned integer types, this class focuses on conversions
' between Single floating-point values and 32-bit Long integers.

' Fixed-size buffer structure for byte manipulation
Private Type ByteBuffer4
    bytes(0 To 3) As Byte
End Type

' AsLong reinterprets the bit pattern of a Single floating-point value as a 32-bit Long.
' This function performs a bitwise reinterpretation without changing the underlying data.
' Args:
'   f (Single): The Single value to reinterpret as a Long.
' Returns:
'   Long: The bit pattern of the Single value interpreted as a 32-bit integer.
Public Function AsLong(ByVal f As Single) As Long
Attribute AsLong.VB_Description = "AsLong reinterprets the bit pattern of a Single floating-point value as a 32-bit Long.\r\nThis function performs a bitwise reinterpretation without changing the underlying data.\r\nArgs:\r\n  f (Single): The Single value to reinterpret as a Long.\r\nReturns:\r\n  Long: The bit pattern of the Single value interpreted as a 32-bit integer."
    CopyMemory AsLong, f, 4
End Function

' AsSingle reinterprets the bit pattern of a 32-bit Long as a Single floating-point value.
' This function performs a bitwise reinterpretation without changing the underlying data.
' Args:
'   l (Long): The 32-bit Long value to reinterpret as a Single.
' Returns:
'   Single: The bit pattern of the Long value interpreted as a Single.
Public Function AsSingle(ByVal l As Long) As Single
Attribute AsSingle.VB_Description = "AsSingle reinterprets the bit pattern of a 32-bit Long as a Single floating-point value.\r\nThis function performs a bitwise reinterpretation without changing the underlying data.\r\nArgs:\r\n  l (Long): The 32-bit Long value to reinterpret as a Single.\r\nReturns:\r\n  Single: The bit pattern of the Long value interpreted as a Single."
    CopyMemory AsSingle, l, 4
End Function