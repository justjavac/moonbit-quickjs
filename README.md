# moonbit-quickjs

MoonBit bindings for the [QuickJS](https://bellard.org/quickjs/) JavaScript engine.

This repository packages a native QuickJS integration for MoonBit and vendors prebuilt QuickJS libraries for the platforms currently supported by the package.

## Features

- Native-only MoonBit package with QuickJS linked through FFI
- Vendored QuickJS libraries for Windows, Linux, and macOS
- Small high-level API over runtimes, contexts, and JavaScript values
- Helper script for refreshing vendored libraries from GitHub Actions artifacts

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

```moonbit
moon add justjavac/quickjs
```

## Quick Start

Import the package and evaluate a simple expression:

```moonbit skip
test {
  let runtime = @quickjs.Runtime::new()
  let context = runtime.new_context()

  let result = context.eval("1 + 2")
  guard !result.is_exception() else {
    fail(context.exception_message())
  }

  inspect(result.to_int32(context), content="3")

  result.destroy()
  context.destroy()
  runtime.destroy()
}
```

## Working with Values

The package exposes three core external types:

- `Runtime`
- `Context`
- `Value`

Typical usage looks like this:

1. Create a `Runtime`
2. Create a `Context` from the runtime
3. Evaluate code or create values through the context
4. Read properties or convert results back into MoonBit values
5. Explicitly destroy `Value`, `Context`, and `Runtime` handles when done

Example with JSON and property access:

```moonbit skip
test {
  let runtime = @quickjs.Runtime::new()
  let context = runtime.new_context()

  let parsed = context.parse_json("{\"name\":\"moonbit\",\"items\":[1,2,3]}")
  guard !parsed.is_exception() else {
    fail(context.exception_message())
  }

  let name = parsed.get_property(context, "name")
  let items = parsed.get_property(context, "items")
  let second = items.get_index(context, 1)

  inspect(name.to_string_lossy(context), content="moonbit")
  inspect(second.to_int32(context), content="2")

  second.destroy()
  items.destroy()
  name.destroy()
  parsed.destroy()
  context.destroy()
  runtime.destroy()
}
```

## API Overview

The public API currently includes:

- Runtime lifecycle: `Runtime::new`, `Runtime::destroy`, `Runtime::new_context`
- Runtime tuning: `set_info`, `set_memory_limit`, `set_gc_threshold`, `set_max_stack_size`, `set_can_block`
- Runtime execution helpers: `update_stack_top`, `run_gc`, `is_job_pending`, `execute_pending_job`
- Context lifecycle and evaluation: `Context::new`, `Context::destroy`, `Context::eval`
- Context value constructors: `new_object`, `new_array`, `new_string`, `new_int32`, `new_float64`, `new_bool`, `null`, `undefined`
- JSON helpers: `parse_json`, `json_stringify`
- Exception handling: `get_exception`, `exception_message`
- Value inspection and conversion: `is_*`, `to_int32`, `to_float64`, `to_bool`, `to_string_lossy`
- Object and array access: `get_property`, `set_property`, `get_index`, `set_index`

Evaluation flags are also exported:

- `eval_type_global`
- `eval_type_module`
- `eval_type_direct`
- `eval_type_indirect`
- `eval_flag_strict`
- `eval_flag_compile_only`
- `eval_flag_backtrace_barrier`
- `eval_flag_async`

## Refreshing Vendored QuickJS Artifacts

The repository includes [`sync_libquickjs.mbtx`](./scripts/sync_libquickjs.mbtx), a native MoonBit script that:

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

## Development

Useful commands while working on the package:

```text
moon check --target native
moon test --target native
moon test --target native src/quickjs_smoke_test.mbt
moon run --target native scripts/sync_libquickjs.mbtx help
```

## Notes

- This package is intentionally native-only.
- Resource cleanup is explicit; destroy QuickJS handles when they are no longer needed.
- Vendored libraries are part of the repository so downstream users do not need to build QuickJS themselves for the supported platforms.
