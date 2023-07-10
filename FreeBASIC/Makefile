##
# FreeBASIC tutorial
#

# end
#
FBC=fbc

TARGETS=FirstHello

.PHONY: all
all: $(TARGETS)

FirstHello: FirstHello.bas
	$(FBC) $<

.PHONY: clean
clean:
	-rm -f $(TARGETS)
