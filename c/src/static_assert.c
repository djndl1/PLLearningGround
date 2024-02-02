#include <stdlib.h>
#include <stdbool.h>

#define static_assert(expr) ((void) sizeof(char[(expr) ? 1 : -1]))

int main()
{
    static_assert((2 + 2) % 3 == 1);

    const int _12 = 12;
    //static_assert(_12 == 13);
}
