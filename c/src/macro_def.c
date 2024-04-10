#include <stdio.h>
#include <assert.h>

#define TEST_PRE TEST_POST

#define EXPANDABLE 1
#define CONCAT(a, b) a ## b


int main()
{
    const int CONCAT(EXPANDABLE, _2) = 1;
    static_assert(EXPANDABLE_2 == 1, "");

#define TEST_POST 1
    printf("TEST_PRE %d\n", TEST_PRE);
#undef TEST_POST
#define TEST_POST 2
    printf("TEST_PRE %d\n", TEST_PRE);
    return 0;
}
