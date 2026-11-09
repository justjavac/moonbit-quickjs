name = "justjavac/quickjs"

version = "0.2.0"

readme = "README.mbt.md"

import {
  "moonbit-community/ffi@0.1.14",
}

repository = "https://github.com/justjavac/moonbit-quickjs"

license = "MIT"

keywords = [ "quickjs", "javascript", "ffi", "native" ]

description = "MoonBit bindings for the QuickJS JavaScript engine."

warnings = ""

preferred_target = "native"

source = "src"

options(
  supported_targets: "+native",
)
