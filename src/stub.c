#include <limits.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "moonbit.h"
#include "quickjs.h"

typedef struct {
  JSRuntime *runtime;
} moonbit_quickjs_runtime_t;

typedef struct {
  JSContext *context;
  moonbit_quickjs_runtime_t *runtime_owner;
} moonbit_quickjs_context_t;

typedef struct {
  JSValue value;
  moonbit_quickjs_runtime_t *runtime_owner;
} moonbit_quickjs_value_t;

static JSRuntime *moonbit_quickjs_require_runtime(
  moonbit_quickjs_runtime_t *runtime
) {
  if (runtime == NULL || runtime->runtime == NULL) {
    abort();
  }
  return runtime->runtime;
}

static JSContext *moonbit_quickjs_require_context(
  moonbit_quickjs_context_t *context
) {
  if (context == NULL || context->context == NULL) {
    abort();
  }
  return context->context;
}

static moonbit_quickjs_runtime_t *moonbit_quickjs_require_runtime_owner(
  moonbit_quickjs_value_t *value
) {
  if (value == NULL || value->runtime_owner == NULL) {
    abort();
  }
  return value->runtime_owner;
}

static JSValueConst moonbit_quickjs_require_value(
  moonbit_quickjs_value_t *value
) {
  if (value == NULL) {
    abort();
  }
  return value->value;
}

static moonbit_bytes_t moonbit_quickjs_copy_cstring_len(
  const char *str,
  size_t len
) {
  moonbit_bytes_t bytes;

  if (len > (size_t)(INT32_MAX - 1)) {
    abort();
  }

  bytes = moonbit_make_bytes_raw((int32_t)(len + 1));
  if (len != 0) {
    memcpy(bytes, str, len);
  }
  bytes[len] = '\0';
  return bytes;
}

static moonbit_bytes_t moonbit_quickjs_value_to_bytes(
  JSContext *context,
  JSValueConst value
) {
  const char *text;
  size_t len = 0;
  moonbit_bytes_t bytes;

  text = JS_ToCStringLen2(context, &len, value, 0);
  if (text == NULL) {
    return moonbit_quickjs_copy_cstring_len("", 0);
  }

  bytes = moonbit_quickjs_copy_cstring_len(text, len);
  JS_FreeCString(context, text);
  return bytes;
}

static void moonbit_quickjs_runtime_finalize(void *self) {
  moonbit_quickjs_runtime_t *runtime = self;

  if (runtime->runtime != NULL) {
    JS_FreeRuntime(runtime->runtime);
    runtime->runtime = NULL;
  }
}

static void moonbit_quickjs_context_finalize(void *self) {
  moonbit_quickjs_context_t *context = self;

  if (context->context != NULL && context->runtime_owner != NULL &&
      context->runtime_owner->runtime != NULL) {
    JS_FreeContext(context->context);
  }
  context->context = NULL;
  if (context->runtime_owner != NULL) {
    moonbit_decref(context->runtime_owner);
    context->runtime_owner = NULL;
  }
}

static void moonbit_quickjs_value_finalize(void *self) {
  moonbit_quickjs_value_t *value = self;

  if (value->runtime_owner != NULL && value->runtime_owner->runtime != NULL) {
    JS_FreeValueRT(value->runtime_owner->runtime, value->value);
  }
  value->value = JS_UNDEFINED;
  if (value->runtime_owner != NULL) {
    moonbit_decref(value->runtime_owner);
    value->runtime_owner = NULL;
  }
}

static moonbit_quickjs_runtime_t *moonbit_quickjs_make_runtime(JSRuntime *runtime) {
  moonbit_quickjs_runtime_t *wrapped;

  if (runtime == NULL) {
    abort();
  }

  wrapped = moonbit_make_external_object(
    moonbit_quickjs_runtime_finalize,
    sizeof(moonbit_quickjs_runtime_t)
  );
  wrapped->runtime = runtime;
  return wrapped;
}

static moonbit_quickjs_context_t *moonbit_quickjs_make_context(
  JSContext *context,
  moonbit_quickjs_runtime_t *runtime_owner
) {
  moonbit_quickjs_context_t *wrapped;

  if (context == NULL || runtime_owner == NULL) {
    abort();
  }

  wrapped = moonbit_make_external_object(
    moonbit_quickjs_context_finalize,
    sizeof(moonbit_quickjs_context_t)
  );
  wrapped->context = context;
  wrapped->runtime_owner = runtime_owner;
  moonbit_incref(runtime_owner);
  return wrapped;
}

