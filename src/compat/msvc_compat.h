/* From justjavac/libquickjs compat/msvc_compat.h (MIT license).
 * Force-included on MSVC through quickjs_build.h.
 */
#ifndef LIBQUICKJS_MSVC_COMPAT_H
#define LIBQUICKJS_MSVC_COMPAT_H

#if defined(_MSC_VER)

#include <intrin.h>
#include <stdint.h>

#ifndef __attribute__
#define __attribute__(x)
#endif

#ifndef __builtin_expect
#define __builtin_expect(x, expected) (x)
#endif

#ifndef __builtin_frame_address
#define __builtin_frame_address(level) _AddressOfReturnAddress()
#endif

static __forceinline int libquickjs_builtin_clz(unsigned int value) {
  unsigned long index;
  _BitScanReverse(&index, value);
  return 31 - (int)index;
}

static __forceinline int libquickjs_builtin_clzll(uint64_t value) {
  unsigned long index;
#if defined(_M_X64) || defined(_M_ARM64)
  _BitScanReverse64(&index, value);
  return 63 - (int)index;
#else
  if (value >> 32) {
    _BitScanReverse(&index, (unsigned long)(value >> 32));
    return 31 - (int)index;
  }
  _BitScanReverse(&index, (unsigned long)value);
  return 63 - (int)index;
#endif
}

static __forceinline int libquickjs_builtin_ctz(unsigned int value) {
  unsigned long index;
  _BitScanForward(&index, value);
  return (int)index;
}

static __forceinline int libquickjs_builtin_ctzll(uint64_t value) {
  unsigned long index;
#if defined(_M_X64) || defined(_M_ARM64)
  _BitScanForward64(&index, value);
  return (int)index;
#else
  if ((uint32_t)value != 0) {
    _BitScanForward(&index, (unsigned long)value);
    return (int)index;
  }
  _BitScanForward(&index, (unsigned long)(value >> 32));
  return 32 + (int)index;
#endif
}

#define __builtin_clz(value) libquickjs_builtin_clz(value)
#define __builtin_clzll(value) libquickjs_builtin_clzll(value)
#define __builtin_ctz(value) libquickjs_builtin_ctz(value)
#define __builtin_ctzll(value) libquickjs_builtin_ctzll(value)

#endif

#endif
