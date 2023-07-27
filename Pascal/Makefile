FPC=fpc

FLAGS=-g -MDELPHIUNICODE

.phony: all

TARGET_BIN=FirstHello

all: $(TARGET_BIN)

%: %.pas
	$(FPC) $(FLAGS) $< -o$@

.phony: clean
clean:
	rm -rf $(TARGET_BIN) *.o
