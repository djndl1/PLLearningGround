#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>

#define OPTIONAL_IMPLEMENTATION
#define optional_element_t size_t
#include "optional.h"

#define OPTIONAL_IMPLEMENTATION
#define optional_element_t bool
#include "optional.h"

typedef struct dynarray_int_t {
    int *elements;
    size_t len;
} dynarray_int_t;

optional(size_t) index_of(const dynarray_int_t arr, int member)
{
    for (size_t i = 0; i < arr.len; i++) {
        if (arr.elements[i] == member) {
            return optional_some(size_t)(i);
        }
    }

    return optional_none(size_t);
}

static inline bool as_bool(unsigned char c)
{
    return c;
}

bool is_odd(size_t n)
{
    return !(n % 2);
}

int main(void)
{
    dynarray_int_t f = {
        .elements = (int[]){ 1, 2, 3, 4, 5, 6, 7 },
        .len = 7,
    };
    optional(size_t) result = index_of(f, 1);

    optional(bool) found = optional_map_to(bool, result, as_bool);
    printf(optional_present(found) ? "Found\n" : "Not found\n");

    match_begin(optional(size_t), result) {
        on_some_begin (size_t, found_idx_opt) {
            printf("Matched\n");
            printf("Found 1 at %zu\n", found_idx_opt);
        } on_some_end

        on_none_begin {
            printf("Not found");
        } on_none_end
    } match_end

    optional(size_t) filtered = optional_filter(size_t)(result, is_odd);
    assert(optional_present(filtered));

    optional(size_t) found_none = index_of(f, 8);

    match_begin (optional(size_t), found_none) {
        on_some_begin (size_t, _) {
            printf("Matched\n");
        } on_some_end

        on_none_begin {
            printf("Not found\n");
        } on_none_end
    } match_end
    assert(optional_or_else(found_none, 10) == 10);

    return 0;
}
