///|
test "constructors conversions and property access" {
  let runtime = Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let object = context.new_object()
  defer object.destroy()
  assert_true(object.is_object())

  let number = context.new_int32(42)
  defer number.destroy()
  assert_true(number.is_number())
  inspect(context.to_int32(number), content="42")
  inspect(number.to_int32(context), content="42")

  let float_value = context.new_float64(3.5)
  defer float_value.destroy()
  assert_true(float_value.is_number())
  inspect(context.to_float64(float_value), content="3.5")
  inspect(float_value.to_float64(context), content="3.5")

  let bool_value = context.new_bool(true)
  defer bool_value.destroy()
  assert_true(bool_value.is_bool())
  inspect(context.to_bool(bool_value), content="true")
  inspect(bool_value.to_bool(context), content="true")

  let string_value = context.new_string("moonbit")
  defer string_value.destroy()
  assert_true(string_value.is_string())
  inspect(context.to_string_lossy(string_value), content="moonbit")
  inspect(string_value.to_string_lossy(context), content="moonbit")

  guard_property_status(
    context,
    object.set_property(context, "answer", number),
    "failed to write object.answer",
  )
  let answer = object.get_property(context, "answer")
  defer answer.destroy()
  inspect(answer.to_int32(context), content="42")

  let duplicate = string_value.dup()
  defer duplicate.destroy()
  inspect(duplicate.to_string_lossy(context), content="moonbit")
}

///|
test "arrays null undefined and json stringify" {
  let runtime = Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let array = context.new_array()
  defer array.destroy()
  assert_true(array.is_object())

  let first = context.new_string("moon")
  defer first.destroy()
  guard_property_status(
    context,
    array.set_index(context, 0, first),
    "failed to write array[0]",
  )

  let second = context.new_int32(2)
  defer second.destroy()
  guard_property_status(
    context,
    array.set_index(context, 1, second),
    "failed to write array[1]",
  )

  let indexed = array.get_index(context, 0)
  defer indexed.destroy()
  inspect(indexed.to_string_lossy(context), content="moon")

  let null_value = context.null()
  defer null_value.destroy()
  assert_true(null_value.is_null())

  let undefined_value = context.undefined()
  defer undefined_value.destroy()
  assert_true(undefined_value.is_undefined())

  let json = context.json_stringify(array)
  guard_success(context, json, "failed to stringify array")
  defer json.destroy()
  inspect(json.to_string_lossy(context), content="[\"moon\",2]")
}

///|
test "parse_json supports nested object traversal" {
  let runtime = Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let parsed = context.parse_json("{\"name\":\"moonbit\",\"items\":[1,2,3]}")
  guard_success(context, parsed, "failed to parse JSON")
  defer parsed.destroy()

  let name = parsed.get_property(context, "name")
  defer name.destroy()
  inspect(name.to_string_lossy(context), content="moonbit")

  let items = parsed.get_property(context, "items")
  defer items.destroy()
  let third = items.get_index(context, 2)
  defer third.destroy()
  inspect(third.to_int32(context), content="3")
}
