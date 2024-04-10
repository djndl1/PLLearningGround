include(smart_enum.m4)

define(`ENUM_TABLE',
`
$1(A, 1)
$1(B, 2)
$1(C, 3)
')dnl

typedef struct instance_type {
        int a; int b;
} instance_type;

define(`test_enum_init', `(instance_type){ .a = 10, .b = $2 }')

SMART_ENUM_DEF_ENUM_CUSTOM_VAL(`ENUM_TABLE', `test_enum')
SMART_ENUM_GEN_ENUM_ARRAY(`ENUM_TABLE', `test_enum')
SMART_ENUM_DEF_INSTANCES(`ENUM_TABLE', `test_enum', `instance_type', `test_enum_init')
SMART_ENUM_DEF_GET_INSTANCE_FUNC(`ENUM_TABLE', `test_enum', `instance_type', `(instance_type){ 0  }')
