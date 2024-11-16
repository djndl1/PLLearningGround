bin_PROGRAMS = init_test \
	unistring_test \
	cstd_time \
	use_signal \
	inline_keywords \
	macro_def \
	static_assert \
	alignof \
	matrix \
	char_lit_is_int \
	char_lit_is_not_int \
    optional \
    xmacro \
	smart_enum \
    computed_include \
	result.test

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

use_signal_SOURCES = $(top_srcdir)/src/use_signal.c

inline_keywords_SOURCES = $(top_srcdir)/src/inline_keywords.c

macro_def_SOURCES = $(top_srcdir)/src/macro_def.c

static_assert_SOURCES = $(top_srcdir)/src/static_assert.c
alignof_SOURCES = $(top_srcdir)/src/alignof.c
matrix_SOURCES = $(top_srcdir)/src/matrix.c
char_lit_is_int_SOURCES = $(top_srcdir)/src/char_lit_is_int.c
char_lit_is_not_int_SOURCES = $(top_srcdir)/src/char_lit_is_not_int.cc
optional_SOURCES = $(top_srcdir)/src/optional.c
xmacro_SOURCES = $(top_srcdir)/src/xmacro.c
smart_enum_SOURCES = $(top_srcdir)/src/smart_enum.c
computed_include_SOURCES = $(top_srcdir)/src/computed_include.c

result_test_CFLAGS = -I$(INC_DIR)
result_test_SOURCES = $(top_srcdir)/src/result.test.c
