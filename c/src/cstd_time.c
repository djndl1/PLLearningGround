#include "config.h"
#include <time.h>

#if defined(__MINGW64__) || defined(__MINGW32__) || defined (_MSC_VER)
#include <windows.h>

    #define localtime_s(a, b) (localtime_s(b, a))
    #define gmtime_s(a, b) (gmtime_s(b, a))
    #define sleep(s) (Sleep)(s * 1000)
#elif defined(__STDC_LIB_EXT1__)
    #define __STDC_WANT_LIB_EXT1__ 1
#else
#define _XOPEN_SOURCE 700
#include <unistd.h>

    #define localtime_s(a, b) (localtime_r(a, b))
    #define gmtime_s(a, b) (gmtime_r(a, b))
#endif

#ifdef __ANDROID__
    #define timespec_get(ts, base) clock_gettime(CLOCK_REALTIME, ts)
#endif

#include "utest.h"

#define ISO_DATE_TIME_FORMAT "%Y-%m-%dT%H:%M:%S"


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
#ifdef _DEFAULT_SOURCE
    printf("Curent timezone: %s, %ld seconds from UTC\n",
           broken_down.tm_zone, broken_down.tm_gmtoff);
#endif
}

UTEST(DATETIME, LOCAL_NOW) {
    {
        time_t now = time(nullptr);

        struct tm local_now = { 0 };
        localtime_s(&now, &local_now); // C23

#ifdef _DEFAULT_SOURCE
    printf("Curent timezone: %s, %ld seconds from UTC\n",
          local_now.tm_zone, local_now.tm_gmtoff);
#endif

        char iso[30] = { '\0' };
        strftime(iso, 30, ISO_DATE_TIME_FORMAT, &local_now);
        printf("Current Local time: %s.\n", iso);

        time_t now2 = mktime(&local_now);

        ASSERT_EQ(now, now2);

#ifdef _XOPEN_SOURCE
        struct tm restored_now = { 0 };
        strptime(iso, ISO_DATE_TIME_FORMAT, &restored_now);

        ASSERT_TRUE(local_now.tm_year == restored_now.tm_year
                    && local_now.tm_mon == restored_now.tm_mon
                    && local_now.tm_mday == restored_now.tm_mday
                    && local_now.tm_hour == restored_now.tm_hour
                    && local_now.tm_min == restored_now.tm_min
                    && local_now.tm_sec == restored_now.tm_sec);
#endif
    }

    {
        struct timespec now_nano = { 0 };
        timespec_get(&now_nano, TIME_UTC);

        struct tm local_now_nano = { 0 };
        localtime_s(&now_nano.tv_sec, &local_now_nano); // C23

#ifdef _DEFAULT_SOURCE
    printf("Curent timezone: %s, %ld seconds from UTC\n",
          local_now_nano.tm_zone, local_now_nano.tm_gmtoff);
#endif

        char iso_nano[32] = { '\0' };
        strftime(iso_nano, 32, "%Y-%m-%dT%H:%M:%S", &local_now_nano);

        char iso_nano_string[32] = { '\0' };
        snprintf(iso_nano_string, 32, "%s.%9ld", iso_nano, now_nano.tv_nsec);

        printf("Current Local time: %s.\n", iso_nano_string);

        time_t now2 = mktime(&local_now_nano);
        ASSERT_EQ(now_nano.tv_sec, now2);

#ifdef _XOPEN_SOURCE
        struct tm restored_now = { 0 };
        strptime(iso_nano_string, ISO_DATE_TIME_FORMAT, &restored_now);

        ASSERT_TRUE(local_now_nano.tm_year == restored_now.tm_year
                    && local_now_nano.tm_mon == restored_now.tm_mon
                    && local_now_nano.tm_mday == restored_now.tm_mday
                    && local_now_nano.tm_hour == restored_now.tm_hour
                    && local_now_nano.tm_min == restored_now.tm_min
                    && local_now_nano.tm_sec == restored_now.tm_sec);
#endif
    }
}

UTEST(PROCESSOR, CLOCK) {
    clock_t start_clock = clock();
    sleep(1);
    clock_t stop_clock = clock();

    double elapsed_processor_time = (stop_clock - start_clock) / CLOCKS_PER_SEC;

    printf("Processor time elapsed: %lf\n", elapsed_processor_time);
}

#if defined(_POSIX_C_SOURCE) || defined(__MINGW32__) || defined (_MINGW64__)
#if defined(__MINGW32__) || defined (_MINGW64__)
#include <pthread_time.h>
#endif

UTEST(DATETIME, POSIX_REALTIME_CLOCK) {
    struct timespec now = { 0 };
    int status = clock_gettime(CLOCK_REALTIME, &now);

    ASSERT_EQ(0, status);
    struct timespec res = { 0 };
    int res_status = clock_getres(CLOCK_REALTIME, &res);
    ASSERT_EQ(0, res_status);

    printf("REALTIME_CLOCK: "
           "Current unix time: %"PRId64".%09"PRId64" seconds since Epoch with a resolution of %lf nanosecond\n",
           (int64_t)now.tv_sec,
           (int64_t)now.tv_nsec,
           res.tv_sec * 1e9 + res.tv_nsec);
}

#endif

#ifdef _POSIX_C_SOURCE
#include <sys/timex.h>
UTEST(DATETIME, NTP_GET_TIME) {
    struct ntptimeval ntp_time = { 0 };

    int status = ntp_gettime(&ntp_time);

    printf("NTP API time: %ld.%06ld seconds, "
           "max error %ld microseconds, estimated error %ld\n",
           ntp_time.time.tv_sec, ntp_time.time.tv_usec,
           ntp_time.maxerror, ntp_time.esterror);
}

#endif

#if defined(__MINGW64__) || defined(__MINGW32__) || defined (_MSC_VER)
#include <sys/types.h>
#include <sys/timeb.h>

UTEST(DATETIME, FTIME) {
    struct _timeb tb = { 0 };
    errno_t err = _ftime_s(&tb);
    ASSERT_EQ(0, err);

    printf("FTIME: "
           "Current unix time: %"PRId64".%03"PRId64" seconds since Epoch, offset from UTC %"PRId64"  minute(s).\n",
           (int64_t)tb.time,
           (int64_t)tb.millitm,
           (int64_t)tb.timezone);

}

#endif

UTEST_MAIN();
