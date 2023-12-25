#include "utest.h"

#include <stdbool.h>
#include <signal.h>
#include <stdio.h>

#define NDEBUG
#include <assert.h>

static int val = 0;

sig_atomic_t succeeded = 0;

static void do_nothing_assert()
{
    int i = 0;

    assert(i == 0);
    assert(i == 1);
}

static void field_abort(int sig)
{
    succeeded = (val == 1);

    quick_exit(succeeded ? EXIT_SUCCESS : EXIT_FAILURE);
}

#undef NDEBUG
#include <assert.h>

int main()
{
    assert(signal(SIGABRT, field_abort) != SIG_ERR);
    do_nothing_assert();
    assert(val == 0);
    val++;

    fputs("Sample assertion failure message\n", stderr);
    assert(val == 0);
    puts("FAILURE testing <assert.h>");

    return EXIT_FAILURE;
}
