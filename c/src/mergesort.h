#ifndef key_type
#error "key_type is not defined"
#endif

#include <stdlib.h>
#define _CONCAT(A, B) A ## B
#define CONCAT(A, B) _CONCAT(A, B)
#define merge_sort(T) CONCAT(T, _mergesort)

void merge_sort(key_type)(key_type keys[], int key_cmp_func(key_type, key_type), size_t sorted_indices[], size_t arrlen)
{
    if (keys == nullptr || arrlen <= 0 || sorted_indices == nullptr || key_cmp_func == nullptr) {
        return;
    }
}

#undef key_type
