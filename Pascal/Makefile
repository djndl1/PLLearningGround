FPC=fpc

FLAGS=-g -Fcutf8 -Sh -Cg

.phony: all

TARGET_BIN=FirstHello FirstTest

all: $(TARGET_BIN)

FirstHello: FirstHello.pas
	$(FPC) $(FLAGS) $< -o$@

FirstTest: FirstTest.pas
	$(FPC) $(FLAGS) $< -o$@

.phony: clean
clean:
	rm -rf $(TARGET_BIN) *.o *.ppu
