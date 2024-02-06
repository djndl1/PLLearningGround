#include <stdio.h>
#include <stdint.h>

#undef offsetof
#define offsetof(struct_type, member) ((long) ((uint8_t*) &((struct_type*) 0)->member))

#define alignof(type) (offsetof(struct { char a; type b; }, b))

int main()
{
    printf("custom alignof: %ld\n"
           "C11 _Alignof: %ld\n",
           alignof(char), _Alignof(char));
}
