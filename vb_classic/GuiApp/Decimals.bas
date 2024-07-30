Attribute VB_Name = "Decimals"
Option Explicit

Public Function RoundToZero(ByVal dec As Variant) As Variant
	Ensure.VariantType dec, vbDecimal, "RoundToZero(Variant)"
	
	Dim rounded As Variant, toZero As Variant
	rounded = Round(dec)

	If dec > 0 And rounded > dec Then
		toZero = rounded - 1	
	Elseif dec < 0 And rounded < dec Then
		toZero = rounded + 1
	else 
		toZero = rounded
	End If

	RoundToZero = toZero
End Function

Private Sub  TestRoundToZero() 

End Sub

