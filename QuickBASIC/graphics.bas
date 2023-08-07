Screen 12
Line (100, 100) - (200, 200), 1, B
Circle (320, 240), 20, 2
Pset (10, 10), 14
DRAW "c4 bm100,400 l50e50f50l50"

FOR i% = 0 TO 15
  COLOR i%
  PRINT "COLOR"; i%
NEXT i%

DO
  FOR i% = 1 TO 63
    PALETTE 0, i% * 256 + i%
  NEXT i%
  FOR i% = 63 TO 1 STEP -1
    PALETTE 0, i% * 256 + i%
  NEXT i%
LOOP WHILE INKEY$ = ""

DO: LOOP WHILE INKEY$ = ""

END
