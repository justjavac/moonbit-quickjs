///|
pub fn Runtime::new() -> Runtime {
  quickjs_runtime_new()
}

///|
pub fn Runtime::destroy(self : Runtime) -> Unit {
  quickjs_runtime_destroy(self)
}

///|
pub fn Runtime::set_info(self : Runtime, info : String) -> Unit {
  quickjs_runtime_set_info(self, @ffi.to_cstr(info))
}

///|
pub fn Runtime::set_memory_limit(self : Runtime, limit : UInt64) -> Unit {
  quickjs_runtime_set_memory_limit(self, limit)
}

///|
pub fn Runtime::set_gc_threshold(self : Runtime, threshold : UInt64) -> Unit {
  quickjs_runtime_set_gc_threshold(self, threshold)
}

///|
pub fn Runtime::set_max_stack_size(self : Runtime, stack_size : UInt64) -> Unit {
  quickjs_runtime_set_max_stack_size(self, stack_size)
}

///|
pub fn Runtime::update_stack_top(self : Runtime) -> Unit {
  quickjs_runtime_update_stack_top(self)
}

///|
pub fn Runtime::set_can_block(self : Runtime, can_block : Bool) -> Unit {
  quickjs_runtime_set_can_block(self, can_block)
}

///|
pub fn Runtime::run_gc(self : Runtime) -> Unit {
  quickjs_runtime_run_gc(self)
}

///|
pub fn Runtime::is_job_pending(self : Runtime) -> Bool {
  quickjs_runtime_is_job_pending(self)
}

///|
pub fn Runtime::execute_pending_job(self : Runtime) -> Int {
  quickjs_runtime_execute_pending_job(self)
}

///|
pub fn Runtime::new_context(self : Runtime) -> Context {
  Context::new(self)
}

///|
pub fn Context::new(runtime : Runtime) -> Context {
  quickjs_context_new(runtime)
}

///|
pub fn Context::destroy(self : Context) -> Unit {
  quickjs_context_destroy(self)
}

///|
pub fn Context::eval(
  self : Context,
  code : String,
  filename? : String = "<eval>",
  flags? : Int = eval_type_global,
) -> Value {
  quickjs_context_eval(self, @ffi.to_cstr(code), @ffi.to_cstr(filename), flags)
}

///|
pub fn Context::global_object(self : Context) -> Value {
  quickjs_context_get_global_object(self)
}

///|
pub fn Context::get_exception(self : Context) -> Value {
  quickjs_context_get_exception(self)
}

///|
pub fn Context::exception_message(self : Context) -> String {
  @ffi.from_cstr(quickjs_context_exception_message(self))
}

///|
pub fn Context::new_object(self : Context) -> Value {
  quickjs_context_new_object(self)
}

///|
pub fn Context::new_array(self : Context) -> Value {
  quickjs_context_new_array(self)
}

///|
pub fn Context::new_string(self : Context, text : String) -> Value {
  quickjs_context_new_string(self, @ffi.to_cstr(text))
}

///|
pub fn Context::new_int32(self : Context, value : Int) -> Value {
  quickjs_context_new_int32(self, value)
}

///|
pub fn Context::new_float64(self : Context, value : Double) -> Value {
  quickjs_context_new_float64(self, value)
}

///|
pub fn Context::new_bool(self : Context, value : Bool) -> Value {
  quickjs_context_new_bool(self, value)
}

///|
pub fn Context::null(self : Context) -> Value {
  quickjs_context_new_null(self)
}

///|
pub fn Context::undefined(self : Context) -> Value {
  quickjs_context_new_undefined(self)
}

///|
pub fn Context::parse_json(
  self : Context,
  text : String,
  filename? : String = "<json>",
) -> Value {
  quickjs_context_parse_json(self, @ffi.to_cstr(text), @ffi.to_cstr(filename))
}

///|
pub fn Context::json_stringify(self : Context, value : Value) -> Value {
  quickjs_context_json_stringify(self, value)
}

///|
pub fn Context::to_int32(self : Context, value : Value) -> Int {
  quickjs_value_to_int32(self, value)
}

///|
pub fn Context::to_float64(self : Context, value : Value) -> Double {
  quickjs_value_to_float64(self, value)
}

///|
pub fn Context::to_bool(self : Context, value : Value) -> Bool {
  quickjs_value_to_bool(self, value)
}

///|
pub fn Context::to_string_lossy(self : Context, value : Value) -> String {
  @ffi.from_cstr(quickjs_value_to_string_lossy(self, value))
}

///|
pub fn Value::destroy(self : Value) -> Unit {
  quickjs_value_destroy(self)
}

///|
pub fn Value::dup(self : Value) -> Value {
  quickjs_value_dup(self)
}

///|
pub fn Value::is_exception(self : Value) -> Bool {
  quickjs_value_is_exception(self)
}

///|
pub fn Value::is_null(self : Value) -> Bool {
  quickjs_value_is_null(self)
}

///|
pub fn Value::is_undefined(self : Value) -> Bool {
  quickjs_value_is_undefined(self)
}

///|
pub fn Value::is_bool(self : Value) -> Bool {
  quickjs_value_is_bool(self)
}

///|
pub fn Value::is_number(self : Value) -> Bool {
  quickjs_value_is_number(self)
}

///|
pub fn Value::is_string(self : Value) -> Bool {
  quickjs_value_is_string(self)
}

///|
pub fn Value::is_object(self : Value) -> Bool {
  quickjs_value_is_object(self)
}

///|
pub fn Value::get_property(
  self : Value,
  context : Context,
  name : String,
) -> Value {
  quickjs_value_get_property_str(context, self, @ffi.to_cstr(name))
}

///|
pub fn Value::set_property(
  self : Value,
  context : Context,
  name : String,
  property : Value,
) -> Int {
  quickjs_value_set_property_str(context, self, @ffi.to_cstr(name), property)
}

///|
pub fn Value::get_index(self : Value, context : Context, index : UInt) -> Value {
  quickjs_value_get_property_uint32(context, self, index)
}

///|
pub fn Value::set_index(
  self : Value,
  context : Context,
  index : UInt,
  property : Value,
) -> Int {
  quickjs_value_set_property_uint32(context, self, index, property)
}

///|
pub fn Value::to_int32(self : Value, context : Context) -> Int {
  context.to_int32(self)
}

///|
pub fn Value::to_float64(self : Value, context : Context) -> Double {
  context.to_float64(self)
}

///|
pub fn Value::to_bool(self : Value, context : Context) -> Bool {
  context.to_bool(self)
}

///|
pub fn Value::to_string_lossy(self : Value, context : Context) -> String {
  context.to_string_lossy(self)
}
