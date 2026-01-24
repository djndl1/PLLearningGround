# this script is meant to run in powershell
LINK_EXE="D:/Program Files/Microsoft Visual Studio/VB98/LINK.EXE"
VB_EXE="D:/Program Files/Microsoft Visual Studio/VB98/VB6.EXE"

BUILD_DIR=build

GUI_APP_SRC = $(wildcard *.bas) $(wildcard *.cls) $(wildcard *.frm)

.PHONY: all
all: build_GuiApp 

build:
	mkdir $(BUILD_DIR)

run: build_GuiApp
	build/GuiApp.exe

build/GuiApp.exe.config: GuiApp.exe.config
	cp $< $@

build/GuiApp.exe: GuiApp.vbp $(GUI_APP_SRC) build build/GuiApp.exe.config
	$(VB_EXE) -MAKE GuiApp.vbp -OUTDIR $(BUILD_DIR)

build_GuiApp: build/GuiApp.exe

.PHONY: tags
tags:
	ctags *.bas *.cls *.frm

.PHONY: clean
clean:
	-cmd.exe -c "del $(BUILD_DIR)"
