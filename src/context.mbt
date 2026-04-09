///|
/// Creates a new QuickJS context from the given runtime.
///
/// Most code should prefer `Runtime::new_context()`, which reads more
/// naturally at the call site while producing the same result.
pub fn Context::new(runtime : Runtime) -> Context {
  quickjs_context_new(runtime)
}

///|
/// Destroys the context and releases its native resources.
///
/// Destroy every `Value` created from this context before destroying the
/// context itself.
pub fn Context::destroy(self : Context) -> Unit {
  quickjs_context_destroy(self)
}

///|
/// Evaluates JavaScript source code and returns the resulting value.
///
/// By default the code is evaluated as a global script with the synthetic file
/// name `<eval>`. Override `filename` for better diagnostics and `flags` when
/// you need module parsing, compile-only mode, or strict execution.
///
/// # Example
/// ```mbt check
/// test {
///   let runtime = Runtime::new()
///   let context = runtime.new_context()
///   let value = context.eval("40 + 2")
///   inspect(value.to_int32(context), content="42")
///   value.destroy()
///   context.destroy()
///   runtime.destroy()
/// }
/// ```
pub fn Context::eval(
  self : Context,
  code : String,
  filename? : String = "<eval>",
  flags? : Int = eval_type_global,
) -> Value {
  quickjs_context_eval(self, @ffi.to_cstr(code), @ffi.to_cstr(filename), flags)
}

///|
/// Returns the context global object.
///
/// The caller owns the returned handle and should destroy it after use.
pub fn Context::global_object(self : Context) -> Value {
  quickjs_context_get_global_object(self)
}

///|
/// Retrieves and clears the current pending exception object.
///
/// QuickJS stores only one pending exception per context, so calling this
/// method consumes that exception state.
pub fn Context::get_exception(self : Context) -> Value {
  quickjs_context_get_exception(self)
}

///|
/// Retrieves the current pending exception as a human-readable string.
///
/// Like `Context::get_exception()`, this consumes the pending exception from
/// the context.
pub fn Context::exception_message(self : Context) -> String {
  @ffi.from_cstr(quickjs_context_exception_message(self))
}

///|
/// Creates a new plain JavaScript object.
///
/// The returned value behaves like `{}` in JavaScript.
pub fn Context::new_object(self : Context) -> Value {
  quickjs_context_new_object(self)
}

///|
/// Creates a new JavaScript array.
///
/// The returned value behaves like `[]` in JavaScript.
pub fn Context::new_array(self : Context) -> Value {
  quickjs_context_new_array(self)
}

///|
/// Creates a JavaScript string from MoonBit text.
///
/// The returned handle owns a QuickJS string value and must be destroyed by
/// the caller.
pub fn Context::new_string(self : Context, text : String) -> Value {
  quickjs_context_new_string(self, @ffi.to_cstr(text))
}

///|
/// Creates a JavaScript 32-bit integer value.
///
/// This is useful when preparing arguments or object properties from MoonBit.
pub fn Context::new_int32(self : Context, value : Int) -> Value {
  quickjs_context_new_int32(self, value)
}

///|
/// Creates a JavaScript floating-point value.
///
/// Use this when the result should preserve fractional data.
pub fn Context::new_float64(self : Context, value : Double) -> Value {
  quickjs_context_new_float64(self, value)
}

///|
/// Creates a JavaScript boolean value.
///
/// This returns `true` or `false` as a QuickJS handle.
pub fn Context::new_bool(self : Context, value : Bool) -> Value {
  quickjs_context_new_bool(self, value)
}

///|
/// Returns a wrapped JavaScript `null` value.
///
/// This is convenient when populating objects and arrays from MoonBit.
pub fn Context::null(self : Context) -> Value {
  quickjs_context_new_null(self)
}

///|
/// Returns a wrapped JavaScript `undefined` value.
///
/// This is convenient when modeling omitted JavaScript values explicitly.
pub fn Context::undefined(self : Context) -> Value {
  quickjs_context_new_undefined(self)
}

///|
/// Parses JSON text into a JavaScript value.
///
/// The returned value can be inspected with the usual property and conversion
/// helpers on `Value`.
pub fn Context::parse_json(
  self : Context,
  text : String,
  filename? : String = "<json>",
) -> Value {
  quickjs_context_parse_json(self, @ffi.to_cstr(text), @ffi.to_cstr(filename))
}

///|
/// Serializes a JavaScript value using `JSON.stringify`.
///
/// The result is itself a JavaScript string value, which you can convert with
/// `Value::to_string_lossy()`.
pub fn Context::json_stringify(self : Context, value : Value) -> Value {
  quickjs_context_json_stringify(self, value)
}

///|
/// Converts a JavaScript value to a 32-bit integer.
///
/// This applies QuickJS numeric coercion rules before returning the MoonBit
/// `Int`.
pub fn Context::to_int32(self : Context, value : Value) -> Int {
  quickjs_value_to_int32(self, value)
}

///|
/// Converts a JavaScript value to a floating-point number.
///
/// This applies QuickJS numeric coercion rules before returning the MoonBit
/// `Double`.
pub fn Context::to_float64(self : Context, value : Value) -> Double {
  quickjs_value_to_float64(self, value)
}

///|
/// Converts a JavaScript value to a boolean.
///
/// This applies JavaScript truthiness rules through QuickJS.
pub fn Context::to_bool(self : Context, value : Value) -> Bool {
  quickjs_value_to_bool(self, value)
}

///|
/// Converts a JavaScript value to a string using QuickJS coercion.
///
/// This is a lossy host-facing conversion that always returns a MoonBit
/// `String`.
pub fn Context::to_string_lossy(self : Context, value : Value) -> String {
  @ffi.from_cstr(quickjs_value_to_string_lossy(self, value))
}
