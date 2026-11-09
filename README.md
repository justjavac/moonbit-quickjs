# moonbit-quickjs

[![coverage](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?label=coverage)](https://codecov.io/gh/justjavac/moonbit-quickjs)
[![linux](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?flag=linux&label=linux)](https://codecov.io/gh/justjavac/moonbit-quickjs)
[![macos](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?flag=macos&label=macos)](https://codecov.io/gh/justjavac/moonbit-quickjs)
[![windows](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?flag=windows&label=windows)](https://codecov.io/gh/justjavac/moonbit-quickjs)

MoonBit bindings for the [QuickJS](https://bellard.org/quickjs/) JavaScript engine.

This package provides a small high-level MoonBit API over QuickJS runtimes,
contexts, and values. The QuickJS engine is vendored as C source and compiled
by MoonBit's native backend on every build — there are no prebuilt `.lib` / `.a`
files, no Node.js prebuild script, and nothing to install before `moon add`.

## Features

- Native-only MoonBit package built on top of a small FFI surface
- QuickJS compiled from vendored C sources as `native-stub` files on Windows,
  Linux, and macOS
- Explicit lifecycle management for runtimes, contexts, and values
- Routines for evaluation, JSON parsing, property access, and Promise jobs

## Supported Targets and Platforms

The package is configured with:

- `preferred-target: native`
- `supported_targets: +native`

The vendored C sources compile with whatever C compiler MoonBit uses for the
native backend, so the CRT and ABI always match the final executable:

- `windows-x64` — MSVC `cl.exe` (static CRT, no separate runtime to install)
- `linux-x64` — `gcc` / `clang`
- `macos` — `clang`

Only the engine core is built (`quickjs.c`, `cutils.c`, `dtoa.c`,
`libregexp.c`, `libunicode.c`); `quickjs-libc.c` and the `qjs` CLI are excluded.
The bindings use `JS_NewRuntime` / `JS_NewContext` directly, so no libc
helpers are needed. Atomics are disabled on Windows (no pthread dependency),
matching the previous prebuilt library.

## Install

Add the package to your MoonBit module:

```bssh
moon add justjavac/quickjs
```

## Quick Start

```moonbit
let runtime = @quickjs.Runtime::new()
let context = runtime.new_context()

let result = context.eval("1 + 2")
guard !result.is_exception() else {
  let message = context.exception_message()
  result.destroy()
  fail(message)
}

inspect(result.to_int32(context), content="3")

result.destroy()
context.destroy()
runtime.destroy()
```

## Lifecycle Model

The public API intentionally exposes three core handles:

- `Runtime`: owns QuickJS allocator state and the pending job queue
- `Context`: owns an execution scope and exception state
- `Value`: wraps a JavaScript value

Typical usage follows this sequence:

1. Create a `Runtime`
2. Create a `Context` from that runtime
3. Evaluate code or construct values through the context
4. Convert, inspect, or traverse returned `Value` handles
5. Destroy every `Value`, then destroy the `Context`, then destroy the `Runtime`

## Common Operations

### Evaluate JavaScript

```moonbit
let value = context.eval("40 + 2")
guard !value.is_exception() else {
  let message = context.exception_message()
  value.destroy()
  fail(message)
}
inspect(value.to_int32(context), content="42")
value.destroy()
```

### Work with objects and arrays

```moonbit
let object = context.new_object()
let items = context.new_array()
let name = context.new_string("moonbit")

ignore(items.set_index(context, 0, name))
ignore(object.set_property(context, "items", items))

let stringified = context.json_stringify(object)
println(stringified.to_string_lossy(context))

stringified.destroy()
name.destroy()
items.destroy()
object.destroy()
```

### Handle evaluation errors

`Context::get_exception()` and `Context::exception_message()` both consume the
pending QuickJS exception, so read the exception in the form you want and then
continue.

```moonbit
let value = context.eval("throw new Error('boom')")
if value.is_exception() {
  value.destroy()
  println(context.exception_message())
} else {
  value.destroy()
}
```

### Drive Promise jobs

QuickJS does not run Promise jobs on its own when embedded this way. Use the
runtime job helpers to drain the queue:

```moonbit
let setup = context.eval(
  "globalThis.answer = 0; Promise.resolve(41).then(v => { globalThis.answer = v + 1; });",
)
guard !setup.is_exception() else {
  let message = context.exception_message()
  setup.destroy()
  fail(message)
}
setup.destroy()

while runtime.is_job_pending() {
  ignore(runtime.execute_pending_job())
}
```

## Examples

Runnable examples live under [`examples/`](./examples):

```text
moon -C examples run basic_eval
moon -C examples run json_bridge
moon -C examples run error_handling
moon -C examples run pending_jobs
```

## Development

Useful commands while working on the package:

```text
moon check --target native
moon test --target native -v
moon coverage analyze -p justjavac/quickjs -- -f summary
moon coverage analyze -p justjavac/quickjs -- -f cobertura -o coverage-windows.xml
moon -C examples check --target native
python scripts/vendor_quickjs.py --check --source target/quickjs-src
```

## Vendored QuickJS C Sources

`src/` contains the QuickJS engine sources from
[bellard/quickjs](https://github.com/bellard/quickjs.git), version `2025-09-13`
(commit `d7ae12ae71dfd6ab2997527d295014a8996fa0f9`). They are listed in
`src/moon.pkg` under `native-stub`, so `moon` compiles and links them together
with `stub.c` for every native build.

The sources carry the MSVC compatibility patches that the previous CMake-based
static library build applied at configure time. They are now part of the
checked-in source, so no build-time flags or Node.js `prebuild` hook are needed:

- `quickjs_build.h` — fixes `CONFIG_VERSION`, defines the CRT/NOMINMAX macros,
  and force-includes `compat/msvc_compat.h` on MSVC (`__builtin_*`,
  `__attribute__`, etc.)
- `compat/sys/time.h` — provides `gettimeofday` on Windows and falls through to
  the system header elsewhere
- `quickjs.c` — disables computed-goto dispatch and Atomics on Windows, replaces
  division-by-zero constants with `INFINITY`, removes the `(JSValue)` casts that
  MSVC rejects, and widens the 3-bit closure bitfield to `uint8_t`
- `src/quickjs.h` is the exported header with `return v;` instead of
  `return (JSValue)v;`

To refresh the vendored sources from an upstream checkout:

```text
git clone https://github.com/bellard/quickjs.git target/quickjs-src
git -C target/quickjs-src checkout d7ae12ae71dfd6ab2997527d295014a8996fa0f9
python scripts/vendor_quickjs.py --source target/quickjs-src
moon test --target native
```

`python scripts/vendor_quickjs.py --check --source ...` verifies that the
checked-in files still match a fresh vendor run. If upstream changes enough
that a patch no longer applies, the script fails loudly instead of silently
emitting an unbuildable source. The only requirements are Python 3 and a local
QuickJS checkout — no `gh`, no Node.js, no CMake.

More script-specific notes live in [scripts/README.mbt.md](./scripts/README.mbt.md).

## License

The MoonBit bindings are licensed under the MIT License; see
[LICENSE](./LICENSE). The vendored QuickJS engine sources under `src/` are
licensed under their own MIT license, reproduced in
[src/LICENSE-quickjs](./src/LICENSE-quickjs). The upstream copyright notice is
shipped with the sources and is included in published packages.
