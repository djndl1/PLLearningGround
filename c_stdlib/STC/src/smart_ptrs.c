#include <stdbool.h>
#include <stdlib.h>
#include <assert.h>

#include "utest.h"

struct _test_resource {
    void *data;
    size_t len;
};

typedef struct _test_resource test_resource;

test_resource test_resource_failed_init(size_t size)
{
    test_resource self = { .data = NULL, .len = size };
    printf("Initting %p\n", self.data);

    return self;
}

test_resource test_resource_init(size_t size)
{
    test_resource self = { .data = NULL, .len = size };
    self.data = malloc(size);

    assert(NULL != self.data);
    printf("Initting %p\n", self.data);

    return self;
}

test_resource test_resource_clone(test_resource self)
{
    return test_resource_init(self.len);
}

void test_resource_drop(test_resource *self)
{
    if (self != NULL) {
        printf("Dropping %p\n", self->data);
        free(self->data);
        self->data = NULL;
    }
}

#define i_valclass test_resource
#define i_no_cmp
#define i_no_hash
#include <stc/cbox.h>

/**
 * Not really a unique pointer as you cannot stop it from being assigned by value,
 * just a box, a wrapper around some raw pointer with some utilities.
 * so that related resources may be dropped if boxed and put inside a container.
 * It's more like a handle on the stack that hides its pointer facade.
 **/
UTEST(BOX, NOT_UNIQUE)
{
    cbox_test_resource boxed_resrc = cbox_test_resource_make(test_resource_init(10));

    // no problem with assignment
    cbox_test_resource boxed_resrc_assigned = boxed_resrc;

    // this is not unique at all
    ASSERT_EQ(boxed_resrc.get, boxed_resrc_assigned.get);

    cbox_test_resource_drop(&boxed_resrc);
    ASSERT_NE(NULL, boxed_resrc_assigned.get);
}

UTEST(BOX, BOX_MOVE)
{
    cbox_test_resource boxed_resrc = cbox_test_resource_make(test_resource_init(10));

    cbox_test_resource move_target = cbox_test_resource_move(&boxed_resrc);
    ASSERT_EQ(NULL, boxed_resrc.get);
    ASSERT_NE(NULL, move_target.get);

    cbox_test_resource_drop(&move_target);
}


#define i_val test_resource
#define i_valdrop test_resource_drop
#define i_no_cmp
#define i_no_clone
#define i_no_hash
#include <stc/carc.h>

/**
 * Still this one cannot stop assignment
 * A refcount wrapper
 **/
UTEST(RCBOX, REFCOUNT)
{
    carc_test_resource rc1 = carc_test_resource_make(test_resource_init(10));
    ASSERT_EQ(1, *rc1.use_count);
    carc_test_resource rc2 = carc_test_resource_clone(rc1);
    ASSERT_EQ(2, *rc1.use_count);
    ASSERT_EQ(2, *rc2.use_count);

    carc_test_resource_drop(&rc1);
    ASSERT_EQ(1, *rc2.use_count);
    carc_test_resource_drop(&rc2);
}


UTEST_MAIN();
