' section 1
CLS
RANDOMIZE TIMER
yourScore% = INT(RND * 1000)
PRINT "Game Over"
PRINT "Your score is "; yourScore%
DIM playername$(1 TO 10)    'Declare arrays for the 10 entries on the list
DIM playerscore%(1 TO 10)

' section 2
OPEN "top10.dat" FOR INPUT AS #1
  DO WHILE NOT EOF(1)          ' EOF means "end of file"
    i% = i% + 1
    INPUT #1, playername$(i%)  'Read from file
    INPUT #1, playerscore%(i%)
  LOOP
CLOSE #1
PRINT

' section 3
FOR i% = 1 TO 10
  IF yourScore% >= playerscore%(i%) THEN
    FOR ii% = 10 TO i% + 1 STEP -1      'Go backwards (i% < 10)
      playername$(ii%) = playername$(ii% - 1)
      playerscore%(ii%) = playerscore%(ii% - 1)
    NEXT ii%
    PRINT "Congratulations! You have made the top 10!"
    INPUT "What is your name? ", yourName$
    playername$(i%) = yourName$
    playerscore%(i%) = yourScore%
    EXIT FOR
  END IF
NEXT i%

' section 4
OPEN "top10.dat" FOR OUTPUT AS #1
  FOR i% = 1 TO 10
    WRITE #1, playername$(i%), playerscore%(i%)
  NEXT i%
CLOSE #1

' section 5
PRINT
PRINT "Here is the top 10"
format$ = "\                        \  #### "
    PRINT "Player Name                 Score"
    PRINT "--------------------------  -----"
FOR i% = 1 TO 10
  PRINT USING format$; playername$(i%); playerscore%(i%)
NEXT i%
END
