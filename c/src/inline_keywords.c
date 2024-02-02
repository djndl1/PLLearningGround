#include <stdlib.h>
#include <stdio.h>

static __inline void SpecialInlineFunc()
{
    printf("I'm inlined %p\n", &SpecialInlineFunc);
}

int main()
{
    SpecialInlineFunc();
}
