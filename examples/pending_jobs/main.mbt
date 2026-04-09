///|
fn main {
  let runtime = @quickjs.Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let setup = context.eval(
    "globalThis.answer = 0; Promise.resolve(41).then(v => { globalThis.answer = v + 1; });",
  )
  if setup.is_exception() {
    let message = context.exception_message()
    setup.destroy()
    println("failed to schedule Promise job: \{message}")
  } else {
    defer setup.destroy()

    while runtime.is_job_pending() {
      ignore(runtime.execute_pending_job())
    }

    let answer = context.eval("answer")
    if answer.is_exception() {
      let message = context.exception_message()
      answer.destroy()
      println("failed to read Promise result: \{message}")
    } else {
      defer answer.destroy()
      println("Promise result = \{answer.to_int32(context)}")
    }
  }
}
