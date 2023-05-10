bin_PROGRAMS = init_test

init_test_SOURCES = $(top_srcdir)/src/init_test.c


INC_DIR = $(top_srcdir)/src/include

gnulib_CFLAGS = -I$(top_builddir)/lib \
				-I$(top_srcdir)/lib

gnulib_LDFLAGS = -L$(top_srcdir)/lib \
				-L$(builddir)/lib

LDADD = $(top_builddir)/lib/libgnu.a

init_test_CFLAGS = -I$(INC_DIR) $(gnulib_CFLAGS)
init_test_LDFLAGS = $(gnulib_LDFLAGS)
