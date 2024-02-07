#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#include <stc/ccommon.h>

#include "utest.h"

struct _test_resource {
    void *data;
};

typedef struct _test_resource test_resource;

test_resource test_resource_failed_init(size_t size)
{
    test_resource self = { .data = NULL };
    printf("Initting %p\n", self.data);

    return self;
}


test_resource test_resource_init(size_t size)
{
    test_resource self = { .data = NULL };
    self.data = malloc(size);


    assert(NULL != self.data);
    printf("Initting %p\n", self.data);

    return self;
}

void test_resource_drop(test_resource *self)
{
    if (self != NULL) {
        printf("Dropping %p\n", self->data);
        free(self->data);
        self->data = NULL;
    }
}

UTEST(RAII, DEFER)
{
    test_resource resrc = test_resource_init(1);
    c_defer(test_resource_drop(&resrc)) {
        ASSERT_NE(NULL, resrc.data);
    }
    ASSERT_EQ(NULL, resrc.data);
}

UTEST(RAII, DEFER_BREAK)
{
    test_resource resrc2 = test_resource_init(2);
    bool breaking_out = true;
    c_defer(test_resource_drop(&resrc2)) {
        ASSERT_NE(NULL, resrc2.data);
        continue; // break out

        ASSERT_EQ(1, 0);
        breaking_out = false;
    }
    ASSERT_EQ(NULL, resrc2.data);
    ASSERT_TRUE(breaking_out);
}

UTEST(RAII, WITH)
{
    c_with(test_resource resrc = test_resource_init(3),
           test_resource_drop(&resrc)) {
        ASSERT_NE(NULL, resrc.data);
    }
}

UTEST(RAII, WITH_BREAK)
{
    bool breaking = true;
    c_with(test_resource resrc2 = test_resource_init(4),
           test_resource_drop(&resrc2)) {
        ASSERT_NE(NULL, resrc2.data);
        continue; // break out

        ASSERT_EQ(1, 0);
        breaking = false;
    }
    ASSERT_TRUE(breaking);
}

UTEST(RAII, WITH_PREDICATE)
{
    c_with(test_resource resrc2 = test_resource_failed_init(4),
           resrc2.data != NULL,
           test_resource_drop(&resrc2)) {
        ASSERT_EQ(1, 0);
    }
}

UTEST(RAII, SCOPE)
{
    bool entering = false;
    c_scope(entering = true, entering = false) {
        ASSERT_TRUE(entering);
    }
    ASSERT_FALSE(entering);
}

UTEST(RAII, SCOPE_BREAK)
{
    bool entering = false;
    c_scope(entering = true, entering = false) {
        ASSERT_TRUE(entering);

        continue;

        ASSERT_EQ(0, 1);
    }
    ASSERT_FALSE(entering);
}

UTEST(RAII, SCOPE_PRED)
{
    bool entering = false;
    bool should_enter = false;
    c_scope(entering = (should_enter ? true : false), entering, entering = false) {
        ASSERT_EQ(0, 1);
    }
    ASSERT_FALSE(entering);
}

UTEST_MAIN();
