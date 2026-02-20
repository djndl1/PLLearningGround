Attribute VB_Name = "OleDates"
Option Explicit

Public Property Get Epoch() As Date
	Epoch = 0#
End Property

Public Function FormatAsISO8601(ByRef d As Date) As String
	FormatAsISO8601 = Format$(d, "yyyy-mm-ddThh:nn:ss")
End Function
