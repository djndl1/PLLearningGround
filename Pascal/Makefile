FPC=fpc

FLAGS=-g -Fcutf8 -Sh

.phony: all

TARGET_BIN=FirstHello

all: $(TARGET_BIN)

%: %.pas
	$(FPC) $(FLAGS) $< -o$@

.phony: clean
clean:
	rm -rf $(TARGET_BIN) *.o
