10 CLS
20

Beginning:
Screen 12
color 13

Print "dsfsa", "dfa" ' with print zones
print "A"; " without spaces"


Dim a as integer
a = 5

print tab(a); "started at column "; a

let s$ = "I'm a string"
print s$

Dim n As String
input "What is your name"; n

print "My Name is "; n

for i = 1 to 10 step 2
    print i
next

SOUND 1000, 36

Open "qb_hello.dat" For Output As #1

Close #1

'GOTO Beginning

END
