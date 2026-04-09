///|
test "runtime settings and pending jobs" {
  let runtime = Runtime::new()
  defer runtime.destroy()
  let context = runtime.new_context()
  defer context.destroy()

  runtime.set_info("moonbit-quickjs tests")
  runtime.set_memory_limit(UInt64::extend_uint(64000000U))
  runtime.set_gc_threshold(UInt64::extend_uint(8000000U))
  runtime.set_max_stack_size(UInt64::extend_uint(1000000U))
  runtime.update_stack_top()
  runtime.set_can_block(false)
  runtime.set_can_block(true)
  runtime.run_gc()

  let global = context.global_object()
  defer global.destroy()
  assert_true(global.is_object())

  let setup = context.eval(
    "globalThis.pending = 0; Promise.resolve(41).then(v => { globalThis.pending = v + 1; });",
  )
  guard_success(context, setup, "failed to schedule Promise job")
  defer setup.destroy()

  assert_true(runtime.is_job_pending())
  ignore(runtime.execute_pending_job())
  assert_false(runtime.is_job_pending())

  let result = context.eval("pending")
  guard_success(context, result, "failed to read Promise result")
  defer result.destroy()
  inspect(result.to_int32(context), content="42")
}

///|
test "context constructor is equivalent to runtime.new_context" {
  let runtime = Runtime::new()
  defer runtime.destroy()

  let context = Context::new(runtime)
  defer context.destroy()

  let value = context.eval("6 * 7")
  guard_success(context, value, "failed to evaluate multiplication")
  defer value.destroy()
  inspect(value.to_int32(context), content="42")
}
