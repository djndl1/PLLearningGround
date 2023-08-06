##
# FreeBASIC tutorial
#

# end
#
QBC=qb64

TARGETS=qb_hello octaves Bonnie playerscore read_record

QBFLAGS=-x

.PHONY: all
all: $(TARGETS)

%: %.bas
	$(QBC) $(QBFLAGS) $< -o ${PWD}/$@

.PHONY: clean
clean:
	-rm -f $(TARGETS)
