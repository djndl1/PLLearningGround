#include once "fbcunit.bi"

Const One = 1
Const OneStr = "1"

TEST(CONSTTEST)
	CU_ASSERT(One = 1)
    CU_ASSERT(OneStr = "1")
END_TEST

fbcu.run_tests
