
#include <stdbool.h>

#include <stc/cstr.h>

#define i_key_str
#include <stc/cvec.h>

#include <utest.h>

UTEST(CVEC, StringVector)
{
    cvec_str vec = cvec_str_init();
    cvec_str_push(&vec, cstr_lit("ABCD"));
    EXPECT_EQ(1, cvec_str_size(&vec));

    cstr const *s_unowned = cvec_str_at(&vec, 0);

    EXPECT_EQ(true, cstr_equals(s_unowned, "ABCD"));
    cvec_str_push(&vec, cstr_lit("1234"));
    cvec_str_push(&vec, cstr_lit("中文测试"));

    c_foreach(it, cvec_str, vec) {
        printf("%s\n", cstr_str(it.ref));
    }

    cvec_str_drop(&vec);
}

UTEST_MAIN();
