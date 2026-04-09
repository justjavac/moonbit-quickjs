# Examples

This directory contains runnable examples for `justjavac/quickjs`.

From the repository root, you can run them with:

```text
moon -C examples run basic_eval
moon -C examples run json_bridge
moon -C examples run error_handling
moon -C examples run pending_jobs
```

## `basic_eval`

Evaluates a small JavaScript expression and prints the result.

## `json_bridge`

Creates JavaScript values from MoonBit, reads properties back, and serializes
the result with `JSON.stringify`.

## `error_handling`

Shows how to detect evaluation failures and read the pending exception message.

## `pending_jobs`

Shows how to schedule a Promise callback and drive the QuickJS job queue from
MoonBit.
