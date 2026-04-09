# moonbit-quickjs

[![coverage](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?label=coverage)](https://codecov.io/gh/justjavac/moonbit-quickjs)
[![linux](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?flag=linux&label=linux)](https://codecov.io/gh/justjavac/moonbit-quickjs)
[![macos](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?flag=macos&label=macos)](https://codecov.io/gh/justjavac/moonbit-quickjs)
[![windows](https://img.shields.io/codecov/c/github/justjavac/moonbit-quickjs/main?flag=windows&label=windows)](https://codecov.io/gh/justjavac/moonbit-quickjs)

MoonBit bindings for the [QuickJS](https://bellard.org/quickjs/) JavaScript engine.

This package provides a small high-level MoonBit API over QuickJS runtimes,
contexts, and values. It ships vendored native libraries for the supported
platforms so downstream users do not need to build QuickJS themselves.

## Features

- Native-only MoonBit package built on top of a small FFI surface
- Vendored QuickJS libraries for Windows, Linux, and macOS
- Explicit lifecycle management for runtimes, contexts, and values
- Routines for evaluation, JSON parsing, property access, and Promise jobs

## Supported Targets and Platforms

The package is configured with:

- `preferred-target: native`
- `supported_targets: +native`

Vendored libraries are included for:

- `windows-x64`
- `linux-x64`
- `macos-universal`

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
moon run --target native scripts/sync_libquickjs.mbtx help
```

## Refreshing Vendored QuickJS Artifacts

The repository includes [`sync_libquickjs.mbtx`](./scripts/sync_libquickjs.mbtx),
a native MoonBit script that:

- resolves the latest successful `build` run from `justjavac/libquickjs` by default
- downloads the workflow artifacts with `gh run download`
- updates vendored libraries under `lib/`
- updates `src/quickjs.h`

Examples:

```text
moon run --target native scripts/sync_libquickjs.mbtx help
moon run --target native scripts/sync_libquickjs.mbtx
moon run --target native scripts/sync_libquickjs.mbtx --run-id 123456789
moon run --target native scripts/sync_libquickjs.mbtx --repo justjavac/libquickjs
```

Requirements:

- GitHub CLI `gh` installed
- `gh auth login` already completed

More script-specific notes live in [scripts/README.mbt.md](./scripts/README.mbt.md).

## License

This package is licensed under the MIT License. See [LICENSE](./LICENSE) for details.
