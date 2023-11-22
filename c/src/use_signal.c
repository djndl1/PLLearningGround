#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <signal.h>

#if defined(__MINGW64__) || defined(__MINGW32__) || defined (_MSC_VER)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
    #define millisleep(s) (Sleep)(s)
#else
#include <unistd.h>
#define millisleep(s) (usleep)(s * 1000)
#endif

static sig_atomic_t interrupted_times = 0;

static void report_interruption(int sig)
{
    interrupted_times++;
}

int main()
{
    if (signal(SIGINT, report_interruption) == SIG_ERR) {
        perror("Signal installment failed.");

        return EXIT_FAILURE;
    }

    while (interrupted_times < 10) {
        millisleep(1000);

        printf("Interrupted: the %d-th time\n", interrupted_times);
    }
}
