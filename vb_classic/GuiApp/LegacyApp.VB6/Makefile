# this script is meant to run in powershell
LINK_EXE="C:/Program Files/Microsoft Visual Studio/VB98/LINK.EXE"
VB_EXE="C:/Program Files/Microsoft Visual Studio/VB98/VB6.EXE"

BUILD_DIR=build

LEGACYAPPVB6_SRC = $(wildcard *.bas) $(wildcard *.cls) $(wildcard *.frm)

.PHONY: all
all: build_LegacyAppVB6

build:
	mkdir $(BUILD_DIR)

build/LegacyAppVB6.dll: LegacyAppVB6.vbp $(LEGACYAPPVB6_SRC) build
	$(VB_EXE) -MAKE LegacyAppVB6.vbp -D LEGACY_OS=1 -OUTDIR $(BUILD_DIR)

build_LegacyAppVB6: build/LegacyAppVB6.dll

.PHONY: install
install: build_LegacyAppVB6
	-cp build/LegacyAppVB6.dll "C:/Program Files/Common Files/"
	-regsvr32.exe -s "C:/Program Files/Common Files/LegacyAppVB6.dll"


.PHONY: tags
tags:
	ctags *.bas *.cls *.frm

.PHONY: clean
clean:
	-powershell.exe -NoProfile -Command \
                            "Remove-Item -ErrorAction SilentlyContinue -Force -Recurse $(BUILD_DIR); \
                            exit 0