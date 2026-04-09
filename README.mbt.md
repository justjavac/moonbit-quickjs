# quickjs

MoonBit bindings for the QuickJS JavaScript engine.

- Package: `justjavac/quickjs`
- Target: `native`
- Platforms: `windows-x64`, `linux-x64`, `macos-universal`

## Usage

```moonbit
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
```
