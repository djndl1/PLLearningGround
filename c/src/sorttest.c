#include "utest.h"

#define key_type int
#include "mergesort.h"

static int int_cmp(int a, int b)
{
    if (a > b) return 1;
    else if (a < b ) return -1;
    return 0;
}

UTEST(mergesort, empty_array)
{
    int keys[1];
    size_t indices[1] = { -1 };
    merge_sort(int)(keys, int_cmp, indices, 0);
    EXPECT_EQ(indices[0], -1);

    merge_sort(int)(nullptr, int_cmp, indices, 1);
    EXPECT_EQ(indices[0], -1);

    merge_sort(int)(keys, nullptr, indices, 1);
    EXPECT_EQ(indices[0], -1);

    merge_sort(int)(keys, int_cmp, nullptr, 1);
    EXPECT_EQ(indices[0], -1);
}


UTEST_MAIN();
