#include "optional.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>

def_optional(size_t);
def_optional(bool);

optional(size_t) index_of(const int *arr, size_t len, int member)
{
    for (size_t i = 0; i < len; i++) {
        if (arr[i] == member) {
            return optional_some(size_t, i);
        }
    }

    return optional_none(size_t);
}

static inline bool as_bool(unsigned char c)
{
    return c;
}

bool is_odd(int n)
{
    return !(n % 2);
}

int main(void)
{
    int f[] = { 1, 2, 3, 4, 5, 6, 7 };
    optional(size_t) result = index_of(f, sizeof(f) / sizeof(f[0]), 1);

    optional(bool) found = optional_map(bool, result, as_bool);
    printf(optional_present(found) ? "Found\n" : "Not found\n");

    optional_match(size_t, result, found_idx_opt,
        scoped_stmt(
            printf("Matched\n"),
            printf("Found 1 at %zu\n", found_idx_opt)
        ),
            printf("Not found")
    );

    optional(size_t) filtered = optional_filter(size_t, result, is_odd);
    assert(optional_present(filtered));

    optional(size_t) found_none = index_of(f, sizeof(f) / sizeof(f[0]), 8);
    optional_match(size_t, found_none, _,
            printf("Matched\n"),
            printf("Not found\n")
        );
    assert(optional_or_else(found_none, 10) == 10);

    return 0;
}
