#include once "fbcunit.bi"

Public Function OnePlusOne() As Integer
   OnePlusOne = 1 + 1
End Function

SUITE(PlusSuite)
    ' setup
	SUITE_INIT

    	Return 0
    END_SUITE_INIT

    ' teardown
    SUITE_CLEANUP

    	Return 0
    END_SUITE_CLEANUP

    TEST(PlusTest)
    	CU_ASSERT(OnePlusOne() = 2)
    END_TEST
END_SUITE

fbcu.run_tests
