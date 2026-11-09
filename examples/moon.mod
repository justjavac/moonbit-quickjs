name = "justjavac/quickjs_examples"

version = "0.1.0"

// Resolved from the workspace member (the package under development), so the
// examples exercise the QuickJS C sources compiled as native stubs.
import {
  "justjavac/quickjs@0.2.0",
}

readme = "README.md"

repository = "https://github.com/justjavac/moonbit-quickjs/tree/main/examples"

license = "MIT"

keywords = [ "quickjs", "examples", "ffi", "native" ]

description = "Runnable examples for justjavac/quickjs."

preferred_target = "native"

supported_targets = "+native"

source = "."
