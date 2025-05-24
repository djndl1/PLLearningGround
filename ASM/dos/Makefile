MASM=jwasm
MASMFLAGS=-q -c -6 -Fl

NASM=nasm
NASMFLAGS=-g -f obj -l $<.lst

LINK=jwlink
LINKFLAGS=Option Quiet \
	Option Map \
	Option Symfile \
	System Dos \
	Debug Dwarf

NASM_EXE = template_nasm.exe

MASM_EXE = template.exe \
	example.exe \
	add5bytes.exe \
	mov6bytes.exe \
	testflags.exe \
	ascbcd.exe    \
	findmax.exe	  \
	qword_add.exe \
	toupper.exe	\
	subtraction.exe \
	rotation.exe \
	sum.exe \
	x87fpu.exe \
	cls.exe \
	realmode32bit.exe \
	prod.exe

all: $(NASM_EXE) $(MASM_EXE) unreal.com

unreal.com: unreal.asm
	$(NASM) -l unreal.lst -o $@ $<

%.asm.obj: %.asm util.inc
	$(MASM) $(MASMFLAGS) -Fo$@  $<

%.exe: %.asm.obj
	$(LINK) $(LINKFLAGS) Name $@ File $<

%.nasm.obj: %.nasm
	$(NASM) $(NASMFLAGS) -o $@ $<

%_nasm.exe: %.nasm.obj
	$(LINK) $(LINKFLAGS) Name $@ File $<

# do not delete object files
.PRECIOUS: %.asm.obj %.nasm.obj

.PHONY:	clean
clean:
	-rm -f *.o *.obj *.OBJ
	-rm -f *.lst
	-rm -f *.map
	-rm -f *.sym
	-rm -f *.err
	-rm -f *.com
	-rm -f $(MASM_EXE) $(NASM_EXE)
