///|
/// Reads a named property from an object-like JavaScript value.
#borrow(context, target, name)
extern "C" fn quickjs_value_get_property_str(
  context : Context,
  target : Value,
  name : Bytes,
) -> Value = "moonbit_quickjs_value_get_property_str"

///|
/// Writes a named property onto an object-like JavaScript value.
#borrow(context, target, property_name, property)
extern "C" fn quickjs_value_set_property_str(
  context : Context,
  target : Value,
  property_name : Bytes,
  property : Value,
) -> Int = "moonbit_quickjs_value_set_property_str"

///|
/// Reads an indexed property from an array-like JavaScript value.
#borrow(context, target)
extern "C" fn quickjs_value_get_property_uint32(
  context : Context,
  target : Value,
  index : UInt,
) -> Value = "moonbit_quickjs_value_get_property_uint32"

///|
/// Writes an indexed property onto an array-like JavaScript value.
#borrow(context, target, property)
extern "C" fn quickjs_value_set_property_uint32(
  context : Context,
  target : Value,
  index : UInt,
  property : Value,
) -> Int = "moonbit_quickjs_value_set_property_uint32"

///|
/// Releases the native value handle immediately.
#borrow(value)
extern "C" fn quickjs_value_destroy(value : Value) -> Unit = "moonbit_quickjs_value_destroy"

///|
/// Duplicates a native QuickJS value handle.
#borrow(value)
extern "C" fn quickjs_value_dup(value : Value) -> Value = "moonbit_quickjs_value_dup"

///|
/// Checks whether the value is the QuickJS exception sentinel.
#borrow(value)
extern "C" fn quickjs_value_is_exception(value : Value) -> Bool = "moonbit_quickjs_value_is_exception"

///|
/// Checks whether the value is JavaScript `null`.
#borrow(value)
extern "C" fn quickjs_value_is_null(value : Value) -> Bool = "moonbit_quickjs_value_is_null"

///|
/// Checks whether the value is JavaScript `undefined`.
#borrow(value)
extern "C" fn quickjs_value_is_undefined(value : Value) -> Bool = "moonbit_quickjs_value_is_undefined"

///|
/// Checks whether the value is a JavaScript boolean.
#borrow(value)
extern "C" fn quickjs_value_is_bool(value : Value) -> Bool = "moonbit_quickjs_value_is_bool"

///|
/// Checks whether the value is a JavaScript number.
#borrow(value)
extern "C" fn quickjs_value_is_number(value : Value) -> Bool = "moonbit_quickjs_value_is_number"

///|
/// Checks whether the value is a JavaScript string.
#borrow(value)
extern "C" fn quickjs_value_is_string(value : Value) -> Bool = "moonbit_quickjs_value_is_string"

///|
/// Checks whether the value is a JavaScript object.
#borrow(value)
extern "C" fn quickjs_value_is_object(value : Value) -> Bool = "moonbit_quickjs_value_is_object"
