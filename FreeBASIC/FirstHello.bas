Namespace FirstHello

Declare Sub SayHello
Declare Sub Repeat
Declare Sub DoParrot
Declare Sub ForParrot
Declare Sub Decide(ByVal i As Long)

Private Sub Main()
    SayHello
    Repeat
    ForParrot
    DoParrot
    Decide(1)
    Decide(2)
    Decide(3)
End Sub

Public Sub SayHello()
   Dim text As String = "First" + "Hello" + Str(1)
   Print text
End Sub

Public Sub Repeat()
    Dim answer As String
    Input "Please input something so I can repeat: ", answer
    Print "Repeat: " + answer
End Sub

Public Sub DoParrot()
    Dim idx As Integer = 1
    Do
        If idx > 100 Then
            Exit Do
        End If

        Print "DoParroting "; idx
        idx += 1
    Loop
End Sub

Public Sub ForParrot()
    Dim idx As Integer
    For idx = 1 To 100
        Print "ForParroting "; idx
    Next
End Sub

Public Sub Decide(ByVal i As Long)
    If i = 1 Then
        Print "Single"
    ElseIf i = 2 Then ' BASIC uses `ElseIf`, Python uses `elif`, C uses `else if`
        Print "Double"
    Else
       Print "Too big"
    End If
End Sub

End Namespace

FirstHello.Main
