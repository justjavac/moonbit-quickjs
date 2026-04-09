///|
fn main {
  let runtime = @quickjs.Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let value = context.eval("throw new Error('boom from QuickJS')")
  if value.is_exception() {
    value.destroy()
    println(context.exception_message())
  } else {
    defer value.destroy()
    println("unexpected success")
  }
}
