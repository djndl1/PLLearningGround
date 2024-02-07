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

    // for-literal
    c_forlist(it, int, {1, 2, 3, 4}) {
        cvec_int_push(&ints, *it.ref);
    }
    ASSERT_EQ(4, cvec_int_size(&ints));

    // for python range
    c_forrange(i, 5, 9, 1) {
        cvec_int_push(&ints, i);
    }
    ASSERT_EQ(8, cvec_int_size(&ints));

    // for-iterator
    c_foreach(it, cvec_int, ints) {
        printf("%d ", *it.ref);
    }
    putchar('\n');

    c_foreach(it, cvec_int, cvec_int_begin(&ints), cvec_int_end(&ints)) {
        printf("%d ", *it.ref);
    }
    putchar('\n');

    // reverse-for-iterator
    c_foreach_rv(it, cvec_int, ints) {
        printf("%d ", *it.ref);
    }
    putchar('\n');

    cvec_int_drop(&ints);
}

/**
 * python-like range object
 */
UTEST(RANGE, Generator)
{
    crange rng = crange_make(0, 100, 1);

    c_foreach(it, crange, rng) {
        printf("%ld ", *it.ref);
    }
    putchar('\n');

    // foreach with a filter expression
    c_forfilter(it, crange, rng, *it.ref % 2 == 0) {
        printf("%ld ", *it.ref);
    }
    putchar('\n');

    c_forfilter(it, crange, rng, c_flt_take(it, 50)) {
        printf("%ld ", *it.ref);
    }
    putchar('\n');
}

UTEST(MAKE_DROP, MakeDrop)
{
    // constructor with an initializer_list
    cvec_int ints = c_make(cvec_int, { 1, 2, 3, 4, 5, 6, 7, 8});
    c_foreach(it, cvec_int, ints) {
        printf("%d ", *it.ref);
    }
    putchar('\n');
    c_drop(cvec_int, &ints);

    cvec_str strs = c_make(cvec_str, { "A", "B", "C", "D" });
    c_foreach(it, cvec_str, strs) {
        printf("%s ", cstr_str(it.ref));
    }
    putchar('\n');

    c_drop(cvec_str, &strs);
}

/**
 * Like C++'s new/delete, the handle itself is allocated on the heap
 * the entire handle is a copy of another temporary one
 */
UTEST(NEW_DEL, NewDelete)
{
    cvec_int ints = c_make(cvec_int, {1, 2, 3, 4});

    // bit-copy constructor
    cvec_int *newed_ints = c_new(cvec_int, ints);
    EXPECT_EQ(ints.data, newed_ints->data);
    // ints and newed_ints are of the same handle value
    ints.data = NULL;

    c_delete(cvec_int, newed_ints);
    c_drop(cvec_int, &ints);

    // the proper way to use c_new is
    // to construct an rvalue object and clone the entire handle
    cvec_int *stealing_ints = c_new(cvec_int, c_make(cvec_int, {1, 2, 3, 4}));

    c_delete(cvec_int, stealing_ints);
}

UTEST(FUNC_IF, find_if)
{
    cvec_int ints = c_make(cvec_int, { 1, 2, 3, 4, 5, 6, 7, 8});

    cvec_int_iter if_it;
    c_find_if(if_it, cvec_int, ints, *if_it.ref % 2 == 0);
    EXPECT_EQ(2, *if_it.ref);

drop_ints:
    cvec_int_drop(&ints);
}

UTEST(FUNC_IF, erase_if)
{
    cvec_int ints = c_make(cvec_int, { 1, 2, 3, 4, 5, 6, 7, 8});

    cvec_int_iter if_it;
    c_erase_if(if_it, cvec_int, ints, *if_it.ref % 2 == 0);
    EXPECT_EQ(4, cvec_int_size(&ints));

drop_ints:
    cvec_int_drop(&ints);
}

/**
 * erase and drop elements
 **/
UTEST(FUNC_IF, eraseremove_if)
{
    cvec_int ints = c_make(cvec_int, { 1, 2, 3, 4, 5, 6, 7, 8});

    cvec_int_iter if_it;
    c_eraseremove_if(if_it, cvec_int, ints, *if_it.ref % 2 == 0);
    EXPECT_EQ(4, cvec_int_size(&ints));

drop_ints:
    cvec_int_drop(&ints);
}

UTEST_MAIN();
