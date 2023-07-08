#include <windows.h>
#include <time.h>
#include <wchar.h>
#include <stdlib.h>
#include <stdio.h>

#define BUFFER_LEN 2048

/**
 * Compose a logger name
 */
wchar_t *compose_log_name()
{

    time_t current_timestamp = time(NULL);
    struct tm *local_time = localtime(&current_timestamp);

    char* logname = malloc(BUFFER_LEN);
    size_t len = strftime(logname,
                          BUFFER_LEN,
                          "C2_%Y-%m-%dT%H-%M-%S.txt",
                          local_time);
    if (len == 0) {
        goto time_string_error;
    }

    wchar_t *logwname = malloc(2 * BUFFER_LEN);
    size_t wlen = mbstowcs(logwname, logname, 2 * BUFFER_LEN);
    if (wlen == -1) {
        goto conversion_error;
    }

    return logwname;

conversion_error:
    free(logwname);
time_string_error:
    free(logname);

    return L"C2.txt";
}

int main(void)
{
    LPWSTR commandline_str = GetCommandLineW();
    int argc = 0;
    LPWSTR *argv = CommandLineToArgvW(commandline_str, &argc);
    FILE *output_stream;
    wchar_t c2argv[BUFFER_LEN] = L"";

    wchar_t *logfile = compose_log_name();
    if ((output_stream = _wfopen(logfile, L"a")) != NULL) {
        for (int idx = 1; idx < argc; idx++) {


            wcscat(c2argv, L" ");
            wcscat(c2argv, argv[idx]);
        }
        fwprintf(output_stream, L"C2.EXE %ls", c2argv);
        fclose(output_stream);

        wprintf(L"%ls\n", c2argv);
        fflush(stdout);

        PROCESS_INFORMATION new_proc;
        STARTUPINFO info = {
            .cb = sizeof(STARTUPINFO),
            .lpReserved = NULL,
        };

        BOOL result = CreateProcessW(L"C:/Program Files/Microsoft Visual Studio/VB98/C3.EXE",
                                     c2argv,
                                     NULL, NULL,
                                     FALSE, 0,
                                     NULL, NULL,
                                     &info, &new_proc);

        if (!result) {
            wprintf(L"Failed to start C3.EXE %ls\n", c2argv);
        }
    }

    return 0;
}