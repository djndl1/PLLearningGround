#include "config.h"

#include "unistr.h"
#include "utest.h"

#include <uchar.h>


UTEST(UNICODE_TEST, UCS4CharToUTF8Char) {
    uint32_t ucs4_hanzi = U'中';
    uint8_t utf8_hanzi[4] = { 0 };

    int len = u8_uctomb(utf8_hanzi, ucs4_hanzi, 4);

    ASSERT_EQ(3, len);
    ASSERT_EQ(0xE4, utf8_hanzi[0]);
    ASSERT_EQ(0xB8, utf8_hanzi[1]);
    ASSERT_EQ(0xAD, utf8_hanzi[2]);
    ASSERT_EQ(0x00, utf8_hanzi[3]);
}


UTEST_MAIN();
