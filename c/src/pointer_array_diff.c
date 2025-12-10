#include "utest.h"

#include <string.h>

UTEST(POINTER, ASSIGNMENT_FROM_ARRAY_SYNTAX)
{
    char* p = { (char*)1 };

    EXPECT_EQ(p, (char*)1);
}

UTEST_MAIN();
