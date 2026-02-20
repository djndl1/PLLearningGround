VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Ensure"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' Ensures that an object reference is not Nothing
' Args:
'   obj (Object): The object reference to check
'   source (String): Optional source identifier for error reporting
Public Sub NotNothing(ByVal obj As Object, Optional source As String = "")
Attribute NotNothing.VB_Description = "Ensures that an object reference is not Nothing\r\nArgs:\r\n  obj (Object): The object reference to check\r\n  source (String): Optional source identifier for error reporting"
    IsTrue (obj Is Nothing), ErrorCodes.ObjectVariableNotSet, source
End Sub

' Ensures that a variant has the specified type
' Args:
'   v (Variant): The variant to check
'   t (VbVarType): The expected variable type
'   source (String): Optional source identifier for error reporting
Public Sub VariantType(ByRef v As Variant, ByVal t As VbVarType, Optional source As String = "")
Attribute VariantType.VB_Description = "Ensures that a variant has the specified type\r\nArgs:\r\n  v (Variant): The variant to check\r\n  t (VbVarType): The expected variable type\r\n  source (String): Optional source identifier for error reporting"
    IsTrue VarType(v) = t, ErrorCodes.TypeMismatch, source
End Sub

' Raises an error if the condition is true
' Args:
'   b (Boolean): The condition to check
'   errCode (Long): The error code to raise if condition is true
'   source (String): Optional source identifier for error reporting
Public Sub IsFalse(ByVal b As Boolean, ByVal errCode As Long, Optional source As String = "")
Attribute IsFalse.VB_Description = "Raises an error if the condition is true\r\nArgs:\r\n  b (Boolean): The condition to check\r\n  errCode (Long): The error code to raise if condition is true\r\n  source (String): Optional source identifier for error reporting"
    If b Then
        Err.Raise errCode, source
    End If
End Sub

' Raises an error if the condition is false
' Args:
'   b (Boolean): The condition to check
'   errCode (Long): The error code to raise if condition is false
'   source (String): Optional source identifier for error reporting
Public Sub IsTrue(ByVal b As Boolean, ByVal errCode As Long, Optional source As String = "")
Attribute IsTrue.VB_Description = "Raises an error if the condition is false\r\nArgs:\r\n  b (Boolean): The condition to check\r\n  errCode (Long): The error code to raise if condition is false\r\n  source (String): Optional source identifier for error reporting"
    If Not b Then
        Err.Raise errCode, source
    End If
End Sub

' Ensures that two values are not equal
' Args:
'   a (Variant): First value to compare
'   b (Variant): Second value to compare
'   errCode (Long): The error code to raise if values are equal
'   source (String): Optional source identifier for error reporting
Public Sub NotEqual(ByVal a As Variant, ByVal b As Variant, ByVal errCode As Long, Optional source As String = "")
Attribute NotEqual.VB_Description = "Ensures that two values are not equal\r\nArgs:\r\n  a (Variant): First value to compare\r\n  b (Variant): Second value to compare\r\n  errCode (Long): The error code to raise if values are equal\r\n  source (String): Optional source identifier for error reporting"
    IsFalse a = b, errCode, source
End Sub

' Ensures that two values are equal
' Args:
'   a (Variant): First value to compare
'   b (Variant): Second value to compare
'   errCode (Long): The error code to raise if values are not equal
'   source (String): Optional source identifier for error reporting
Public Sub AreEqual(ByVal a As Variant, ByVal b As Variant, ByVal errCode As Long, Optional source As String = "")
Attribute AreEqual.VB_Description = "Ensures that two values are equal\r\nArgs:\r\n  a (Variant): First value to compare\r\n  b (Variant): Second value to compare\r\n  errCode (Long): The error code to raise if values are not equal\r\n  source (String): Optional source identifier for error reporting"
    IsTrue a = b, errCode, source
End Sub