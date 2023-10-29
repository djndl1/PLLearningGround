##
# FreeBASIC tutorial
#

# end
#
FBC=fbc

TEST_LIB=fbcunit/lib/libfbcunit.a

TEST_FLAGS=-g -mt -exx -i fbcunit/inc -p fbcunit/lib

TARGETS=FirstHello \
		FirstTest

.PHONY: all
all: $(TARGETS)

%: %.bas
	$(FBC) $< $(TEST_FLAGS) $(TEST_LIB)

.PHONY: clean
clean:
	-rm -f $(TARGETS)
