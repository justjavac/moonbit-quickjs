///|
/// Creates a new QuickJS context from the given runtime.
#borrow(runtime)
extern "C" fn quickjs_context_new(runtime : Runtime) -> Context = "moonbit_quickjs_context_new"

///|
/// Releases the native context handle immediately.
#borrow(context)
extern "C" fn quickjs_context_destroy(context : Context) -> Unit = "moonbit_quickjs_context_destroy"

///|
/// Evaluates JavaScript source in the given context.
#borrow(context, code, filename)
extern "C" fn quickjs_context_eval(
  context : Context,
  code : Bytes,
  filename : Bytes,
  flags : Int,
) -> Value = "moonbit_quickjs_context_eval"

///|
/// Returns the current global object for the context.
#borrow(context)
extern "C" fn quickjs_context_get_global_object(context : Context) -> Value = "moonbit_quickjs_context_get_global_object"

///|
/// Retrieves and clears the current pending exception.
#borrow(context)
extern "C" fn quickjs_context_get_exception(context : Context) -> Value = "moonbit_quickjs_context_get_exception"

///|
/// Converts the current pending exception into a message string.
#borrow(context)
extern "C" fn quickjs_context_exception_message(context : Context) -> Bytes = "moonbit_quickjs_context_exception_message"

///|
/// Creates a new plain JavaScript object.
#borrow(context)
extern "C" fn quickjs_context_new_object(context : Context) -> Value = "moonbit_quickjs_context_new_object"

///|
/// Creates a new JavaScript array.
#borrow(context)
extern "C" fn quickjs_context_new_array(context : Context) -> Value = "moonbit_quickjs_context_new_array"

///|
/// Creates a JavaScript string from UTF-8 input.
#borrow(context, text)
extern "C" fn quickjs_context_new_string(
  context : Context,
  text : Bytes,
) -> Value = "moonbit_quickjs_context_new_string"

///|
/// Creates a JavaScript 32-bit integer value.
#borrow(context)
extern "C" fn quickjs_context_new_int32(
  context : Context,
  value : Int,
) -> Value = "moonbit_quickjs_context_new_int32"

///|
/// Creates a JavaScript floating-point value.
#borrow(context)
extern "C" fn quickjs_context_new_float64(
  context : Context,
  value : Double,
) -> Value = "moonbit_quickjs_context_new_float64"

///|
/// Creates a JavaScript boolean value.
#borrow(context)
extern "C" fn quickjs_context_new_bool(
  context : Context,
  value : Bool,
) -> Value = "moonbit_quickjs_context_new_bool"

///|
/// Returns a wrapped JavaScript `null` value.
#borrow(context)
extern "C" fn quickjs_context_new_null(context : Context) -> Value = "moonbit_quickjs_context_new_null"

///|
/// Returns a wrapped JavaScript `undefined` value.
#borrow(context)
extern "C" fn quickjs_context_new_undefined(context : Context) -> Value = "moonbit_quickjs_context_new_undefined"

///|
/// Parses JSON text into a JavaScript value.
#borrow(context, text, filename)
extern "C" fn quickjs_context_parse_json(
  context : Context,
  text : Bytes,
  filename : Bytes,
) -> Value = "moonbit_quickjs_context_parse_json"

///|
/// Serializes a JavaScript value with `JSON.stringify`.
#borrow(context, value)
extern "C" fn quickjs_context_json_stringify(
  context : Context,
  value : Value,
) -> Value = "moonbit_quickjs_context_json_stringify"

///|
/// Converts a JavaScript value into a 32-bit integer.
#borrow(context, value)
extern "C" fn quickjs_value_to_int32(context : Context, value : Value) -> Int = "moonbit_quickjs_value_to_int32"

///|
/// Converts a JavaScript value into a floating-point number.
#borrow(context, value)
extern "C" fn quickjs_value_to_float64(
  context : Context,
  value : Value,
) -> Double = "moonbit_quickjs_value_to_float64"

///|
/// Converts a JavaScript value into a boolean.
#borrow(context, value)
extern "C" fn quickjs_value_to_bool(context : Context, value : Value) -> Bool = "moonbit_quickjs_value_to_bool"

///|
/// Converts a JavaScript value into a string using QuickJS coercion.
#borrow(context, value)
extern "C" fn quickjs_value_to_string_lossy(
  context : Context,
  value : Value,
) -> Bytes = "moonbit_quickjs_value_to_string_lossy"
