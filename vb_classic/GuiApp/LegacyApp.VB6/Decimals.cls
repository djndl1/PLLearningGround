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
        Ensure.VariantType dec, vbDecimal, "Decimals.RoundToZero(Variant)", "dec is not a decimal type"

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

' TruncationDivision performs truncation (round-toward-zero) division on two
' Decimal values and returns both the quotient and the remainder as a
' VariantPair. Truncation quotient = Fix(dividend / divisor); the remainder
' inherits the sign of the dividend.
'
' Why this exists: VB6's built-in \ and Mod operators coerce both Decimal
' operands to Long per the language spec (Effective Value Type table: Decimal
' \/Mod Decimal -> Long). For values exceeding Long.MaxValue (2,147,483,647)
' -- including the tick-per-day constant 86,400,000,000 used by CTimeSpans --
' this coercion throws overflow (error 6) before the \/Mod runs.
' TruncationDivision has no such limit; it works on the full Decimal range
' (+/- 79,228,162,514,264,337,593,543,950,335).
'
' Semantics (matches Fix-based rounding toward zero, equivalent to VB6's
' built-in \ and Mod for negative dividends):
'   * Sign of the quotient: rounds toward zero, so abs(quotient) <= abs(dividend / divisor).
'   * Sign of the remainder: same sign as the dividend (matches VB6's built-in Mod).
'   * Invariant: dividend = quotient * divisor + remainder (exactly, in Decimal).
'   * Magnitude of remainder: abs(remainder) < abs(divisor).
'   * Zero divisor: throws a division-by-zero error.
'   * 7 / 3 = (2, 1)        (quotient 2, remainder 1)
'   * 7 / -3 = (-2, 1)       (quotient -2, remainder 1)
'   * -7 / 3 = (-2, -1)      (quotient -2, remainder -1)
'   * -7 / -3 = (2, -1)      (quotient 2, remainder -1)
' Args:
'   dividend (Variant): A Decimal value. Validated via Ensure.VariantType.
'   divisor  (Variant): A Decimal value. Validated via Ensure.VariantType.
'                        Must be non-zero.
' Returns:
'   VariantPair: First is the quotient (Decimal, truncated toward zero), Second
'                is the remainder (Decimal, same sign as the dividend).
Public Function TruncationDivision(ByVal dividend As Variant, ByVal divisor As Variant) As VariantPair
Attribute TruncationDivision.VB_Description = "Performs truncation (round-toward-zero) division on two Decimal values.\r\n\r\nReturns a VariantPair with First = quotient, Second = remainder. Quotient is rounded toward zero; remainder inherits the sign of the dividend.\r\n\r\nWhy this exists: VB6's built-in \\ and Mod operators coerce Decimal operands to Long (overflow for values exceeding Long.MaxValue, e.g. tick-per-day 86400000000). TruncationDivision works on the full Decimal range.\r\n\r\nSemantics:\r\n  Quotient: rounds toward zero (Fix-based).\r\n  Remainder: same sign as the dividend; abs(remainder) < abs(divisor).\r\n  Invariant: dividend = quotient * divisor + remainder.\r\n  Zero divisor: raises a Decimal / Decimal division-by-zero error.\r\n  Examples:\r\n    7 / 3 = (2, 1)\r\n    7 / -3 = (-2, 1)\r\n    -7 / 3 = (-2, -1)\r\n    -7 / -3 = (2, -1)\r\nArgs:\r\n  dividend (Variant): A Decimal value. Validated via Ensure.VariantType.\r\n  divisor (Variant): A Decimal value. Validated via Ensure.VariantType. Must be non-zero.\r\nReturns:\r\n  VariantPair: First = quotient (Decimal, truncated toward zero), Second = remainder (Decimal, same sign as dividend)."
    Ensure.VariantType dividend, vbDecimal, "Decimals.TruncationDivision", "dividend is not a Decimal"
    Ensure.VariantType divisor, vbDecimal, "Decimals.TruncationDivision", "divisor is not a Decimal"
    Dim result As VariantPair
    result.first = Fix(CDec(dividend) / CDec(divisor))
    result.second = CDec(dividend) - CDec(result.first) * CDec(divisor)
    TruncationDivision = result
End Function

Private Sub TestRoundToZero()

End Sub