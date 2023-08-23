# this script is meant to run in bash
LINK_EXE="C:/Program Files/Microsoft Visual Studio/VB98/LINK.EXE"
LINKER_FLAGS=-NOLOGO
LINKER_CONSOLE_SUBSYSTEM=-SUBSYSTEM:CONSOLE

CC="gcc.exe"
CPPFLAGS=-DUNICODE -D_UNICODE
CFLAGS=-std=c17  -municode -g
LDFLAGS=-mconsole

VB_EXE="C:/Program Files/Microsoft Visual Studio/VB98/VB6.EXE"

BUILD_DIR=build

CONSOLE_APP_SRC = $(wildcard *.bas) $(wildcard *.cls) $(wildcard *.frm)

.PHONY: all
all: build_ConsoleApp build/C2Hook.exe

build:
	mkdir $(BUILD_DIR)

run: build_ConsoleApp
	build/ConsoleApp.exe

build/ConsoleApp.exe.config: ConsoleApp.exe.config
	cp $< $@

build/ConsoleApp.exe: ConsoleApp.vbp $(CONSOLE_APP_SRC) build build/ConsoleApp.exe.config
	$(VB_EXE) -MAKE ConsoleApp.vbp -OUTDIR $(BUILD_DIR)
	$(LINK_EXE) -EDIT $(LINKER_FLAGS) $(LINKER_CONSOLE_SUBSYSTEM) ./$(BUILD_DIR)/ConsoleApp.exe

build_ConsoleApp: build/ConsoleApp.exe

build/C2Hook.exe: C2Hook.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< -o $@

.PHONY: clean
clean:
	-powershell.exe -NoProfile -c \
                            Remove-Item -ErrorAction SilentlyContinue -Force -Recurse $(BUILD_DIR); \
                            Remove-Item -ErrorAction SilentlyContinue -Force HOOK_*.txt; \
                            Remove-Item -ErrorAction SilentlyContinue -Force C2Hook.exe; \
                            exit 0
