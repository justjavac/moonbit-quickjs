name = "justjavac/quickjs_examples"

version = "0.1.0"

import {
  "justjavac/quickjs@0.1.4",
}

readme = "README.md"

repository = "https://github.com/justjavac/moonbit-quickjs/tree/main/examples"

license = "MIT"

keywords = [ "quickjs", "examples", "ffi", "native" ]

description = "Runnable examples for justjavac/quickjs."

preferred_target = "native"

supported_targets = "+native"

options(
  source: ".",
)
