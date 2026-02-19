VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MinMax"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Public Type VariantPair
    First As Variant
    Second As Variant
End Type

' Returns the minimum and maximum values from a set of values
Public Function MinMax(ByVal first As Variant, ParamArray numbers() As Variant) As VariantPair
Attribute MinMax.VB_Description = "Returns the minimum and maximum values from a set of values\r\nArgs:\r\n  first (Variant): The first value to compare\r\n  numbers (ParamArray Variant): Additional values to compare\r\nReturns:\r\n  VariantPair: A structure containing both minimum (First) and maximum (Second) values"
    Dim result As VariantPair
    Dim i As Integer
    Dim v As Variant

    result.First = first
    result.Second = first

    For i = LBound(numbers) To UBound(numbers)
        v = numbers(i)
        If v < result.First Then
            result.First = v
        End If
        If v > result.Second Then
            result.Second = v
        End If
    Next i

    MinMax = result
End Function

' Returns the minimum value from a set of values
Public Function Min(ByVal first As Variant, ParamArray numbers() As Variant) As Variant
Attribute Min.VB_Description = "Returns the minimum value from a set of values\r\nArgs:\r\n  first (Variant): The first value to compare\r\n  numbers (ParamArray Variant): Additional values to compare\r\nReturns:\r\n  Variant: The minimum value from the set"
    Dim result As Variant
    Dim i As Integer
    Dim v As Variant

    result = first

    For i = LBound(numbers) To UBound(numbers)
        v = numbers(i)
        If v < result Then
            result = v
        End If
    Next i

    Min = result
End Function

' Returns the maximum value from a set of values
Public Function Max(ByVal first As Variant, ParamArray numbers() As Variant) As Variant
Attribute Max.VB_Description = "Returns the maximum value from a set of values\r\nArgs:\r\n  first (Variant): The first value to compare\r\n  numbers (ParamArray Variant): Additional values to compare\r\nReturns:\r\n  Variant: The maximum value from the set"
    Dim result As Variant
    Dim i As Integer
    Dim v As Variant

    result = first

    For i = LBound(numbers) To UBound(numbers)
        v = numbers(i)
        If v > result Then
            result = v
        End If
    Next i

    Max = result
End Function

' Returns the larger of two Long values
Public Function MaxLong(ByVal first As Long, ByVal second As Long) As Long
Attribute MaxLong.VB_Description = "Returns the larger of two Long values\r\nArgs:\r\n  first (Long): First value to compare\r\n  second (Long): Second value to compare\r\nReturns:\r\n  Long: The larger of the two values"
    If first > second Then
        MaxLong = first
    Else
        MaxLong = second
    End If
End Function

' Returns the larger of two Integer values
Public Function MaxInteger(ByVal first As Integer, ByVal second As Integer) As Integer
Attribute MaxInteger.VB_Description = "Returns the larger of two Integer values\r\nArgs:\r\n  first (Integer): First value to compare\r\n  second (Integer): Second value to compare\r\nReturns:\r\n  Integer: The larger of the two values"
    If first > second Then
        MaxInteger = first
    Else
        MaxInteger = second
    End If
End Function

' Returns the smaller of two Long values
Public Function MinLong(ByVal first As Long, ByVal second As Long) As Long
Attribute MinLong.VB_Description = "Returns the smaller of two Long values\r\nArgs:\r\n  first (Long): First value to compare\r\n  second (Long): Second value to compare\r\nReturns:\r\n  Long: The smaller of the two values"
    If first < second Then
        MinLong = first
    Else
        MinLong = second
    End If
End Function

' Returns the smaller of two Integer values
Public Function MinInteger(ByVal first As Integer, ByVal second As Integer) As Integer
Attribute MinInteger.VB_Description = "Returns the smaller of two Integer values\r\nArgs:\r\n  first (Integer): First value to compare\r\n  second (Integer): Second value to compare\r\nReturns:\r\n  Integer: The smaller of the two values"
    If first < second Then
        MinInteger = first
    Else
        MinInteger = second
    End If
End Function

' Returns the larger of two Single values
Public Function MaxSingle(ByVal first As Single, ByVal second As Single) As Single
Attribute MaxSingle.VB_Description = "Returns the larger of two Single values\r\nArgs:\r\n  first (Single): First value to compare\r\n  second (Single): Second value to compare\r\nReturns:\r\n  Single: The larger of the two values"
    If first > second Then
        MaxSingle = first
    Else
        MaxSingle = second
    End If
End Function

' Returns the smaller of two Single values
Public Function MinSingle(ByVal first As Single, ByVal second As Single) As Single
Attribute MinSingle.VB_Description = "Returns the smaller of two Single values\r\nArgs:\r\n  first (Single): First value to compare\r\n  second (Single): Second value to compare\r\nReturns:\r\n  Single: The smaller of the two values"
    If first < second Then
        MinSingle = first
    Else
        MinSingle = second
    End If
End Function

' Returns the larger of two Double values
Public Function MaxDouble(ByVal first As Double, ByVal second As Double) As Double
Attribute MaxDouble.VB_Description = "Returns the larger of two Double values\r\nArgs:\r\n  first (Double): First value to compare\r\n  second (Double): Second value to compare\r\nReturns:\r\n  Double: The larger of the two values"
    If first > second Then
        MaxDouble = first
    Else
        MaxDouble = second
    End If
End Function

' Returns the smaller of two Double values
Public Function MinDouble(ByVal first As Double, ByVal second As Double) As Double
Attribute MinDouble.VB_Description = "Returns the smaller of two Double values\r\nArgs:\r\n  first (Double): First value to compare\r\n  second (Double): Second value to compare\r\nReturns:\r\n  Double: The smaller of the two values"
    If first < second Then
        MinDouble = first
    Else
        MinDouble = second
    End If
End Function