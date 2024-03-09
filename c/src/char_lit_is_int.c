#include <assert.h>
#include <uchar.h>
#include <wchar.h>

int main()
{
#ifdef __cplusplus // C++
    static_assert(sizeof('c') == sizeof(char));
    static_assert(sizeof('c') != sizeof(int));
#else // Pure C
    static_assert(sizeof('c') != sizeof(char), "character literals should be of integers in C");
    static_assert(sizeof('c') == sizeof(int), "character literals should be of integers in C");
#endif
    static_assert(sizeof(L'c') == sizeof(wchar_t), "Wide character literals should be of wide chars");
    static_assert(sizeof(u'c') == sizeof(char16_t), "Wide character literals should be of wide chars");
    static_assert(sizeof(U'c') == sizeof(char32_t), "Wide character literals should be of wide chars");

    return 0;
}
