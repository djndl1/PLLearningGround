bin_PROGRAMS = init_test \
	unistring_test \
	cstd_time

init_test_SOURCES = $(top_srcdir)/src/init_test.c


INC_DIR = $(top_srcdir)/src/include

gnulib_CFLAGS = -I$(top_builddir)/lib \
				-I$(top_srcdir)/lib

gnulib_LDFLAGS = -L$(top_srcdir)/lib \
				-L$(builddir)/lib

LDADD = $(top_builddir)/lib/libgnu.a

init_test_CFLAGS = -I$(INC_DIR) $(gnulib_CFLAGS)
init_test_LDFLAGS = $(gnulib_LDFLAGS)

# unistring flags
unistring_test_SOURCES = $(top_srcdir)/src/unistring_test.c

unistring_test_CFLAGS = -I$(INC_DIR) $(gnulib_CFLAGS)
unistring_test_LDFLAGS = $(gnulib_LDFLAGS)

cstd_time_SOURCES = $(top_srcdir)/src/cstd_time.c
cstd_time_LDFLAGS = -lpthread
cstd_time_CFLAGS = -I$(INC_DIR)
