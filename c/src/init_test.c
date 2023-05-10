#include "config.h"
#include "utest.h"

#include "unistr.h"

UTEST(UTF_TEST, UTF8UTF16) {
    const char *utf8str = "中文";

    uint16_t utf16str[6] = { 0 };
    size_t utf16length = 6;
    u8_to_u16(utf8str, strlen(utf8str), utf16str, &utf16length);

    for (size_t i = 0; i < 6; i++) {
        printf("%X ", utf16str[i]);
    }
    putchar('\n');
}

UTEST_MAIN();
