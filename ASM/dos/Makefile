AS=jwasm
ASFLAGS=-q -mz -6 -Fl

LD=jwlink
LDFLAGS=

EXE = example.exe \
	add5bytes.exe \
	mov6bytes.exe \
	testflags.exe \
	ascbcd.exe    \
	findmax.exe	  \
	qword_add.exe \
	toupper.exe	\
	subtraction.exe

all: $(EXE)

%.exe: %.asm
	$(AS) $(ASFLAGS) -Fo$@  $<

.PHONY:	clean
clean:
	-rm -f *.o *.obj *.OBJ
	-rm -f *.lst
	-rm -f *.err
	-rm -f $(EXE)
