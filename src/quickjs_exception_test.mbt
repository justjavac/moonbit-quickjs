///|
test "exceptions expose message and object" {
  let runtime = Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let thrown = context.eval("throw new Error('boom')")
  guard thrown.is_exception() else {
    thrown.destroy()
    fail("expected eval to return an exception sentinel")
  }
  thrown.destroy()

  let exception = context.get_exception()
  defer exception.destroy()
  assert_true(exception.is_object())
  inspect(exception.to_string_lossy(context), content="Error: boom")

  let thrown_again = context.eval("throw new Error('again')")
  guard thrown_again.is_exception() else {
    thrown_again.destroy()
    fail("expected second eval to return an exception sentinel")
  }
  thrown_again.destroy()

  inspect(context.exception_message(), content="Error: again")
}
