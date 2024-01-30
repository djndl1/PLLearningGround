#include <stdbool.h>
#include <stdlib.h>

#include <stc/ccommon.h>
#include <stc/calgo.h>

#define i_key int
#include <stc/cvec.h>

#define i_key double
#include <stc/cvec.h>

#include <stc/cstr.h>
#define i_key_str
#include <stc/cvec.h>

#include <utest.h>

UTEST(ForRange, forloop)
{
    cvec_int ints = cvec_int_init();

    c_forlist(it, int, {1, 2, 3, 4}) {
        cvec_int_push(&ints, *it.ref);
    }
    ASSERT_EQ(4, cvec_int_size(&ints));

    c_forrange(i, 5, 9, 1) {
        cvec_int_push(&ints, i);
    }
    ASSERT_EQ(8, cvec_int_size(&ints));

    c_foreach(it, cvec_int, ints) {
        printf("%d ", *it.ref);
    }
    putchar('\n');

    c_foreach(it, cvec_int, cvec_int_begin(&ints), cvec_int_end(&ints)) {
        printf("%d ", *it.ref);
    }
    putchar('\n');

    c_foreach_rv(it, cvec_int, ints) {
        printf("%d ", *it.ref);
    }
    putchar('\n');

    cvec_int_drop(&ints);
}

UTEST(RANGE, Generator)
{
    crange rng = crange_make(0, 100, 1);

    c_foreach(it, crange, rng) {
        printf("%ld ", *it.ref);
    }
    putchar('\n');

    c_forfilter(it, crange, rng, *it.ref % 2 == 0) {
        printf("%ld ", *it.ref);
    }
    putchar('\n');

    c_forfilter(it, crange, rng, c_flt_take(it, 50)) {
        printf("%ld ", *it.ref);
    }
    putchar('\n');
}

UTEST_MAIN();
