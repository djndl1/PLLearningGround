#include <stdio.h>

#define TEST_PRE TEST_POST

int main()
{
#define TEST_POST 1
    printf("TEST_PRE %d\n", TEST_PRE);
#undef TEST_POST
#define TEST_POST 2
    printf("TEST_PRE %d\n", TEST_PRE);
    return 0;
}
