///|
/// Destroys the value and releases its native QuickJS handle.
///
/// Call this once the value is no longer needed.
pub fn Value::destroy(self : Value) -> Unit {
  quickjs_value_destroy(self)
}

///|
/// Creates another handle that refers to the same underlying JavaScript value.
///
/// This is useful when the same value needs to outlive another owner or be
/// stored in multiple places.
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
pub fn Value::is_null(self : Value) -> Bool {
  quickjs_value_is_null(self)
}

///|
/// Reports whether this value is JavaScript `undefined`.
pub fn Value::is_undefined(self : Value) -> Bool {
  quickjs_value_is_undefined(self)
}

///|
/// Reports whether this value is a JavaScript boolean.
pub fn Value::is_bool(self : Value) -> Bool {
  quickjs_value_is_bool(self)
}

///|
/// Reports whether this value is a JavaScript number.
pub fn Value::is_number(self : Value) -> Bool {
  quickjs_value_is_number(self)
}

///|
/// Reports whether this value is a JavaScript string.
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
/// The returned property is a new handle owned by the caller.
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
/// indicates failure.
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
/// The returned property is a new handle owned by the caller.
pub fn Value::get_index(self : Value, context : Context, index : UInt) -> Value {
  quickjs_value_get_property_uint32(context, self, index)
}

///|
/// Writes an indexed property onto an array-like JavaScript value.
///
/// The return value is the raw QuickJS status code, where a negative value
/// indicates failure.
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
pub fn Value::to_int32(self : Value, context : Context) -> Int {
  context.to_int32(self)
}

///|
/// Converts this value to a floating-point number with the given context.
pub fn Value::to_float64(self : Value, context : Context) -> Double {
  context.to_float64(self)
}

///|
/// Converts this value to a boolean with the given context.
pub fn Value::to_bool(self : Value, context : Context) -> Bool {
  context.to_bool(self)
}

///|
/// Converts this value to a string with the given context.
pub fn Value::to_string_lossy(self : Value, context : Context) -> String {
  context.to_string_lossy(self)
}