static moonbit_quickjs_value_t *moonbit_quickjs_make_value(
  JSValue value,
  moonbit_quickjs_runtime_t *runtime_owner
) {
  moonbit_quickjs_value_t *wrapped;

  if (runtime_owner == NULL) {
    abort();
  }

  wrapped = moonbit_make_external_object(
    moonbit_quickjs_value_finalize,
    sizeof(moonbit_quickjs_value_t)
  );
  wrapped->value = value;
  wrapped->runtime_owner = runtime_owner;
  moonbit_incref(runtime_owner);
  return wrapped;
}

MOONBIT_FFI_EXPORT moonbit_quickjs_runtime_t *moonbit_quickjs_runtime_new(void) {
  return moonbit_quickjs_make_runtime(JS_NewRuntime());
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_destroy(
  moonbit_quickjs_runtime_t *runtime
) {
  moonbit_quickjs_runtime_finalize(runtime);
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_set_info(
  moonbit_quickjs_runtime_t *runtime,
  const char *info
) {
  JS_SetRuntimeInfo(moonbit_quickjs_require_runtime(runtime), info);
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_set_memory_limit(
  moonbit_quickjs_runtime_t *runtime,
  uint64_t limit
) {
  JS_SetMemoryLimit(moonbit_quickjs_require_runtime(runtime), (size_t)limit);
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_set_gc_threshold(
  moonbit_quickjs_runtime_t *runtime,
  uint64_t threshold
) {
  JS_SetGCThreshold(moonbit_quickjs_require_runtime(runtime), (size_t)threshold);
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_set_max_stack_size(
  moonbit_quickjs_runtime_t *runtime,
  uint64_t stack_size
) {
  JS_SetMaxStackSize(moonbit_quickjs_require_runtime(runtime), (size_t)stack_size);
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_update_stack_top(
  moonbit_quickjs_runtime_t *runtime
) {
  JS_UpdateStackTop(moonbit_quickjs_require_runtime(runtime));
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_set_can_block(
  moonbit_quickjs_runtime_t *runtime,
  int32_t can_block
) {
  JS_SetCanBlock(moonbit_quickjs_require_runtime(runtime), can_block);
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_run_gc(
  moonbit_quickjs_runtime_t *runtime
) {
  JS_RunGC(moonbit_quickjs_require_runtime(runtime));
  return 0;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_is_job_pending(
  moonbit_quickjs_runtime_t *runtime
) {
  return JS_IsJobPending(moonbit_quickjs_require_runtime(runtime));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_runtime_execute_pending_job(
  moonbit_quickjs_runtime_t *runtime
) {
  return JS_ExecutePendingJob(moonbit_quickjs_require_runtime(runtime), NULL);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_context_t *moonbit_quickjs_context_new(
  moonbit_quickjs_runtime_t *runtime
) {
  JSRuntime *rt = moonbit_quickjs_require_runtime(runtime);
  return moonbit_quickjs_make_context(JS_NewContext(rt), runtime);
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_context_destroy(
  moonbit_quickjs_context_t *context
) {
  moonbit_quickjs_context_finalize(context);
  return 0;
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_eval(
  moonbit_quickjs_context_t *context,
  const char *code,
  const char *filename,
  int32_t flags
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  JSValue value = JS_Eval(ctx, code, strlen(code), filename, flags);
  return moonbit_quickjs_make_value(value, context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_get_global_object(
  moonbit_quickjs_context_t *context
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_GetGlobalObject(ctx), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_get_exception(
  moonbit_quickjs_context_t *context
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_GetException(ctx), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_quickjs_context_exception_message(
  moonbit_quickjs_context_t *context
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  JSValue exception = JS_GetException(ctx);
  moonbit_bytes_t bytes = moonbit_quickjs_value_to_bytes(ctx, exception);
  JS_FreeValue(ctx, exception);
  return bytes;
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_object(
  moonbit_quickjs_context_t *context
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_NewObject(ctx), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_array(
  moonbit_quickjs_context_t *context
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_NewArray(ctx), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_string(
  moonbit_quickjs_context_t *context,
  const char *text
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_NewString(ctx, text), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_int32(
  moonbit_quickjs_context_t *context,
  int32_t value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_NewInt32(ctx, value), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_float64(
  moonbit_quickjs_context_t *context,
  double value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_NewFloat64(ctx, value), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_bool(
  moonbit_quickjs_context_t *context,
  int32_t value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_NewBool(ctx, value), context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_null(
  moonbit_quickjs_context_t *context
) {
  moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_NULL, context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_new_undefined(
  moonbit_quickjs_context_t *context
) {
  moonbit_quickjs_require_context(context);
  return moonbit_quickjs_make_value(JS_UNDEFINED, context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_parse_json(
  moonbit_quickjs_context_t *context,
  const char *text,
  const char *filename
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  JSValue value = JS_ParseJSON(ctx, text, strlen(text), filename);
  return moonbit_quickjs_make_value(value, context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_context_json_stringify(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  JSValue stringified = JS_JSONStringify(
    ctx,
    moonbit_quickjs_require_value(value),
    JS_UNDEFINED,
    JS_UNDEFINED
  );
  return moonbit_quickjs_make_value(stringified, context->runtime_owner);
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_value_get_property_str(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *target,
  const char *name
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  JSValue property = JS_GetPropertyStr(
    ctx,
    moonbit_quickjs_require_value(target),
    name
  );
  return moonbit_quickjs_make_value(property, context->runtime_owner);
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_set_property_str(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *target,
  const char *name,
  moonbit_quickjs_value_t *property
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return JS_SetPropertyStr(
    ctx,
    moonbit_quickjs_require_value(target),
    name,
    JS_DupValue(ctx, moonbit_quickjs_require_value(property))
  );
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_value_get_property_uint32(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *target,
  uint32_t index
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  JSValue property = JS_GetPropertyUint32(
    ctx,
    moonbit_quickjs_require_value(target),
    index
  );
  return moonbit_quickjs_make_value(property, context->runtime_owner);
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_set_property_uint32(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *target,
  uint32_t index,
  moonbit_quickjs_value_t *property
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return JS_SetPropertyUint32(
    ctx,
    moonbit_quickjs_require_value(target),
    index,
    JS_DupValue(ctx, moonbit_quickjs_require_value(property))
  );
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_destroy(
  moonbit_quickjs_value_t *value
) {
  moonbit_quickjs_value_finalize(value);
  return 0;
}

MOONBIT_FFI_EXPORT moonbit_quickjs_value_t *moonbit_quickjs_value_dup(
  moonbit_quickjs_value_t *value
) {
  moonbit_quickjs_runtime_t *runtime_owner =
    moonbit_quickjs_require_runtime_owner(value);
  JSRuntime *runtime = moonbit_quickjs_require_runtime(runtime_owner);
  return moonbit_quickjs_make_value(
    JS_DupValueRT(runtime, value->value),
    runtime_owner
  );
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_is_exception(
  moonbit_quickjs_value_t *value
) {
  return JS_IsException(moonbit_quickjs_require_value(value));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_is_null(
  moonbit_quickjs_value_t *value
) {
  return JS_IsNull(moonbit_quickjs_require_value(value));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_is_undefined(
  moonbit_quickjs_value_t *value
) {
  return JS_IsUndefined(moonbit_quickjs_require_value(value));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_is_bool(
  moonbit_quickjs_value_t *value
) {
  return JS_IsBool(moonbit_quickjs_require_value(value));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_is_number(
  moonbit_quickjs_value_t *value
) {
  return JS_IsNumber(moonbit_quickjs_require_value(value));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_is_string(
  moonbit_quickjs_value_t *value
) {
  return JS_IsString(moonbit_quickjs_require_value(value));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_is_object(
  moonbit_quickjs_value_t *value
) {
  return JS_IsObject(moonbit_quickjs_require_value(value));
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_to_int32(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  int32_t result = 0;
  JS_ToInt32(ctx, &result, moonbit_quickjs_require_value(value));
  return result;
}

MOONBIT_FFI_EXPORT double moonbit_quickjs_value_to_float64(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  double result = 0.0;
  JS_ToFloat64(ctx, &result, moonbit_quickjs_require_value(value));
  return result;
}

MOONBIT_FFI_EXPORT int32_t moonbit_quickjs_value_to_bool(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return JS_ToBool(ctx, moonbit_quickjs_require_value(value)) > 0;
}

MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_quickjs_value_to_string_lossy(
  moonbit_quickjs_context_t *context,
  moonbit_quickjs_value_t *value
) {
  JSContext *ctx = moonbit_quickjs_require_context(context);
  return moonbit_quickjs_value_to_bytes(ctx, moonbit_quickjs_require_value(value));
}
