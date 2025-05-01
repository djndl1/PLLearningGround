AS=i686-linux-gnu-as
ASFLAGS=-g

LD=i686-linux-gnu-ld
LDFLAGS=

CC=i686-linux-gnu-gcc
CFLAGS=-no-pie

CXX=i686-linux-gnu-gxx
CXXFLAGS=


VRUN_PROG=

BARE_ASM = exit.bare \
		   findmax.bare
MAIN_ASM = exitmain.main

all: build_bares build_mains

build_bares: $(BARE_ASM)
build_mains: $(MAIN_ASM)

%.bare: %.S
	$(AS) $(ASFLAGS) -a=$<.lst -o $@.o $<
	$(LD) $(LDFLAGS) -o $@   $@.o

%.main: %.S
	$(CC) $(CFLAGS)  -o $@ $<

.PHONY:	clean
clean:
	-rm -f *.o
	-rm -f *.lst
	-rm -f $(BARE_ASM)
	-rm -f $(MAIN_ASM)
