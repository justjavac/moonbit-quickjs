///|
fn main {
  let runtime = @quickjs.Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  let payload = context.new_object()
  defer payload.destroy()

  let name = context.new_string("moonbit")
  defer name.destroy()
  ignore(payload.set_property(context, "name", name))

  let version = context.new_int32(1)
  defer version.destroy()
  ignore(payload.set_property(context, "version", version))

  let tags = context.new_array()
  defer tags.destroy()
  let first_tag = context.new_string("ffi")
  defer first_tag.destroy()
  ignore(tags.set_index(context, 0, first_tag))
  let second_tag = context.new_string("quickjs")
  defer second_tag.destroy()
  ignore(tags.set_index(context, 1, second_tag))
  ignore(payload.set_property(context, "tags", tags))

  let stringified = context.json_stringify(payload)
  defer stringified.destroy()
  println(stringified.to_string_lossy(context))

  let parsed_name = payload.get_property(context, "name")
  defer parsed_name.destroy()
  println("name = \{parsed_name.to_string_lossy(context)}")
}
