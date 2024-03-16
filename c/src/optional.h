#ifndef OPTIONAL_H_
#define OPTIONAL_H_

#define TOKENIZE(t) #t
#define _CONCAT(a, b) a##b
#define CONCAT(a, b) _CONCAT(a, b)

#define scoped_stmt(...) do { __VA_ARGS__; } while (0)
#define empty_expr scoped_stmt((void)0)

#define optional(typ) CONCAT(CONCAT(optional_, typ), _t)

#define def_optional(typ) typedef struct optional(typ) {   \
        unsigned char _present;                                         \
        struct {                                                        \
            typ t_value;                                                \
        } _hidden_obj;                                                  \
    } optional(typ)

#define _optional_val(opt) (opt._hidden_obj.t_value)

#define optional_some(typ, val) ((optional(typ)){ ._present = 1, ._hidden_obj.t_value = val, })
#define optional_none(typ) ((optional(typ)){ ._present = 0 })

#define optional_present(opt) (opt._present)
#define optional_empty(opt) (!opt._present)
#define optional_or_else(opt, alt) (opt._present ? _optional_val(opt) : alt)

#define optional_map(D, opt, mapping) (opt._present ?                \
                                          optional_some(D, mapping(_optional_val(opt))) \
                                          : optional_none(D))
#define optional_filter(T, opt, pred) ((opt._present) ? \
                                         (pred(_optional_val(opt)) ? opt : optional_none(T)) \
                                       : optional_none(T))

#define optional_match(typ, opt, val_var, matched_stmt, empty_stmt) do { \
        if (optional_present(opt)) {                                    \
            typ val_var = _optional_val(opt);                           \
            scoped_stmt(matched_stmt);                                  \
        } else {                                                        \
            empty_stmt;                                                \
                }                                                      \
    } while (0)

#endif // OPTIONAL_H_
