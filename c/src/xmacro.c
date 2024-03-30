#include <stdio.h>
#include <assert.h>
#include <stdint.h>

#define _STRINGIFY(s) #s
#define STRINGIFY(s) _STRINGIFY(s)

#define A_TABLE \
    X(A, 1) \
    X(B, 2) \
    X(C, 3)

#define X(a, b) a = b,
enum an_enum {
    A_TABLE
};
#undef X

#define X(a, b) [a] = STRINGIFY(a),
char *an_array[] = {
     A_TABLE
};
#undef X

#define A_TABLE2(row) \
    row(A2, 1) \
    row(B2, 2) \
    row(C2, 3) \
    row(D2, 4)

#define ARR_ELM(a, b) [a] = STRINGIFY(a),
#define ENUM_ELM(a, b) a = b,
#define EXPAND_AS_ONE(...) 1,

#define TABLE_SIZE(TABLE)                       \
    static uint8_t TABLE##_size_helper[] = {             \
     TABLE(EXPAND_AS_ONE) \
};                                                                      \
int TABLE##_size =  sizeof(TABLE##_size_helper) / sizeof(TABLE##_size_helper[0]);

TABLE_SIZE(A_TABLE2);


enum an_enum2 {
    A_TABLE2(ENUM_ELM)
};

char *an_array2[] = {
     A_TABLE2(ARR_ELM)
};

// Java-style Smart Enums

// define smart enum fields
typedef struct my_enum_meta_t {
    int enum_val;
    int code;
    char *name;
} my_enum_meta_t;

// define instance values
#define MY_ENUM_TYPE(ROW) \
    ROW(MY_A, 3, "Enum Value A") \
    ROW(MY_B, 40000000, "Enum Value B") \
    ROW(MY_C, 40000001, "Enum Value C")

// generate external enum types
#define ENUM_DEF(a, b, c) a = b,
enum MY_ENUM {
   MY_ENUM_TYPE(ENUM_DEF)
};

// define constructor
#define ENUM_META_VAL(a, b, c) \
    (my_enum_meta_t){ .enum_val = a, .code = b, .name = c }

// generate instance fields with constructor
#define MY_ENUM_META(e) (e ## _meta)
#define ENUM_META_DEF(a, b, c) \
    const my_enum_meta_t MY_ENUM_META(a) = ENUM_META_VAL(a, b, c);
MY_ENUM_TYPE(ENUM_META_DEF)

// map enum values to instances
#define MY_ENUM_RET_META(a, b, c) case a: return MY_ENUM_META(a);
static inline my_enum_meta_t my_enum_get_meta(enum MY_ENUM e)
{
    switch (e)
    {
        MY_ENUM_TYPE(MY_ENUM_RET_META)
        default: return (my_enum_meta_t){ -1 };
    }
}

// getters
#define MY_ENUM_NAME(e) (my_enum_get_meta(e).name)
#define MY_ENUM_CODE(e) (my_enum_get_meta(e).code)

// optional: in case enumeration of all values is needed
#define MY_ENUM_AS_ARR_ELM(a, b, c) a,
#define ENUM_META_ARR_VAL(a, b, c) \
    ENUM_META_VAL(a, b, c),
const enum MY_ENUM my_enums[] = {
    MY_ENUM_TYPE(MY_ENUM_AS_ARR_ELM)
};
const my_enum_meta_t my_enums_metas[] = {
    MY_ENUM_TYPE(ENUM_META_ARR_VAL)
};

int main(void)
{
    for (int i = 0; i < sizeof(an_array) / sizeof(an_array[0]); i++) {
        if (an_array[i] != NULL)
            printf("%s = %d\n", an_array[i], i);
    }

    for (int i = 0; i <= A_TABLE2_size; i++) {
        if (an_array2[i] != NULL)
            printf("%s = %d\n", an_array2[i], i);
    }

    // smart enum
    for (int i = 0; i < sizeof(my_enums) / sizeof(my_enums[0]); i++) {
        enum MY_ENUM e = my_enums[i];
        printf("Enum %s = %d\n", MY_ENUM_NAME(e), MY_ENUM_CODE(e));
    }
}
