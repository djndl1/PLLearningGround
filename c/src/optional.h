#ifndef MAYBE_OPTIONAL_H
#define MAYBE_OPTIONAL_H

#include <stdbool.h>

#define TOKENIZE(t) #t

#define _CONCAT(a, b) a##b

#define CONCAT(a, b) _CONCAT(a, b)

#define scoped_stmt(...) do { __VA_ARGS__; } while (false)

#define empty_expr scoped_stmt((void)0)

#define optional(typ) CONCAT(CONCAT(optional_, typ), _t)

#define OPTIONAL_INLINE __attribute__ ((always_inline))

#define optional_present(opt) (opt._present)
#define optional_empty(opt) (!opt._present)
#define optional_or_else(opt, alt) (opt._present ? _optional_val(opt) : alt)

#define optional_some(T) CONCAT(optional(T), _some)
#define optional_filter(T) CONCAT(optional(T), _filter)
#define optional_none(T) ((optional(T)){ ._present = false })
#define optional_element_predicate(T) CONCAT(optional(T), _element_predicate_t)

#define match_begin(typ, match_obj)  {                              \
    typ __ca3ecda3_7219_428c_8ea3_cebaff20be9b = match_obj; \

#define on_some_begin(typ, val) {                                          \
    typ val = _optional_val(__ca3ecda3_7219_428c_8ea3_cebaff20be9b);           \
    if (optional_present(__ca3ecda3_7219_428c_8ea3_cebaff20be9b))

#define on_some_end }

#define on_none_begin {                                    \
    if (!optional_present(__ca3ecda3_7219_428c_8ea3_cebaff20be9b))
#define on_none_end }
#define match_end }

#define _optional_val(opt) (opt._hidden_obj.t_value)

#endif // MAYBE_OPTIONAL_H

#ifdef optional_element_t

struct optional(optional_element_t);

/**
 * The implementation should never be included in a header.
 * Doing so might causes duplicated definitions.
 * You have been warned.
 */
#ifdef OPTIONAL_IMPLEMENTATION
#undef OPTIONAL_IMPLEMENTATION

typedef struct optional(optional_element_t) {
    bool _present;
    struct {
        optional_element_t t_value;
    } _hidden_obj;
} optional(optional_element_t);

OPTIONAL_INLINE
static inline optional(optional_element_t) optional_some(optional_element_t)(optional_element_t val)
{
    return ((optional(optional_element_t)){ ._present = true, ._hidden_obj.t_value = val, });
}

#define optional_map_to(U, opt, mapping) (optional_present(opt) ?           \
                                       optional_some(U)(mapping(_optional_val(opt))) \
                                       : optional_none(U))

typedef bool (*optional_element_predicate(optional_element_t))(optional_element_t);

OPTIONAL_INLINE
static inline optional(optional_element_t) optional_filter(optional_element_t)(
    optional(optional_element_t) opt,
    optional_element_predicate(optional_element_t) pred)
{
    return optional_present(opt)
        ? (pred(_optional_val(opt)) ? opt : optional_none(optional_element_t))
        : optional_none(optional_element_t);
}

#endif // OPTIONAL_IMPLEMENTATION

#endif // optional_element_t
#undef optional_element_t
