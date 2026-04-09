# quickjs

MoonBit bindings for the QuickJS JavaScript engine.

This package exposes three public handles:

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

## Working with Values

```mbt check
test {
  let runtime = Runtime::new()
  let context = runtime.new_context()

  let payload = context.parse_json("{\"name\":\"moonbit\",\"items\":[1,2,3]}")
  guard !payload.is_exception() else {
    let message = context.exception_message()
    payload.destroy()
    fail(message)
  }

  let name = payload.get_property(context, "name")
  let items = payload.get_property(context, "items")
  let second = items.get_index(context, 1)

  inspect(name.to_string_lossy(context), content="moonbit")
  inspect(second.to_int32(context), content="2")

  second.destroy()
  items.destroy()
  name.destroy()
  payload.destroy()
  context.destroy()
  runtime.destroy()
}
```

## Exceptions

`Context::get_exception()` and `Context::exception_message()` both consume the
pending exception stored by QuickJS.

```moonbit skip
let value = context.eval("throw new Error('boom')")
if value.is_exception() {
  value.destroy()
  println(context.exception_message())
}
```

## Promise Jobs

Drive the QuickJS job queue manually when your evaluated code schedules Promise
callbacks.

```moonbit skip
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
