/* Cross-platform shim for <sys/time.h>, from justjavac/libquickjs
 * compat/sys/time.h (MIT license), extended with a Unix passthrough.
 */
#ifndef LIBQUICKJS_COMPAT_SYS_TIME_H
#define LIBQUICKJS_COMPAT_SYS_TIME_H

#if defined(_WIN32)

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif

#include <stdint.h>
#include <winsock2.h>
#include <windows.h>

static inline int gettimeofday(struct timeval *tv, void *tz) {
  FILETIME file_time;
  ULARGE_INTEGER ticks;
  const uint64_t windows_to_unix_epoch = 116444736000000000ULL;
  uint64_t unix_time_100ns;

  if (!tv) {
    return -1;
  }

  (void)tz;

  GetSystemTimeAsFileTime(&file_time);
  ticks.LowPart = file_time.dwLowDateTime;
  ticks.HighPart = file_time.dwHighDateTime;

  unix_time_100ns = ticks.QuadPart - windows_to_unix_epoch;
  tv->tv_sec = (long)(unix_time_100ns / 10000000ULL);
  tv->tv_usec = (long)((unix_time_100ns % 10000000ULL) / 10ULL);
  return 0;
}

#else

#include <sys/time.h>

#endif

#endif
