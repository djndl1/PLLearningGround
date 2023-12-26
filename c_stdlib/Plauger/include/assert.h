#undef assert

#ifdef NDEBUG
#define assert(test) ((void)0)
#else

void _Assert(char*);

#define _STR(x) _VAL(x)
#define _VAL(x) #x

#define assert(test)    ((test) ? (void)0                               \
                         : _assert_impl(#test, __FILE__, __func__, _STR(__LINE__)))

#endif // NDEBUG
