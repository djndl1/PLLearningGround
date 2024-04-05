dnl Enum is defined by a macro with its first argument appending to each row
dnl define(`TABLE',
dnl `
dnl $1(Enum_Symbol, [Enum_Custom_value], ...)
dnl ')
dnl

define(`SMART_ENUM_FULL_NAME', `$1`'_`'$2')

dnl generate an enum type with custom values
dnl @table: table macro name
dnl @enum_tag: enum type name
define(`SMART_ENUM_DEF_ENUM_CUSTOM_VAL',
`
  define($2`'`SMART_ENUM_EXPAND_AS_ENUM_DEF', SMART_ENUM_FULL_NAME($2, $`'1) = $`'2`,')

// `Define $2 as an enum with custom values'
typedef enum $2 {
    $1($2`'`SMART_ENUM_EXPAND_AS_ENUM_DEF')
} $2;

  define($2`'_`SMART_ENUM_EXPAND_AS_ARRAY_ELM', SMART_ENUM_FULL_NAME($2, $`'1)`,')dnl

const $2 $2`'_enum_values[] = {
    $1($2`'_`SMART_ENUM_EXPAND_AS_ARRAY_ELM')
};
')dnl

dnl generate an enum type with default values
dnl @table: table macro name
dnl @enum_tag: enum type name
define(`SMART_ENUM_DEF_ENUM_DEFAULT_VAL',
`
    define($2`'`SMART_ENUM_EXPAND_AS_ENUM_DEFAULT_DEF', SMART_ENUM_FULL_NAME($2, $`'1)`,')

// `Define $2 as an enum with default values'
typedef enum $2 {
    $1($2`'`SMART_ENUM_EXPAND_AS_ENUM_DEFAULT_DEF')
} $2;

  define($2`'_`SMART_ENUM_EXPAND_AS_ARRAY_ELM', SMART_ENUM_FULL_NAME($2, $`'1)`,')dnl

const $2 $2`'_enum_values[] = {
    $1($2`'_`SMART_ENUM_EXPAND_AS_ARRAY_ELM')
};
')dnl

dnl define metadata instances of the enum type
dnl @table table macro name
dnl @enum_type enum type name
dnl @instance_type metadata instance type name
dnl @init_expr metadata instance initializer expression
define(`SMART_ENUM_DEF_INSTANCES',
`
    define($2`'_`'`SMART_ENUM_INSTANCE_NAME',
            SMART_ENUM_FULL_NAME(`$2', $`'1)`'_instance)dnl

    define($2`'_`'`SMART_ENUM_EXPAND_AS_INSTANCE',
            SMART_ENUM_FULL_NAME(`$2', $`'1)`'_instance`,')dnl

    define($2`'_`'`SMART_ENUM_EXPAND_AS_INSTANCE_DEF',
        `const' `$3' $2`'_`'SMART_ENUM_INSTANCE_NAME($`'1) = `$4'($`'1, $`'2);)dnl

$1($2`'_`'`SMART_ENUM_EXPAND_AS_INSTANCE_DEF')

const `$3' `$2'_`instances[]' = {
      $1($2`'_`'`SMART_ENUM_EXPAND_AS_INSTANCE')
};
')dnl

dnl define a mapping from enum value to its medata instance
dnl @table table macro name
dnl @enum_type enum type name
dnl @instance_type metadata instance type name
dnl @default_val default metadata instance value for non-existent enum value
define(`SMART_ENUM_DEF_GET_INSTANCE_FUNC',
`
define(`SMART_ENUM_EXPAND_AS_CASE',
        case SMART_ENUM_FULL_NAME($2, $`'1):
            return `$2'_'`SMART_ENUM_INSTANCE_NAME($`'1);)dnl
static inline `$3' `$2'`'_get_instance(`$2' e)
{
    switch (e)
    {
        $1(`SMART_ENUM_EXPAND_AS_CASE')
        default: return `$4';
    }
};')
