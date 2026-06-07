Attribute VB_Name = "LargeInteger"
Option Explicit

' LargeInteger maps between the Win32 LARGE_INTEGER 8-byte wire format
' (LowPart DWORD, HighPart LONG) and Variant(Decimal) for exact 64-bit
' integer arithmetic. The unsigned-LowPart trick (LowPart is DWORD but
' VB6 Long is signed 32-bit) lives in private helpers.

Public Type LARGE_INTEGER
    LowPart As Long
    HighPart As Long
End Type

' LargeIntegerToDecimal returns the 64-bit value of li as a Decimal.
' Use after a Win32 API call that writes 8 bytes into a LARGE_INTEGER.
Public Function LargeIntegerToDecimal(ByRef li As LARGE_INTEGER) As Variant
    LargeIntegerToDecimal = CDec(li.HighPart) * CDec("4294967296") _
                          + UnsignedLowPart(li.LowPart)
End Function

' DecimalToLargeInteger returns the LARGE_INTEGER representation of value.
' Use before passing a LARGE_INTEGER ByRef to a Win32 API.
Public Function DecimalToLargeInteger(ByVal value As Variant) As LARGE_INTEGER
    Dim result As LARGE_INTEGER
    Dim hiSigned As Variant
    hiSigned = Int(CDec(value) / CDec("4294967296"))
    result.HighPart = CLng(hiSigned)
    result.LowPart = SignedLowPartFromUnsignedDecimal(CDec(value) - CDec(hiSigned) * CDec("4294967296"))
    DecimalToLargeInteger = result
End Function

' UnsignedLowPart reinterprets a signed VB6 Long as an unsigned 32-bit
' value in Decimal form. Half the unsigned range (0x80000000..0xFFFFFFFF)
' reads back as negative Longs; this helper adds 2^32 to recover the
' true unsigned value.
Private Function UnsignedLowPart(ByVal signedLong As Long) As Variant
    If signedLong < 0 Then
        UnsignedLowPart = CDec(signedLong) + CDec("4294967296")
    Else
        UnsignedLowPart = CDec(signedLong)
    End If
End Function

' SignedLowPartFromUnsignedDecimal takes a Decimal in the unsigned
' 32-bit range (0..2^32-1) and returns a signed Long in the canonical
' (-2^31..2^31-1) range. Values >= 2^31 are offset by -2^32.
Private Function SignedLowPartFromUnsignedDecimal(ByVal value As Variant) As Long
    Dim v As Variant
    v = CDec(value)
    If v >= CDec("2147483648") Then
        SignedLowPartFromUnsignedDecimal = CLng(v - CDec("4294967296"))
    Else
        SignedLowPartFromUnsignedDecimal = CLng(v)
    End If
End Function
