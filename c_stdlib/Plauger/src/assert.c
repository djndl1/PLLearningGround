#include <assert.h>

#include <stdio.h>
#include <stdlib.h>

void _assert_impl(char const* expr, char const* func, char const* file, const char* linenum)
{
    fprintf(stderr, "Assertion failed: %s, function %s, file %s xyz, line %s",
           expr, func, file, linenum);

    abort();
}
