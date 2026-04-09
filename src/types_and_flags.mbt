///|
/// Owns the underlying QuickJS runtime and scheduler state.
///
/// A `Runtime` is the root handle for every other object in this package.
/// Create one runtime first, derive one or more contexts from it, and destroy
/// the runtime after every context and value has already been released.
///
/// # Lifecycle
///
/// - Create the runtime with `Runtime::new()`
/// - Create contexts with `Runtime::new_context()`
/// - Destroy all `Value` and `Context` handles before `Runtime::destroy()`
///
/// # Example
/// ```mbt check
/// test {
///   let runtime = Runtime::new()
///   let context = runtime.new_context()
///   let result = context.eval("1 + 2")
///   inspect(result.to_int32(context), content="3")
///   result.destroy()
///   context.destroy()
///   runtime.destroy()
/// }
/// ```
#external
pub type Runtime

///|
/// Represents a QuickJS execution context created from a runtime.
///
/// Contexts hold JavaScript globals, evaluation state, and exception state.
/// Multiple contexts can share a runtime while keeping their own global object.
/// Destroy the context after every value created from it has been destroyed.
///
/// # Example
/// ```mbt check
/// test {
///   let runtime = Runtime::new()
///   let context = Context::new(runtime)
///   let value = context.eval("'moon' + 'bit'")
///   inspect(value.to_string_lossy(context), content="moonbit")
///   value.destroy()
///   context.destroy()
///   runtime.destroy()
/// }
/// ```
#external
pub type Context

///|
/// Wraps a JavaScript value produced by QuickJS.
///
/// A `Value` may represent primitives, objects, arrays, exceptions, or
/// special values such as `null` and `undefined`. Values use explicit
/// lifetime management, so call `Value::destroy()` once the handle is no
/// longer needed.
///
/// # Example
/// ```mbt check
/// test {
///   let runtime = Runtime::new()
///   let context = runtime.new_context()
///   let value = context.new_bool(true)
///   inspect(value.to_bool(context), content="true")
///   value.destroy()
///   context.destroy()
///   runtime.destroy()
/// }
/// ```
#external
pub type Value

///|
/// Evaluates code as a global script.
///
/// Use this as the default mode for ordinary snippets that should run against
/// the current context global object.
pub let eval_type_global : Int = 0

///|
/// Evaluates code as an ES module.
///
/// Combine this with module source text when you want `import` or `export`
/// syntax to be parsed by QuickJS.
pub let eval_type_module : Int = 1

///|
/// Marks the source as a direct `eval(...)` call.
///
/// This mirrors QuickJS evaluation semantics for code that should behave like
/// a direct JavaScript `eval`.
pub let eval_type_direct : Int = 2

///|
/// Marks the source as an indirect `eval(...)` call.
///
/// This is useful when you need QuickJS to apply indirect-eval scoping rules.
pub let eval_type_indirect : Int = 3

///|
/// Requests strict-mode parsing during evaluation.
///
/// Combine this flag with an evaluation type such as `eval_type_global`.
pub let eval_flag_strict : Int = 1 << 3

///|
/// Compiles the source without executing it immediately.
///
/// This is typically combined with one of the evaluation type constants.
pub let eval_flag_compile_only : Int = 1 << 5

///|
/// Prevents the current stack trace from crossing this evaluation boundary.
///
/// This can be useful when embedding QuickJS and controlling how errors are
/// surfaced back to host code.
pub let eval_flag_backtrace_barrier : Int = 1 << 6

///|
/// Enables async function and top-level async related evaluation behavior.
///
/// Use this when the evaluated source should participate in QuickJS async
/// execution semantics.
pub let eval_flag_async : Int = 1 << 7
