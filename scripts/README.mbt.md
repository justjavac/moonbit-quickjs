# scripts

Maintenance scripts for this repository.

## sync_libquickjs.mbtx

Refresh vendored QuickJS artifacts from GitHub Actions.

What it updates:

- `lib/windows-x64/quickjs.lib`
- `lib/linux-x64/libquickjs.a`
- `lib/macos-universal/libquickjs.a`
- `src/quickjs.h`

Usage:

```text
moon run --target native scripts/sync_libquickjs.mbtx help
moon run --target native scripts/sync_libquickjs.mbtx
moon run --target native scripts/sync_libquickjs.mbtx --run-id 123456789
```

Notes:

- Uses the GitHub CLI `gh`
- Defaults to repository `justjavac/libquickjs`
- Defaults to the latest successful `build` workflow run
- The Linux vendored archive must be built with `-fPIC`, because downstream
  examples and path dependencies may link `justjavac/quickjs` into a shared
  object during native builds
