##
# FreeBASIC tutorial
#

# end
#
QBC=qb64

TARGETS=qb_hello octaves Bonnie playerscore read_record graphics\
				coin_flipper toolbox

QBFLAGS=-x -f:StripDebugSymbols=false -f:OptimizeCppProgram=false -f:ExtraCppFlags=-g

.PHONY: all
all: $(TARGETS)

%: %.bas
	$(QBC) $(QBFLAGS) $< -o ${PWD}/$@

.PHONY: clean
clean:
	-rm -f $(TARGETS)
