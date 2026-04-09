///|
#external
pub type Runtime

///|
#external
pub type Context

///|
#external
pub type Value

///|
pub let eval_type_global : Int = 0

///|
pub let eval_type_module : Int = 1

///|
pub let eval_type_direct : Int = 2

///|
pub let eval_type_indirect : Int = 3

///|
pub let eval_flag_strict : Int = 1 << 3

///|
pub let eval_flag_compile_only : Int = 1 << 5

///|
pub let eval_flag_backtrace_barrier : Int = 1 << 6

///|
pub let eval_flag_async : Int = 1 << 7

///|
pub extern "C" fn quickjs_runtime_new() -> Runtime = "moonbit_quickjs_runtime_new"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_destroy(runtime : Runtime) -> Unit = "moonbit_quickjs_runtime_destroy"

///|
#borrow(runtime, info)
pub extern "C" fn quickjs_runtime_set_info(
  runtime : Runtime,
  info : Bytes,
) -> Unit = "moonbit_quickjs_runtime_set_info"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_set_memory_limit(
  runtime : Runtime,
  limit : UInt64,
) -> Unit = "moonbit_quickjs_runtime_set_memory_limit"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_set_gc_threshold(
  runtime : Runtime,
  threshold : UInt64,
) -> Unit = "moonbit_quickjs_runtime_set_gc_threshold"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_set_max_stack_size(
  runtime : Runtime,
  stack_size : UInt64,
) -> Unit = "moonbit_quickjs_runtime_set_max_stack_size"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_update_stack_top(runtime : Runtime) -> Unit = "moonbit_quickjs_runtime_update_stack_top"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_set_can_block(
  runtime : Runtime,
  can_block : Bool,
) -> Unit = "moonbit_quickjs_runtime_set_can_block"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_run_gc(runtime : Runtime) -> Unit = "moonbit_quickjs_runtime_run_gc"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_is_job_pending(runtime : Runtime) -> Bool = "moonbit_quickjs_runtime_is_job_pending"

///|
#borrow(runtime)
pub extern "C" fn quickjs_runtime_execute_pending_job(runtime : Runtime) -> Int = "moonbit_quickjs_runtime_execute_pending_job"

///|
#borrow(runtime)
pub extern "C" fn quickjs_context_new(runtime : Runtime) -> Context = "moonbit_quickjs_context_new"

///|
#borrow(context)
pub extern "C" fn quickjs_context_destroy(context : Context) -> Unit = "moonbit_quickjs_context_destroy"

///|
#borrow(context, code, filename)
pub extern "C" fn quickjs_context_eval(
  context : Context,
  code : Bytes,
  filename : Bytes,
  flags : Int,
) -> Value = "moonbit_quickjs_context_eval"

///|
#borrow(context)
pub extern "C" fn quickjs_context_get_global_object(context : Context) -> Value = "moonbit_quickjs_context_get_global_object"

///|
#borrow(context)
pub extern "C" fn quickjs_context_get_exception(context : Context) -> Value = "moonbit_quickjs_context_get_exception"

///|
#borrow(context)
pub extern "C" fn quickjs_context_exception_message(context : Context) -> Bytes = "moonbit_quickjs_context_exception_message"

///|
#borrow(context)
pub extern "C" fn quickjs_context_new_object(context : Context) -> Value = "moonbit_quickjs_context_new_object"

///|
#borrow(context)
pub extern "C" fn quickjs_context_new_array(context : Context) -> Value = "moonbit_quickjs_context_new_array"

///|
#borrow(context, text)
pub extern "C" fn quickjs_context_new_string(
  context : Context,
  text : Bytes,
) -> Value = "moonbit_quickjs_context_new_string"

///|
#borrow(context)
pub extern "C" fn quickjs_context_new_int32(
  context : Context,
  value : Int,
) -> Value = "moonbit_quickjs_context_new_int32"

///|
#borrow(context)
pub extern "C" fn quickjs_context_new_float64(
  context : Context,
  value : Double,
) -> Value = "moonbit_quickjs_context_new_float64"

