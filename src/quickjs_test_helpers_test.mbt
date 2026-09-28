///|
/// Fails the current test if the value is an exception.
fn guard_success(
  context : @quickjs.Context,
  value : @quickjs.Value,
  action : String,
) -> Unit raise {
  guard !value.is_exception() else {
    let message = context.exception_message()
    value.destroy()
    fail(action + ": " + message)
  }
}

///|
/// Fails the current test if a property write reported an error.
fn guard_property_status(
  context : @quickjs.Context,
  status : Int,
  action : String,
) -> Unit raise {
  guard status >= 0 else { fail(action + ": " + context.exception_message()) }
}
