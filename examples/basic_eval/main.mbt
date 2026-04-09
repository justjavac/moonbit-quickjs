///|
fn main {
  let runtime = @quickjs.Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let result = context.eval("21 * 2")
  if result.is_exception() {
    let message = context.exception_message()
    result.destroy()
    println("evaluation failed: \{message}")
  } else {
    defer result.destroy()
    println("21 * 2 = \{result.to_int32(context)}")
  }
}
