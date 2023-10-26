#include "config.h"

#include <time.h>
#include "utest.h"

#if defined(__MINGW32__) || defined (_MSC_VER)
    #define localtime_s(a, b) (localtime_s(b, a))
    #define gmtime_s(a, b) (gmtime_s(b, a))
#elif defined(__STDC_LIB_EXT1__)
    #define __STDC_WANT_LIB_EXT1__ 1
#else
    #define localtime_s(a, b) (localtime_r(a, b))
    #define gmtime_s(a, b) (gmtime_r(a, b))
#endif


UTEST(DATETIME, NOW_SECONDS) {
    time_t now = time(nullptr);

    struct tm broken_down = { 0 };
    gmtime_s(&now, &broken_down);
    printf("Current unix time: %lld seconds since Epoch, that is %s.\n", now, asctime(&broken_down));
}

UTEST(DATETIME, NOW_NANOSECOND) {
    struct timespec now = { 0 };

    timespec_get(&now, TIME_UTC);

    struct tm broken_down = { 0 };
    gmtime_s(&now.tv_sec, &broken_down);
    printf("Current Unix time: %lf seconds since Epoch, that is %s\n",
           now.tv_sec + now.tv_nsec / 1e9,
           asctime(&broken_down));
}

UTEST(DATETIME, LOCAL_NOW) {
    {
        time_t now = time(nullptr);

        struct tm local_now = { 0 };
        localtime_s(&now, &local_now); // C23

        char iso[30] = { '\0' };
        strftime(iso, 30, "%Y-%m-%dT%H:%M:%S", &local_now);
        printf("Current Local time: %s.\n", iso);

        time_t now2 = mktime(&local_now);

        ASSERT_EQ(now, now2);
    }

    {
        struct timespec now_nano = { 0 };
        timespec_get(&now_nano, TIME_UTC);

        struct tm local_now_nano = { 0 };
        localtime_s(&now_nano.tv_sec, &local_now_nano); // C23

        char iso_nano[32] = { '\0' };
        strftime(iso_nano, 32, "%Y-%m-%dT%H:%M:%S", &local_now_nano);

        char iso_nano_string[32] = { '\0' };
        snprintf(iso_nano_string, 32, "%s.%9ld", iso_nano, now_nano.tv_nsec);

        printf("Current Local time: %s.\n", iso_nano_string);

        time_t now2 = mktime(&local_now_nano);
        ASSERT_EQ(now_nano.tv_sec, now2);
    }
}

UTEST_MAIN();
