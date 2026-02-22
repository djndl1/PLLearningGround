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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.EuclideanDivisionLong", "divisor cannot be zero"

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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.EuclideanDivisionInteger", "divisor cannot be zero"

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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.CeilingDivisionLong", "divisor cannot be zero"

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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.CeilingDivisionInteger", "divisor cannot be zero"

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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.FloorDivisionLong", "divisor cannot be zero"

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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.FloorDivisionInteger", "divisor cannot be zero"

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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.MathematicalModuloLong", "divisor cannot be zero"

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
    Ensure.NotEqual divisor, 0, ErrorCodes.DivisionByZero, "Numerics.MathematicalModuloInteger", "divisor cannot be zero"

    ' Mathematical modulo: more efficient implementation matching C# version
    Dim remainder As Integer
    remainder = dividend Mod divisor

    If remainder >= 0 Then
        MathematicalModuloInteger = remainder
    Else
        MathematicalModuloInteger = remainder + Abs(divisor)
    End If
End Function

' Enforces that min <= max for clamping operations
Private Sub EnforceMinMaxRelation(ByVal min As Variant, ByVal max As Variant)
Attribute EnforceMinMaxRelation.VB_Description = "Enforces that min <= max for clamping operations"
    If min > max Then
        Err.Raise ErrorCodes.InvalidProcedureCall, "Numerics.EnforceMinMaxRelation", "min (" & CStr(min) & ") cannot be greater than max (" & CStr(max) & ")"
    End If
End Sub

' Clamp function: restricts a value to specified upper and lower bounds
' Args:
'   value (Byte): The value to be clamped
'   min (Byte): The lower bound
'   max (Byte): The upper bound
' Returns:
'   Byte: The clamped value
Public Function ClampByte(ByVal value As Byte, ByVal min As Byte, ByVal max As Byte) As Byte
Attribute ClampByte.VB_Description = "Clamp function: restricts a value to specified upper and lower bounds\r\nArgs:\r\n  value (Byte): The value to be clamped\r\n  min (Byte): The lower bound\r\n  max (Byte): The upper bound\r\nReturns:\r\n  Byte: The clamped value"
    EnforceMinMaxRelation min, max

    Dim maxClamped As Byte
    maxClamped = IIf(value > max, max, value)
    ClampByte = IIf(maxClamped < min, min, maxClamped)
End Function

' Clamp function: restricts a value to specified upper and lower bounds
' Args:
'   value (Integer): The value to be clamped
'   min (Integer): The lower bound
'   max (Integer): The upper bound
' Returns:
'   Integer: The clamped value
Public Function ClampInteger(ByVal value As Integer, ByVal min As Integer, ByVal max As Integer) As Integer
Attribute ClampInteger.VB_Description = "Clamp function: restricts a value to specified upper and lower bounds\r\nArgs:\r\n  value (Integer): The value to be clamped\r\n  min (Integer): The lower bound\r\n  max (Integer): The upper bound\r\nReturns:\r\n  Integer: The clamped value"
    EnforceMinMaxRelation min, max

    Dim maxClamped As Integer
    maxClamped = IIf(value > max, max, value)
    ClampInteger = IIf(maxClamped < min, min, maxClamped)
End Function

' Clamp function: restricts a value to specified upper and lower bounds
' Args:
'   value (Long): The value to be clamped
'   min (Long): The lower bound
'   max (Long): The upper bound
' Returns:
'   Long: The clamped value
Public Function ClampLong(ByVal value As Long, ByVal min As Long, ByVal max As Long) As Long
Attribute ClampLong.VB_Description = "Clamp function: restricts a value to specified upper and lower bounds\r\nArgs:\r\n  value (Long): The value to be clamped\r\n  min (Long): The lower bound\r\n  max (Long): The upper bound\r\nReturns:\r\n  Long: The clamped value"
    EnforceMinMaxRelation min, max

    Dim maxClamped As Long
    maxClamped = IIf(value > max, max, value)
    ClampLong = IIf(maxClamped < min, min, maxClamped)
End Function

' Clamp function: restricts a value to specified upper and lower bounds
' Args:
'   value (Single): The value to be clamped
'   min (Single): The lower bound
'   max (Single): The upper bound
' Returns:
'   Single: The clamped value
Public Function ClampSingle(ByVal value As Single, ByVal min As Single, ByVal max As Single) As Single
Attribute ClampSingle.VB_Description = "Clamp function: restricts a value to specified upper and lower bounds\r\nArgs:\r\n  value (Single): The value to be clamped\r\n  min (Single): The lower bound\r\n  max (Single): The upper bound\r\nReturns:\r\n  Single: The clamped value"
    EnforceMinMaxRelation min, max

    ' Validate that value is not NaN
    Ensure.IsFalse IsNaNSingle(value), ErrorCodes.InvalidProcedureCall, "Numerics.ClampSingle", "value cannot be NaN"

    Dim maxClamped As Single
    maxClamped = IIf(value > max, max, value)
    ClampSingle = IIf(maxClamped < min, min, maxClamped)
End Function

' Clamp function: restricts a value to specified upper and lower bounds
' Args:
'   value (Double): The value to be clamped
'   min (Double): The lower bound
'   max (Double): The upper bound
' Returns:
'   Double: The clamped value
Public Function ClampDouble(ByVal value As Double, ByVal min As Double, ByVal max As Double) As Double
Attribute ClampDouble.VB_Description = "Clamp function: restricts a value to specified upper and lower bounds\r\nArgs:\r\n  value (Double): The value to be clamped\r\n  min (Double): The lower bound\r\n  max (Double): The upper bound\r\nReturns:\r\n  Double: The clamped value"
    EnforceMinMaxRelation min, max

    ' Validate that value is not NaN
    Ensure.IsFalse IsNaNDouble(value), ErrorCodes.InvalidProcedureCall, "Numerics.ClampDouble", "value cannot be NaN"

    Dim maxClamped As Double
    maxClamped = IIf(value > max, max, value)
    ClampDouble = IIf(maxClamped < min, min, maxClamped)
End Function

' Clamp function: restricts a value to specified upper and lower bounds
' Args:
'   value (Variant): The value to be clamped (must be comparable)
'   min (Variant): The lower bound
'   max (Variant): The upper bound
' Returns:
'   Variant: The clamped value
Public Function Clamp(ByVal value As Variant, ByVal min As Variant, ByVal max As Variant) As Variant
Attribute Clamp.VB_Description = "Clamp function: restricts a value to specified upper and lower bounds\r\nArgs:\r\n  value (Variant): The value to be clamped (must be comparable)\r\n  min (Variant): The lower bound\r\n  max (Variant): The upper bound\r\nReturns:\r\n  Variant: The clamped value"
    EnforceMinMaxRelation min, max

    Dim maxClamped As Variant
    If value > max Then
        maxClamped = max
    Else
        maxClamped = value
    End If

    If maxClamped < min Then
        Clamp = min
    Else
        Clamp = maxClamped
    End If
End Function

' Helper function to check if a Single value is NaN
Public Function IsNaNSingle(ByVal value As Single) As Boolean
Attribute IsNaNSingle.VB_Description = "Helper function to check if a Single value is NaN"
    IsNaNSingle = CStr(value) = "-1.#IND"
End Function

' Helper function to check if a Double value is NaN
Public Function IsNaNDouble(ByVal value As Double) As Boolean
Attribute IsNaNDouble.VB_Description = "Helper function to check if a Double value is NaN"
    IsNaNDouble = CStr(value) = "-1.#IND"
End Function