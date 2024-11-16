#include "utest.h"

#include <stdlib.h>

#define variant_result_err_t int
#define variant_result_val_t int
#define variant_result_name result_int_t
#include "result.h"

UTEST(RESULT, OK)
{
    result_int_t res = result_int_t_ok(1);

    match_begin(result_int_t, res) {
        on_ok_begin(int, val) {
            ASSERT_EQ(val, 1);
        } on_ok_end
        on_err_begin(int, err) {
            ASSERT_FALSE(true);
        } on_err_end
    } match_end
}

UTEST(RESULT, ERR)
{
    result_int_t res = result_int_t_err(1);

    int errnum = 0;

    match_begin(result_int_t, res) {

        on_ok_begin (int, val) {
            ASSERT_FALSE(true);
        } on_ok_end

        on_err_begin (int, err) {
            ASSERT_EQ(err, 1);
            errnum = err;
        } on_err_end

    } match_end

    ASSERT_EQ(errnum, 1);
}

UTEST(RESULT, NESTED)
{
    result_int_t outer = result_int_t_ok(1);
    match_begin (result_int_t, outer) {
        on_ok_begin (int, val) {
            ASSERT_EQ(val, 1);

            result_int_t inner = result_int_t_ok(2);
            match_begin (result_int_t, inner) {

                on_ok_begin (int, val) {
                    ASSERT_EQ(val, 2);
                } on_ok_end

                on_err_begin (int, err) {
                    ASSERT_TRUE(false);
                } on_err_end
            } match_end

            ASSERT_EQ(val, 1);
        } on_ok_end
    } match_end
}


UTEST_MAIN();
