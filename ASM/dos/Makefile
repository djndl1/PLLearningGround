MASM ?= # path to MASM-compabilt assembler
MASM=jwasm
MASMFLAGS=-q -c -8 -Fl        # MASM-compatible assembler options

NASM ?= # path to NASM assembler
NASM=nasm
NASMFLAGS=-g -f obj -l $<.lst # NASM options

LINK ?= # linker to use
LINK=jwlink
LINKFLAGS=Option Quiet \
	Option Map \
	Option Symfile \
	System Dos \
	Debug Dwarf

NASM_EXE ?= # executables to build by NASM-compatible assembler
NASM_EXE = template_nasm.exe    # executables to build by NASM

MASM_EXE ?= # executables to build by MASM-compatible assembler
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
	prod.exe \
	transfer_string.exe \
	move_cursor.exe

all: $(NASM_EXE) $(MASM_EXE) unreal.com # build all executables

unreal.com: unreal.asm					# build unreal mode example
	$(NASM) -l unreal.lst -o $@ $<

%.asm.obj: %.asm util.inc
	$(MASM) $(MASMFLAGS) -Fo$@  $<

%.exe: %.asm.obj
	$(LINK) $(LINKFLAGS) Name $@ File $<

%.nasm.obj: %.nasm
	$(NASM) $(NASMFLAGS) -o $@ $<

%_nasm.exe: # build all NASM executables
%_nasm.exe: %.nasm.obj
	$(LINK) $(LINKFLAGS) Name $@ File $<

# do not delete object files
.PRECIOUS: %.asm.obj %.nasm.obj

.PHONY:	clean
clean: # clean up all build artifacts
	-rm -f *.o *.obj *.OBJ
	-rm -f *.lst
	-rm -f *.map
	-rm -f *.sym
	-rm -f *.err
	-rm -f *.com
	-rm -f $(MASM_EXE) $(NASM_EXE)

.PHONY: help
help: # Shows interactive help.
	@echo
	@echo "make variables:"
	@echo
	@sed -e 's/^\([^ 	]\+\)[ 	]*?=[^#]\+#\(.*\)$$/\1 \2/p;d' Makefile | column -t -l 2 | sort
	@echo
	@echo "make targets:"
	@echo
	@sed -e 's/^\([^: 	]\+\):.*#\(.*\)$$/\1 \2/p;d' Makefile | column -t -l 2 | sort
