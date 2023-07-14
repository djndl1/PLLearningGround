# this script is meant to run in bash

LINK_EXE="/c/Program Files/Microsoft Visual Studio/VB98/LINK.EXE"
LINKER_FLAGS="//NOLOGO"
LINKER_CONSOLE_SUBSYSTEM="//SUBSYSTEM:CONSOLE"

CC="/z/Programs/mingw32/bin/gcc.exe"
CPPFLAGS=-DUNICODE -D_UNICODE
CFLAGS=-std=c11  -municode -g
LDFLAGS=-mconsole

VB_EXE="/c/Program Files/Microsoft Visual Studio/VB98/VB6.EXE"

BUILD_DIR=build

CONSOLE_APP_SRC = Console.bas \
                  Program.bas \
                  VariantTest.bas \
                  AssertThat.bas \
                  AggregateTypesTest.bas \
                  ArrayTest.bas \
                  CollectionTest.bas

.PHONY: all
all: build/ConsoleApp.exe build/C2Hook.exe

build:
	mkdir -p $(BUILD_DIR)

run: build/ConsoleApp.exe
	build/ConsoleApp.exe

build/ConsoleApp.exe: ConsoleApp.vbp $(CONSOLE_APP_SRC) build
	$(VB_EXE) //MAKE ConsoleApp.vbp //OUTDIR $(BUILD_DIR)
	$(LINK_EXE) //EDIT $(LINKER_FLAGS) $(LINKER_CONSOLE_SUBSYSTEM) "$(BUILD_DIR)/ConsoleApp.exe"

build/C2Hook.exe: C2Hook.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< -o $@

.PHONY: TAGS
TAGS:
	find . -regex ".*.[(bas)|(cls)]"	| xargs etags

.PHONY: clean
clean:
	-rm -rf $(BUILD_DIR)
	-rm -f HOOK_*.txt
	-rm -f C2Hook.exe