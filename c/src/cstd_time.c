#include "config.h"

#include <time.h>
#include "utest.h"

UTEST(DATETIME, NOW_SECONDS) {
    time_t now = time(nullptr);

    printf("Current unix time: %ld seconds since Epoch.\n", now);
}

UTEST(DATETIME, NOW_NANOSECOND) {
    struct timespec now = { 0 };

    timespec_get(&now, TIME_UTC);

    printf("Current Unix time: %lf seconds since Epoch\n",
           now.tv_sec + now.tv_nsec / 1e9);
}

UTEST(DATETIME, LOCAL_NOW) {
    {
        time_t now = time(nullptr);

        struct tm local_now = { 0 };
        localtime_r(&now, &local_now); // C23

        char iso[30] = { '\0' };
        strftime(iso, 30, "%Y-%m-%dT%H:%M:%S", &local_now);
        printf("Current Local time: %s.\n", iso);
    }

    {
        struct timespec now_nano = { 0 };
        timespec_get(&now_nano, TIME_UTC);

        struct tm local_now_nano = { 0 };
        localtime_r(&now_nano.tv_sec, &local_now_nano); // C23

        char iso_nano[32] = { '\0' };
        strftime(iso_nano, 32, "%Y-%m-%dT%H:%M:%S", &local_now_nano);

        char iso_nano_string[32] = { '\0' };
        snprintf(iso_nano_string, 32, "%s.%9ld", iso_nano, now_nano.tv_nsec);

        printf("Current Local time: %s.\n", iso_nano_string);
    }

}

UTEST_MAIN();
