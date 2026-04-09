///|
test "quickjs eval and property smoke test" {
  let runtime = Runtime::new()
  let context = runtime.new_context()

  let result = context.eval("1 + 2")
  guard !result.is_exception() else {
    fail("unexpected eval exception: " + context.exception_message())
  }
  inspect(result.to_int32(context), content="3")

  let global = context.global_object()
  guard global.is_object() else { fail("expected global object") }

  let answer = context.new_int32(41)
  let set_status = global.set_property(context, "answer", answer)
  guard set_status >= 0 else {
    fail("failed to set global.answer: " + context.exception_message())
  }

  let sum = context.eval("answer + 1")
  guard !sum.is_exception() else {
    fail("unexpected sum exception: " + context.exception_message())
  }
  inspect(sum.to_int32(context), content="42")

  let parsed = context.parse_json("{\"name\":\"moonbit\",\"items\":[1,2,3]}")
  guard !parsed.is_exception() else {
    fail("unexpected parse exception: " + context.exception_message())
  }

  let name = parsed.get_property(context, "name")
  inspect(name.to_string_lossy(context), content="moonbit")

  let items = parsed.get_property(context, "items")
  let second = items.get_index(context, 1)
  inspect(second.to_int32(context), content="2")

  second.destroy()
  items.destroy()
  name.destroy()
  parsed.destroy()
  sum.destroy()
  answer.destroy()
  global.destroy()
  result.destroy()
  context.destroy()
  runtime.destroy()
}
