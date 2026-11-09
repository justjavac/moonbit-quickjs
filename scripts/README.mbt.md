# scripts

Maintenance scripts for this repository.

## vendor_quickjs.py

Regenerates the vendored QuickJS C sources under `src/` from an upstream
QuickJS checkout. The package compiles these sources as `native-stub` files, so
this script replaces the old workflow that downloaded prebuilt `quickjs.lib` /
`libquickjs.a` artifacts from GitHub Actions.

What it writes:

- `src/{quickjs,cutils,dtoa,libregexp,libunicode}.c` (patched, with
  `#include "quickjs_build.h"` injected)
- the private headers they include (`cutils.h`, `libunicode-table.h`,
  `quickjs-opcode.h`, ...)
- `src/quickjs_build.h`, `src/compat/msvc_compat.h`, `src/compat/sys/time.h`

It deliberately does **not** overwrite `src/quickjs.h` — that is the exported
header, already carrying its MSVC fix. The script verifies the fix is present.

Usage:

```text
git clone https://github.com/bellard/quickjs.git target/quickjs-src
git -C target/quickjs-src checkout d7ae12ae71dfd6ab2997527d295014a8996fa0f9
python scripts/vendor_quickjs.py --source target/quickjs-src
python scripts/vendor_quickjs.py --check --source target/quickjs-src
moon test --target native
```

Notes:

- `--source` defaults to `target/quickjs-src` (gitignored).
- The pinned upstream revision is recorded as `UPSTREAM_TAG` in the script.
- Every source transformation is applied identically on all platforms; the
  script aborts if a patch no longer matches upstream.
- Requirements: Python 3 and a local QuickJS checkout. No `gh`, no Node.js, no
  CMake, and no `-fPIC` juggling — the C sources are compiled by `moon` itself
  with the same flags as the rest of the native build.
