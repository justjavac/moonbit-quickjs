///|
/// Destroys the value and releases its native QuickJS handle.
///
/// Call this once the value is no longer needed. A convenient pattern is to
/// create the value and immediately register `defer value.destroy()` in the
/// surrounding scope.
pub fn Value::destroy(self : Value) -> Unit {
  quickjs_value_destroy(self)
}

///|
/// Creates another handle that refers to the same underlying JavaScript value.
///
/// This is useful when the same value needs to outlive another owner or be
/// stored in multiple places. The duplicated handle must be destroyed
/// independently from the original handle.
pub fn Value::dup(self : Value) -> Value {
  quickjs_value_dup(self)
}

///|
/// Reports whether this value is the QuickJS exception sentinel.
///
/// Values returned from failed `Context::eval()` or `Context::parse_json()`
/// calls can be checked with this method before performing conversions.
pub fn Value::is_exception(self : Value) -> Bool {
  quickjs_value_is_exception(self)
}

///|
/// Reports whether this value is JavaScript `null`.
///
/// This only matches the actual `null` value; missing properties and omitted
/// results often surface as `undefined` instead.
pub fn Value::is_null(self : Value) -> Bool {
  quickjs_value_is_null(self)
}

///|
/// Reports whether this value is JavaScript `undefined`.
///
/// This is useful when distinguishing omitted JavaScript results from explicit
/// `null` payloads returned by application code.
pub fn Value::is_undefined(self : Value) -> Bool {
  quickjs_value_is_undefined(self)
}

///|
/// Reports whether this value is a JavaScript boolean.
///
/// Use this before coercion when host code wants to preserve whether the
/// original JavaScript value was truly `true` or `false`.
pub fn Value::is_bool(self : Value) -> Bool {
  quickjs_value_is_bool(self)
}

///|
/// Reports whether this value is a JavaScript number.
///
/// QuickJS numeric values include both integer and floating-point
/// representations, so this is the broad predicate to test before numeric
/// conversion.
pub fn Value::is_number(self : Value) -> Bool {
  quickjs_value_is_number(self)
}

///|
/// Reports whether this value is a JavaScript string.
///
/// This checks the underlying JavaScript type directly instead of relying on
/// host-side string coercion.
pub fn Value::is_string(self : Value) -> Bool {
  quickjs_value_is_string(self)
}

///|
/// Reports whether this value is a JavaScript object.
///
/// Arrays also count as objects under QuickJS semantics.
pub fn Value::is_object(self : Value) -> Bool {
  quickjs_value_is_object(self)
}

///|
/// Reads a named property from an object-like JavaScript value.
///
/// The returned property is a new handle owned by the caller. If the property
/// access throws, for example because of a getter or proxy trap, the result is
/// the QuickJS exception sentinel.
pub fn Value::get_property(
  self : Value,
  context : Context,
  name : String,
) -> Value {
  quickjs_value_get_property_str(context, self, @ffi.to_cstr(name))
}

///|
/// Writes a named property onto an object-like JavaScript value.
///
/// The return value is the raw QuickJS status code, where a negative value
/// indicates failure. This is the usual host-side way to populate objects
/// returned by `Context::new_object()`. The property handle remains owned by
/// the caller, so you should still destroy it after the write.
///
/// # Example
/// ```mbt check
/// test {
///   let runtime = Runtime::new()
///   defer runtime.destroy()
///   let context = runtime.new_context()
///   defer context.destroy()
///
///   let object = context.new_object()
///   defer object.destroy()
///   let answer = context.new_int32(42)
///   defer answer.destroy()
///
///   ignore(object.set_property(context, "answer", answer))
///
///   let read_back = object.get_property(context, "answer")
///   defer read_back.destroy()
///   inspect(read_back.to_int32(context), content="42")
/// }
/// ```
pub fn Value::set_property(
  self : Value,
  context : Context,
  name : String,
  property : Value,
) -> Int {
  quickjs_value_set_property_str(context, self, @ffi.to_cstr(name), property)
}

///|
/// Reads an indexed property from an array-like JavaScript value.
///
/// The returned property is a new handle owned by the caller. This is useful
/// for traversing arrays, tuples, and array-like objects exposed from
/// JavaScript.
pub fn Value::get_index(self : Value, context : Context, index : UInt) -> Value {
  quickjs_value_get_property_uint32(context, self, index)
}

///|
/// Writes an indexed property onto an array-like JavaScript value.
///
/// The return value is the raw QuickJS status code, where a negative value
/// indicates failure. This pairs naturally with `Context::new_array()` when
/// building JavaScript arrays from MoonBit. As with `Value::set_property()`,
/// the passed `property` handle remains owned by the caller.
///
/// # Example
/// ```mbt check
/// test {
///   let runtime = Runtime::new()
///   defer runtime.destroy()
///   let context = runtime.new_context()
///   defer context.destroy()
///
///   let array = context.new_array()
///   defer array.destroy()
///   let first = context.new_string("moon")
///   defer first.destroy()
///
///   ignore(array.set_index(context, 0, first))
///
///   let read_back = array.get_index(context, 0)
///   defer read_back.destroy()
///   inspect(read_back.to_string_lossy(context), content="moon")
/// }
/// ```
pub fn Value::set_index(
  self : Value,
  context : Context,
  index : UInt,
  property : Value,
) -> Int {
  quickjs_value_set_property_uint32(context, self, index, property)
}

///|
/// Converts this value to a 32-bit integer with the given context.
///
/// This delegates to `Context::to_int32()` and therefore follows the same
/// QuickJS coercion rules used during script execution.
pub fn Value::to_int32(self : Value, context : Context) -> Int {
  context.to_int32(self)
}

///|
/// Converts this value to a floating-point number with the given context.
///
/// This is convenient when chaining property access and numeric conversion from
/// the value handle itself.
pub fn Value::to_float64(self : Value, context : Context) -> Double {
  context.to_float64(self)
}

///|
/// Converts this value to a boolean with the given context.
///
/// The result follows normal JavaScript truthiness semantics through the owning
/// context.
pub fn Value::to_bool(self : Value, context : Context) -> Bool {
  context.to_bool(self)
}

///|
/// Converts this value to a string with the given context.
///
/// Use this for host-facing logging and assertions when you want JavaScript
/// string coercion applied automatically.
pub fn Value::to_string_lossy(self : Value, context : Context) -> String {
  context.to_string_lossy(self)
}
