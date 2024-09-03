Attribute VB_Name = "Ensure"
Option Explicit

Public Sub NotNothing(ByVal obj As Object, Optional source As String = "")
	IsTrue (obj Is Nothing), ErrorCodes.ObjectVariableNotSet, source
End Sub

Public Sub VariantType(ByRef v As Variant, ByVal t As vbVarType, Optional source As String = "")
	IsTrue VarType(v) = t, ErrorCodes.TypeMismatch, source
End Sub

Public Sub IsFalse(ByVal b As Boolean, ByVal errCode As Long, Optional source As String = "")
	If b Then
		Err.Raise ErrorCodes.TypeMismatch, source
	End If
End Sub

Public Sub IsTrue(ByVal b As Boolean, ByVal errCode As Long, Optional source As String = "")
	If Not b Then
		Err.Raise errCode, source
	End If
End Sub
