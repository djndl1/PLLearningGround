VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Numerics"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' Performs Euclidean division on two Long values
' Args:
'   dividend (Long): The number to be divided
'   divisor (Long): The number to divide by (cannot be zero)
' Returns:
'   VariantPair: A structure where First contains the quotient and Second contains the nonnegative remainder
Public Function EuclideanDivisionLong(ByVal dividend As Long, ByVal divisor As Long) As VariantPair
Attribute EuclideanDivisionLong.VB_Description = "Performs Euclidean division on two Long values\r\nArgs:\r\n  dividend (Long): The number to be divided\r\n  divisor (Long): The number to divide by (cannot be zero)\r\nReturns:\r\n  VariantPair: A structure where First contains the quotient and Second contains the nonnegative remainder"
    Dim result As VariantPair

    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.EuclideanDivisionLong"

    ' Calculate quotient and remainder
    Dim quotient As Long
    Dim remainder As Long

    quotient = dividend \ divisor
    remainder = dividend Mod divisor

    ' Ensure remainder is nonnegative (Euclidean division property)
    If remainder < 0 Then
        ' Adjust for negative remainder
        If divisor > 0 Then
            remainder = remainder + divisor
            quotient = quotient - 1
        Else
            remainder = remainder - divisor
            quotient = quotient + 1
        End If
    End If

    result.first = quotient
    result.second = remainder

    EuclideanDivisionLong = result
End Function

' Performs Euclidean division on two Integer values
' Args:
'   dividend (Integer): The number to be divided
'   divisor (Integer): The number to divide by (cannot be zero)
' Returns:
'   VariantPair: A structure where First contains the quotient and Second contains the nonnegative remainder
Public Function EuclideanDivisionInteger(ByVal dividend As Integer, ByVal divisor As Integer) As VariantPair
Attribute EuclideanDivisionInteger.VB_Description = "Performs Euclidean division on two Integer values\r\nArgs:\r\n  dividend (Integer): The number to be divided\r\n  divisor (Integer): The number to divide by (cannot be zero)\r\nReturns:\r\n  VariantPair: A structure where First contains the quotient and Second contains the nonnegative remainder"
    ' Wrap the Long version by converting Integer parameters to Long
    EuclideanDivisionInteger = EuclideanDivisionLong(CLng(dividend), CLng(divisor))
End Function

' Performs ceiling division on two Long values
' Args:
'   dividend (Long): The number to be divided
'   divisor (Long): The number to divide by (cannot be zero)
' Returns:
'   VariantPair: A structure where First contains the quotient and Second contains the remainder with opposite sign of divisor
Public Function CeilingDivisionLong(ByVal dividend As Long, ByVal divisor As Long) As VariantPair
Attribute CeilingDivisionLong.VB_Description = "Performs ceiling division on two Long values\r\nArgs:\r\n  dividend (Long): The number to be divided\r\n  divisor (Long): The number to divide by (cannot be zero)\r\nReturns:\r\n  VariantPair: A structure where First contains the quotient and Second contains the remainder with opposite sign of divisor"
    Dim result As VariantPair

    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.CeilingDivisionLong"

    ' Calculate quotient and remainder using ceiling division
    Dim quotient As Long
    Dim remainder As Long

    ' Ceiling division: quotient = ceiling(dividend / divisor)
    ' This means we round towards positive infinity
    quotient = dividend \ divisor
    remainder = dividend Mod divisor

    '  7 / 3 = 2, 1
    '  7 / -3 = -2, 1
    ' -7 / 3 = -2, -1
    ' -7 / -3 = 2, -1
    ' Ensure remainder has opposite sign of divisor (ceiling division property)
    If (divisor > 0 And remainder > 0) Or (divisor < 0 And remainder < 0) Then
        remainder = remainder - divisor
        quotient = quotient + 1
    End If

    result.first = quotient
    result.second = remainder

    CeilingDivisionLong = result
End Function

' Performs ceiling division on two Integer values
' Args:
'   dividend (Integer): The number to be divided
'   divisor (Integer): The number to divide by (cannot be zero)
' Returns:
'   VariantPair: A structure where First contains the quotient and Second contains the remainder with opposite sign of divisor
Public Function CeilingDivisionInteger(ByVal dividend As Integer, ByVal divisor As Integer) As VariantPair
Attribute CeilingDivisionInteger.VB_Description = "Performs ceiling division on two Integer values\r\nArgs:\r\n  dividend (Integer): The number to be divided\r\n  divisor (Integer): The number to divide by (cannot be zero)\r\nReturns:\r\n  VariantPair: A structure where First contains the quotient and Second contains the remainder with opposite sign of divisor"
    ' Wrap the Long version by converting Integer parameters to Long
    CeilingDivisionInteger = CeilingDivisionLong(CLng(dividend), CLng(divisor))
End Function

' Performs floor division on two Long values
' Args:
'   dividend (Long): The number to be divided
'   divisor (Long): The number to divide by (cannot be zero)
' Returns:
'   VariantPair: A structure where First contains the quotient and Second contains the remainder with same sign as divisor
Public Function FloorDivisionLong(ByVal dividend As Long, ByVal divisor As Long) As VariantPair
Attribute FloorDivisionLong.VB_Description = "Performs floor division on two Long values\r\nArgs:\r\n  dividend (Long): The number to be divided\r\n  divisor (Long): The number to divide by (cannot be zero)\r\nReturns:\r\n  VariantPair: A structure where First contains the quotient and Second contains the remainder with same sign as divisor"
    Dim result As VariantPair

    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.FloorDivisionLong"

    ' Calculate quotient and remainder using floor division
    Dim quotient As Long
    Dim remainder As Long

    ' Floor division: quotient = floor(dividend / divisor)
    ' This means we round towards negative infinity
    quotient = dividend \ divisor
    remainder = dividend Mod divisor

    '  7 / 3 = 2, 1
    '  7 / -3 = -2, 1
    ' -7 / 3 = -2, -1
    ' -7 / -3 = 2, -1
    ' Ensure remainder has same sign as divisor (floor division property)
    If (divisor > 0 And remainder < 0) Or (divisor < 0 And remainder > 0) Then
        remainder = remainder + divisor
        quotient = quotient - 1
    End If

    result.first = quotient
    result.second = remainder

    FloorDivisionLong = result
End Function

' Performs floor division on two Integer values
' Args:
'   dividend (Integer): The number to be divided
'   divisor (Integer): The number to divide by (cannot be zero)
' Returns:
'   VariantPair: A structure where First contains the quotient and Second contains the remainder with same sign as divisor
Public Function FloorDivisionInteger(ByVal dividend As Integer, ByVal divisor As Integer) As VariantPair
Attribute FloorDivisionInteger.VB_Description = "Performs floor division on two Integer values\r\nArgs:\r\n  dividend (Integer): The number to be divided\r\n  divisor (Integer): The number to divide by (cannot be zero)\r\nReturns:\r\n  VariantPair: A structure where First contains the quotient and Second contains the remainder with same sign as divisor"
    ' Wrap the Long version by converting Integer parameters to Long
    FloorDivisionInteger = FloorDivisionLong(CLng(dividend), CLng(divisor))
End Function