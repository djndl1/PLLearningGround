$Debug

Screen 13
_FullScreen
Out &H3C8, 0: Out &H3C9, 0: Out &H3C9, 0: Out &H3C9, 20
Color 1
For i% = 1 To 21
    Locate 2 + i%, 2: Print Chr$(178)
    Locate 2 + i%, 39: Print Chr$(178)
Next i%
For i% = 2 To 39
    Locate 2, i%: Print Chr$(223)
    Locate 23, i%: Print Chr$(220)
Next i%
Color 9
Locate 3, 16: Print Chr$(34); "MY BONNIE"; Chr$(34)
Sleep 3
For i% = 1 To 34
    Select Case i%
        Case 1: Locate 5, 5
        Case 10: Locate 10, 5
        Case 18: Locate 15, 5
        Case 27: Locate 20, 5
    End Select
    Read note%, duration%, word$
    Sound note%, duration%: Print word$;
Next i%
Sleep 2
Locate 23, 16: Print "Thank You!"
Sleep 4
System

Data 392,8,"My ",659,8,"Bon-",587,8,"nie ",523,8,"lies ",587,8,"O-",523,8,"Ver ",440,8,"the "
Data 392,8,"O-",330,32,"cean ",392,8,"My ",659,8,"Bon-",587,8,"nie ",523,8,"lies "
Data 523,8,"O-",494,8,"ver ",523,8,"the ",587,40,"sea ",392,8,"My ",659,8,"Bon-",587,8,"nie"
Data 523,8," lies ",587,8,"O-",523,8,"ver ",440,8,"the ",392,8,"O-",330,32,"cean ",392,8,"Oh "
Data 440,8,"bring ",587,8,"back ",523,8,"my ",494,8,"Bon-",440,8,"nie ",494,8,"to ",523,32,"me..!"
