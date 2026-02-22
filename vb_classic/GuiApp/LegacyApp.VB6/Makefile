# this script is meant to run in powershell
LINK_EXE="C:/Program Files/Microsoft Visual Studio/VB98/LINK.EXE"
VB_EXE="C:/Program Files/Microsoft Visual Studio/VB98/VB6.EXE"

BUILD_DIR=build

# check the build system to see if it's a legacy OS
LEGACY_OS:=$(shell powershell.exe -NoProfile -Command '[int]((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentVersion -lt 6.2)')

LEGACYAPPVB6_SRC = $(wildcard *.bas) $(wildcard *.cls) $(wildcard *.frm)

.PHONY: all
all: build_LegacyAppVB6

build:
	mkdir $(BUILD_DIR)

build/LegacyAppVB6.dll: LegacyAppVB6.vbp $(LEGACYAPPVB6_SRC) build
	$(VB_EXE) -MAKE LegacyAppVB6.vbp -D LEGACY_OS=$(LEGACY_OS) -OUTDIR $(BUILD_DIR)

build_LegacyAppVB6: build/LegacyAppVB6.dll

.PHONY: install
install: build_LegacyAppVB6
	-cp build/LegacyAppVB6.dll "C:/Program Files/Common Files/"
	-regsvr32.exe -u -s "C:/Program Files/Common Files/LegacyAppVB6.dll"
	-regsvr32.exe -s "C:/Program Files/Common Files/LegacyAppVB6.dll"


.PHONY: tags
tags:
	ctags *.bas *.cls *.frm

.PHONY: clean
clean:
	-powershell.exe -NoProfile -Command \
                            "Remove-Item -ErrorAction SilentlyContinue -Force -Recurse $(BUILD_DIR); \
                            exit 0