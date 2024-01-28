#include <stdbool.h>

#include <stc/cstr.h>
#include <stc/ccommon.h>

#include "utest.h"

UTEST(CSTR, LEN)
{
    cstr a = cstr_lit("ABCD");
    cstr b = cstr_lit("1234");

    cstr c = cstr_clone(a);
    printf("%s has size of %zu, capacity of %zu\n",
           cstr_str(&c), cstr_size(&c), cstr_capacity(&c));
    cstr_append_s(&c, b);

    EXPECT_EQ(true, cstr_equals(&c, "ABCD1234"));

    printf("%s has size of %zu, capacity of %zu\n",
           cstr_str(&c), cstr_size(&c), cstr_capacity(&c));

    cstr_drop(&c);
    cstr_drop(&b);
    cstr_drop(&a);
}

UTEST(CSTR, CONCAT)
{
    cstr a = cstr_lit("ABCD");
    cstr b = cstr_lit("1234");

    cstr c = cstr_clone(a);
    cstr_append_s(&c, b);

    printf("%s = %s + %s\n", cstr_str(&c), cstr_str(&a), cstr_str(&b));

    cstr_drop(&c);
    cstr_drop(&b);
    cstr_drop(&a);
}

UTEST(CSTR, ITERATOR)
{
    cstr a = cstr_lit("中文测试");
    cstr result = cstr_init();
    int n = 0;
    c_foreach(it, cstr, a) {
        cstr_push(&result, it.ref);
        cstr codepoint = cstr_from_n(it.ref, utf8_chr_size(it.ref));
        printf("%s", cstr_str(&codepoint));
        n++;

        cstr_drop(&codepoint);
    }
    ASSERT_EQ(n, cstr_u8_size(&result));
    ASSERT_EQ(true, cstr_equals(&result, "中文测试"));

    cstr_drop(&a);
    cstr_drop(&result);
}

UTEST_MAIN();