///|
#borrow(context)
pub extern "C" fn quickjs_context_new_bool(
  context : Context,
  value : Bool,
) -> Value = "moonbit_quickjs_context_new_bool"

///|
#borrow(context)
pub extern "C" fn quickjs_context_new_null(context : Context) -> Value = "moonbit_quickjs_context_new_null"

///|
#borrow(context)
pub extern "C" fn quickjs_context_new_undefined(context : Context) -> Value = "moonbit_quickjs_context_new_undefined"

///|
#borrow(context, text, filename)
pub extern "C" fn quickjs_context_parse_json(
  context : Context,
  text : Bytes,
  filename : Bytes,
) -> Value = "moonbit_quickjs_context_parse_json"

///|
#borrow(context, value)
pub extern "C" fn quickjs_context_json_stringify(
  context : Context,
  value : Value,
) -> Value = "moonbit_quickjs_context_json_stringify"

///|
#borrow(context, target, name)
pub extern "C" fn quickjs_value_get_property_str(
  context : Context,
  target : Value,
  name : Bytes,
) -> Value = "moonbit_quickjs_value_get_property_str"

///|
#borrow(context, target, property_name, property)
pub extern "C" fn quickjs_value_set_property_str(
  context : Context,
  target : Value,
  property_name : Bytes,
  property : Value,
) -> Int = "moonbit_quickjs_value_set_property_str"

///|
#borrow(context, target)
pub extern "C" fn quickjs_value_get_property_uint32(
  context : Context,
  target : Value,
  index : UInt,
) -> Value = "moonbit_quickjs_value_get_property_uint32"

///|
#borrow(context, target, property)
pub extern "C" fn quickjs_value_set_property_uint32(
  context : Context,
  target : Value,
  index : UInt,
  property : Value,
) -> Int = "moonbit_quickjs_value_set_property_uint32"

///|
#borrow(value)
pub extern "C" fn quickjs_value_destroy(value : Value) -> Unit = "moonbit_quickjs_value_destroy"

///|
#borrow(value)
pub extern "C" fn quickjs_value_dup(value : Value) -> Value = "moonbit_quickjs_value_dup"

///|
#borrow(value)
pub extern "C" fn quickjs_value_is_exception(value : Value) -> Bool = "moonbit_quickjs_value_is_exception"

///|
#borrow(value)
pub extern "C" fn quickjs_value_is_null(value : Value) -> Bool = "moonbit_quickjs_value_is_null"

///|
#borrow(value)
pub extern "C" fn quickjs_value_is_undefined(value : Value) -> Bool = "moonbit_quickjs_value_is_undefined"

///|
#borrow(value)
pub extern "C" fn quickjs_value_is_bool(value : Value) -> Bool = "moonbit_quickjs_value_is_bool"

///|
#borrow(value)
pub extern "C" fn quickjs_value_is_number(value : Value) -> Bool = "moonbit_quickjs_value_is_number"

///|
#borrow(value)
pub extern "C" fn quickjs_value_is_string(value : Value) -> Bool = "moonbit_quickjs_value_is_string"

///|
#borrow(value)
pub extern "C" fn quickjs_value_is_object(value : Value) -> Bool = "moonbit_quickjs_value_is_object"

///|
#borrow(context, value)
pub extern "C" fn quickjs_value_to_int32(
  context : Context,
  value : Value,
) -> Int = "moonbit_quickjs_value_to_int32"

///|
#borrow(context, value)
pub extern "C" fn quickjs_value_to_float64(
  context : Context,
  value : Value,
) -> Double = "moonbit_quickjs_value_to_float64"

///|
#borrow(context, value)
pub extern "C" fn quickjs_value_to_bool(
  context : Context,
  value : Value,
) -> Bool = "moonbit_quickjs_value_to_bool"

///|
#borrow(context, value)
pub extern "C" fn quickjs_value_to_string_lossy(
  context : Context,
  value : Value,
) -> Bytes = "moonbit_quickjs_value_to_string_lossy"
