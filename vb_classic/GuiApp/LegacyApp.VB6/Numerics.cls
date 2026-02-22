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
    Dim result As VariantPair

    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.EuclideanDivisionInteger"

    ' Calculate quotient and remainder
    Dim quotient As Integer
    Dim remainder As Integer

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

    EuclideanDivisionInteger = result
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
    Dim result As VariantPair

    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.CeilingDivisionInteger"

    ' Calculate quotient and remainder using ceiling division
    Dim quotient As Integer
    Dim remainder As Integer

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

    CeilingDivisionInteger = result
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
    Dim result As VariantPair

    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.FloorDivisionInteger"

    ' Calculate quotient and remainder using floor division
    Dim quotient As Integer
    Dim remainder As Integer

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

    FloorDivisionInteger = result
End Function

' Performs mathematical modulo operation on two Long values
' This ensures the result is always non-negative (0 <= result < |divisor|)
' Args:
'   dividend (Long): The number to be divided
'   divisor (Long): The number to divide by (cannot be zero)
' Returns:
'   Long: The non-negative remainder of the division
Public Function MathematicalModuloLong(ByVal dividend As Long, ByVal divisor As Long) As Long
Attribute MathematicalModuloLong.VB_Description = "Performs mathematical modulo operation on two Long values\r\nThis ensures the result is always non-negative (0 <= result < |divisor|)\r\nArgs:\r\n  dividend (Long): The number to be divided\r\n  divisor (Long): The number to divide by (cannot be zero)\r\nReturns:\r\n  Long: The non-negative remainder of the division"
    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.MathematicalModuloLong"
    
    ' Mathematical modulo: more efficient implementation matching C# version
    Dim remainder As Long
    remainder = dividend Mod divisor
    
    If remainder >= 0 Then
        MathematicalModuloLong = remainder
    Else
        MathematicalModuloLong = remainder + Abs(divisor)
    End If
End Function

' Performs mathematical modulo operation on two Integer values
' This ensures the result is always non-negative (0 <= result < |divisor|)
' Args:
'   dividend (Integer): The number to be divided
'   divisor (Integer): The number to divide by (cannot be zero)
' Returns:
'   Integer: The non-negative remainder of the division
Public Function MathematicalModuloInteger(ByVal dividend As Integer, ByVal divisor As Integer) As Integer
Attribute MathematicalModuloInteger.VB_Description = "Performs mathematical modulo operation on two Integer values\r\nThis ensures the result is always non-negative (0 <= result < |divisor|)\r\nArgs:\r\n  dividend (Integer): The number to be divided\r\n  divisor (Integer): The number to divide by (cannot be zero)\r\nReturns:\r\n  Integer: The non-negative remainder of the division"
    ' Handle division by zero
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.MathematicalModuloInteger"
    
    ' Mathematical modulo: more efficient implementation matching C# version
    Dim remainder As Integer
    remainder = dividend Mod divisor
    
    If remainder >= 0 Then
        MathematicalModuloInteger = remainder
    Else
        MathematicalModuloInteger = remainder + Abs(divisor)
    End If
End Function