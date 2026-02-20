VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Decimals"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Public Function RoundToZero(ByVal dec As Variant) As Variant
        Ensure.VariantType dec, vbDecimal, "Decimals.RoundToZero(Variant)"

        Dim rounded As Variant, toZero As Variant
        rounded = Round(dec)

        If dec > 0 And rounded > dec Then
                toZero = rounded - 1
        ElseIf dec < 0 And rounded < dec Then
                toZero = rounded + 1
        Else
                toZero = rounded
        End If

        RoundToZero = toZero
End Function

Private Sub TestRoundToZero()

End Sub