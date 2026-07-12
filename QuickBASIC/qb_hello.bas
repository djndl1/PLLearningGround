$Debug
10 Cls
20 Cls

Beginning:
Screen 12
Color 13

Print "dsfsa", "dfa" ' with print zones
Print "A"; " without spaces"


Dim a As Integer
a = 5

Print Tab(a); "started at column "; a

Let s$ = "I'm a string"
Print s$

Dim n As String
Input "What is your name"; n

Print "My Name is "; n

For i = 1 To 10 Step 2
    Print i
Next

Sound 1000, 36

Open "qb_hello.dat" For Output As #1

Close #1

'GOTO Beginning

End
