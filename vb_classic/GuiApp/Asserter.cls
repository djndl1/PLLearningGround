VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Asserter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

Private Const AssertionError As Long = 8192

Private m_handler As Variant

Private Property Get handler() As IErrorHandler
        If IsEmpty(m_handler) Then
                Set m_handler = New TextOutputErrorHandler
        End If

        Set handler = m_handler
End Property

Public Sub Init(ByVal handler As IErrorHandler)
        If IsEmpty(m_handler) Then
                Set m_handler = handler
        End If
End Sub

Public Sub IsTrue(ByVal booleanExpression As Boolean, _
                        Optional site As String = "", _
                        Optional message As String = "")
        If booleanExpression Then
                Call m_handler.Handle(0, site, message)
        Else
                Call m_handler.Handle(AssertionError, site, message)
        End If
End Sub

Public Sub IsFalse(ByVal booleanExpression As Boolean, _
                        Optional site As String = "", _
                        Optional message As String = "")
        If Not booleanExpression Then
                Call m_handler.Handle(0, site, message)
        Else
                Call m_handler.Handle(AssertionError, site, message)
        End If
End Sub

Public Sub AreEqual(ByVal expected As Variant, ByVal actual As Variant, _
                        Optional site As String = "", _
                        Optional message As String = "")
    If expected = actual Then
        Call m_handler.Handle(0, site, message)
    Else
        Dim fullMessage As String
        fullMessage = message & " (expected: " & FormatValue(expected) & ", actual: " & FormatValue(actual) & ")"
        Call m_handler.Handle(AssertionError, site, fullMessage)
    End If
End Sub

' Formats a value for display in error messages
Private Function FormatValue(ByVal v As Variant) As String
    On Error Resume Next
    Select Case VarType(v)
        Case vbInteger, vbLong
            FormatValue = CStr(v)
        Case vbSingle, vbDouble
            FormatValue = CStr(v)
        Case vbString
            FormatValue = """" & v & """"
        Case vbBoolean
            FormatValue = IIf(v, "True", "False")
        Case Else
            FormatValue = CStr(v)
    End Select
    On Error GoTo 0
End Function