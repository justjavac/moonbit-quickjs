# quickjs

MoonBit bindings for the QuickJS JavaScript engine. This package exposes three public handles:

- `Runtime` for allocator state and pending jobs
- `Context` for execution scope and exception state
- `Value` for JavaScript values

Destroy values before contexts, and destroy contexts before the runtime.

## Quick Start

```mbt check
test {
  let runtime = Runtime::new()
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
}
```

## Features

- Native-only MoonBit package built on top of a small FFI surface
- Vendored QuickJS libraries for Windows, Linux, and macOS
- Explicit lifecycle management for runtimes, contexts, and values
- Routines for evaluation, JSON parsing, property access, and Promise jobs
