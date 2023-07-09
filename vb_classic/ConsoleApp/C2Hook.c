#include <windows.h>
#include <time.h>
#include <wchar.h>
#include <stdlib.h>
#include <stdio.h>

#define BUFFER_LEN 4096

#define REAL_C2_PATH L"C:/Program Files/Microsoft Visual Studio/VB98/C3.EXE"
#define REAL_LINK_PATH L"C:/Program Files/Microsoft Visual Studio/VB98/LINK2.EXE"

/**
 * Compose a logger name
 */
wchar_t *compose_log_name()
{

    time_t current_timestamp = time(NULL);
    struct tm *local_time = localtime(&current_timestamp);

    wchar_t *logwname = malloc(sizeof(wchar_t) * BUFFER_LEN);
    size_t len = wcsftime(logwname,
                          BUFFER_LEN,
                          L"HOOK_%Y-%m-%dT%H-%M-%S.txt",
                          local_time);
    if (len == 0) {
        goto time_string_error;
    }

    return logwname;

time_string_error:
    free(logwname);

    return L"HOOK.txt";
}

int wmain(int argc, wchar_t *argv[])
{
    FILE *output_stream;
    wchar_t c2argv[BUFFER_LEN] = L"";

    wchar_t *logfile = compose_log_name();
    if ((output_stream = _wfopen(logfile, L"a")) != NULL) {
        for (int idx = 1; idx < argc; idx++) {
            wcscat(c2argv, L" ");
            wcscat(c2argv, argv[idx]);
        }
        fwprintf(output_stream, L"%ls %ls\n", argv[0], c2argv);
        fclose(output_stream);

        wprintf(L"%ls %ls\n", argv[0], c2argv);
        fflush(stdout);

        wchar_t *proc_path;
        if (wcsstr(argv[0], L"C2") != NULL) {
            proc_path = REAL_C2_PATH;
        } else if (wcsstr(argv[0], L"LINK") != NULL) {
            proc_path = REAL_LINK_PATH;
        } else {
            wprintf(L"Failed to start %ls %ls\n", argv[0], c2argv);
            return -1;
        }
        wprintf(L"%ls %ls\n", proc_path, c2argv);

        PROCESS_INFORMATION new_proc;
        STARTUPINFO info = {
            .cb = sizeof(STARTUPINFO),
            .lpReserved = NULL,
        };

        BOOL result = CreateProcessW(proc_path,
                                     c2argv,
                                     NULL, NULL,
                                     FALSE, 0,
                                     NULL, NULL,
                                     &info, &new_proc);

        if (!result) {
            wprintf(L"Failed to start %ls %ls\n", argv[0], c2argv);
        }
    }

    return 0;
}