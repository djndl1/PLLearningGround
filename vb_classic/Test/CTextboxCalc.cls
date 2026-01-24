VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTextboxCalc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True

' The complete source code for CTextBoxCalc class
Public TextBox As TextBox
Public FormatMask As String
' We can trap events from max 5 TextBox controls.
Private WithEvents Text1 As TextBox
Private WithEvents Text2 As TextBox
Private WithEvents Text3 As TextBox
Private WithEvents Text4 As TextBox
Private WithEvents Text5 As TextBox
' Here we store the arguments passed to SetExpression.
Dim expression() As Variant

Sub SetExpression(ParamArray args() As Variant)
    Dim i As Integer, n As Integer
    ReDim expression(LBound(args) To UBound(args)) As Variant
    For i = LBound(args) To UBound(args)
        If IsObject(args(i)) Then
            ' Objects must be stored as such, using Set.
            Set expression(i) = args(i)
            If TypeName(args(i)) = "TextBox" Then
                n = n + 1
                If n = 1 Then Set Text1 = args(i)
                If n = 2 Then Set Text2 = args(i)
                If n = 3 Then Set Text3 = args(i)
                If n = 4 Then Set Text4 = args(i)
                If n = 5 Then Set Text5 = args(i)
            End If
        Else
            ' Store number and strings without the Set keyword.
            expression(i) = args(i)
        End If
    Next
End Sub

' Here we actually evaluate the result.
Sub EvalExpression()
    Dim i As Integer, opcode As Variant
    Dim value As Variant, operand As Variant
    On Error GoTo Error_Handler
    For i = LBound(expression) To UBound(expression)
        If Not IsObject(expression(i)) And VarType(expression(i)) _
            = vbString Then
                opcode = expression(i)
        Else
            ' This works with numbers and Text (default) properties alike.
            operand = CDbl(expression(i))
            Select Case opcode
                Case Empty: value = operand
                Case "+": value = value + operand
                Case "-": value = value - operand
                Case "*": value = value * operand
                Case "/": value = value / operand
            End Select
            opcode = Empty
        End If
    Next
    If Len(FormatMask) Then value = Format$(value, FormatMask)
    TextBox.Text = value
    Exit Sub
Error_Handler:
    TextBox.Text = ""
End Sub

' Here we trap events from the independent fields.
Private Sub Text1_Change()
    EvalExpression
End Sub

Private Sub Text2_Change()
    EvalExpression
End SubEnd Sub

Private Sub Text3_Change()
    EvalExpression
End SubEnd Sub

Private Sub Text4_Change()
    EvalExpression
End SubEnd Sub

Private Sub Text5_Change()
    EvalExpression
End SubEnd Sub