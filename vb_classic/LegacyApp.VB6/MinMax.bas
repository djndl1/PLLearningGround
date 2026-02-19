Attribute VB_Name = "MinMax"

Public Type MinMaxResult
    MinResult As Variant
    MaxResult As Variant
End Type

' Returns the minimum and maximum values from a set of values
Public Function MinMax(ByVal first As Variant, ParamArray numbers() As Variant) As MinMaxResult
    Dim result As MinMaxResult
    Dim i As Integer
    Dim v As Variant

    result.MinResult = first
    result.MaxResult = first

    For i = LBound(numbers) To UBound(numbers)
        v = numbers(i)
        If v < result.MinResult Then
            result.MinResult = v
        End If
        If v > result.MaxResult Then
            result.MaxResult = v
        End If
    Next i

    MinMax = result
End Function

' Returns the minimum value from a set of values
Public Function Min(ByVal first As Variant, ParamArray numbers() As Variant) As Variant
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
    If first > second Then
        MaxLong = first
    Else
        MaxLong = second
    End If
End Function

' Returns the larger of two Integer values
Public Function MaxInteger(ByVal first As Integer, ByVal second As Integer) As Integer
    If first > second Then
        MaxInteger = first
    Else
        MaxInteger = second
    End If
End Function

' Returns the smaller of two Long values
Public Function MinLong(ByVal first As Long, ByVal second As Long) As Long
    If first < second Then
        MinLong = first
    Else
        MinLong = second
    End If
End Function

' Returns the smaller of two Integer values
Public Function MinInteger(ByVal first As Integer, ByVal second As Integer) As Integer
    If first < second Then
        MinInteger = first
    Else
        MinInteger = second
    End If
End Function

' Returns the larger of two Single values
Public Function MaxSingle(ByVal first As Single, ByVal second As Single) As Single
    If first > second Then
        MaxSingle = first
    Else
        MaxSingle = second
    End If
End Function

' Returns the smaller of two Single values
Public Function MinSingle(ByVal first As Single, ByVal second As Single) As Single
    If first < second Then
        MinSingle = first
    Else
        MinSingle = second
    End If
End Function

' Returns the larger of two Double values
Public Function MaxDouble(ByVal first As Double, ByVal second As Double) As Double
    If first > second Then
        MaxDouble = first
    Else
        MaxDouble = second
    End If
End Function

' Returns the smaller of two Double values
Public Function MinDouble(ByVal first As Double, ByVal second As Double) As Double
    If first < second Then
        MinDouble = first
    Else
        MinDouble = second
    End If
End Function
