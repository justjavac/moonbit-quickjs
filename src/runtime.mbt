///|
/// Creates a fresh QuickJS runtime.
///
/// The runtime owns allocator state, garbage collection, and the pending job
/// queue shared by contexts created from it.
pub fn Runtime::new() -> Runtime {
  quickjs_runtime_new()
}

///|
/// Destroys the runtime and releases its native resources.
///
/// Destroy every context and value created from the runtime before calling
/// this method.
pub fn Runtime::destroy(self : Runtime) -> Unit {
  quickjs_runtime_destroy(self)
}

///|
/// Stores an informational label on the runtime.
///
/// QuickJS uses this string for diagnostics and embedding metadata.
pub fn Runtime::set_info(self : Runtime, info : String) -> Unit {
  quickjs_runtime_set_info(self, @ffi.to_cstr(info))
}

///|
/// Sets the maximum heap size that QuickJS may use for this runtime.
///
/// This limit is expressed in bytes and is best configured before executing
/// untrusted or memory-intensive scripts.
pub fn Runtime::set_memory_limit(self : Runtime, limit : UInt64) -> Unit {
  quickjs_runtime_set_memory_limit(self, limit)
}

///|
/// Sets the garbage-collection threshold in bytes.
///
/// Lower values trigger more frequent collections, while higher values favor
/// throughput over prompt reclamation.
pub fn Runtime::set_gc_threshold(self : Runtime, threshold : UInt64) -> Unit {
  quickjs_runtime_set_gc_threshold(self, threshold)
}

///|
/// Sets the maximum native stack size observed by QuickJS.
///
/// This can help bound recursion depth in embedded use cases.
pub fn Runtime::set_max_stack_size(self : Runtime, stack_size : UInt64) -> Unit {
  quickjs_runtime_set_max_stack_size(self, stack_size)
}

///|
/// Refreshes the current native stack top used by QuickJS stack checks.
///
/// Call this if the embedding environment changes the effective stack frame
/// origin before running more JavaScript work.
pub fn Runtime::update_stack_top(self : Runtime) -> Unit {
  quickjs_runtime_update_stack_top(self)
}

///|
/// Allows or forbids blocking operations inside QuickJS.
///
/// Embedders that need strict non-blocking behavior can disable blocking at
/// runtime with this switch.
pub fn Runtime::set_can_block(self : Runtime, can_block : Bool) -> Unit {
  quickjs_runtime_set_can_block(self, can_block)
}

///|
/// Runs a garbage-collection cycle immediately.
///
/// This is useful after releasing many values or before measuring retained
/// memory in tests and embedding diagnostics.
pub fn Runtime::run_gc(self : Runtime) -> Unit {
  quickjs_runtime_run_gc(self)
}

///|
/// Reports whether the runtime still has pending Promise jobs.
///
/// Use this together with `Runtime::execute_pending_job()` when the host needs
/// to drive the QuickJS job queue manually.
pub fn Runtime::is_job_pending(self : Runtime) -> Bool {
  quickjs_runtime_is_job_pending(self)
}

///|
/// Executes one pending job from the QuickJS job queue.
///
/// The returned integer is the raw QuickJS status code for that job.
pub fn Runtime::execute_pending_job(self : Runtime) -> Int {
  quickjs_runtime_execute_pending_job(self)
}

///|
/// Creates a new execution context owned by this runtime.
///
/// This is the usual entry point for evaluating scripts and constructing
/// JavaScript values.
pub fn Runtime::new_context(self : Runtime) -> Context {
  Context::new(self)
}
