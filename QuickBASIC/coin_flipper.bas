' COIN FLIPPER
'
cls : randomize timer
input "I flip coins. How many should i flip"; numflips
print

for counter = 1 to numflips
	flip = int(2 * rnd(1))
	if flip = 0 then
		print "HEADS"
	else
		print "TAILS"
	end if
next counter

end
