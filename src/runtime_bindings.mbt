///|
/// Calls `JS_NewRuntime` through the native FFI layer.
extern "C" fn quickjs_runtime_new() -> Runtime = "moonbit_quickjs_runtime_new"

///|
/// Releases the native runtime handle immediately.
#borrow(runtime)
extern "C" fn quickjs_runtime_destroy(runtime : Runtime) -> Unit = "moonbit_quickjs_runtime_destroy"

///|
/// Updates the runtime info string stored by QuickJS.
#borrow(runtime, info)
extern "C" fn quickjs_runtime_set_info(runtime : Runtime, info : Bytes) -> Unit = "moonbit_quickjs_runtime_set_info"

///|
/// Sets the memory limit enforced by QuickJS for this runtime.
#borrow(runtime)
extern "C" fn quickjs_runtime_set_memory_limit(
  runtime : Runtime,
  limit : UInt64,
) -> Unit = "moonbit_quickjs_runtime_set_memory_limit"

///|
/// Sets the garbage-collection threshold for this runtime.
#borrow(runtime)
extern "C" fn quickjs_runtime_set_gc_threshold(
  runtime : Runtime,
  threshold : UInt64,
) -> Unit = "moonbit_quickjs_runtime_set_gc_threshold"

///|
/// Sets the maximum C stack size observed by QuickJS.
#borrow(runtime)
extern "C" fn quickjs_runtime_set_max_stack_size(
  runtime : Runtime,
  stack_size : UInt64,
) -> Unit = "moonbit_quickjs_runtime_set_max_stack_size"

///|
/// Refreshes the recorded native stack top for this runtime.
#borrow(runtime)
extern "C" fn quickjs_runtime_update_stack_top(runtime : Runtime) -> Unit = "moonbit_quickjs_runtime_update_stack_top"

///|
/// Controls whether blocking host operations are allowed.
#borrow(runtime)
extern "C" fn quickjs_runtime_set_can_block(
  runtime : Runtime,
  can_block : Bool,
) -> Unit = "moonbit_quickjs_runtime_set_can_block"

///|
/// Forces a QuickJS garbage-collection cycle.
#borrow(runtime)
extern "C" fn quickjs_runtime_run_gc(runtime : Runtime) -> Unit = "moonbit_quickjs_runtime_run_gc"

///|
/// Reports whether the runtime has pending jobs to execute.
#borrow(runtime)
extern "C" fn quickjs_runtime_is_job_pending(runtime : Runtime) -> Bool = "moonbit_quickjs_runtime_is_job_pending"

///|
/// Runs one pending job from the QuickJS job queue.
#borrow(runtime)
extern "C" fn quickjs_runtime_execute_pending_job(runtime : Runtime) -> Int = "moonbit_quickjs_runtime_execute_pending_job"
