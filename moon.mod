name = "justjavac/quickjs"

version = "0.1.4"

readme = "README.mbt.md"

import {
  "justjavac/ffi@0.2.3",
}

repository = "https://github.com/justjavac/moonbit-quickjs"

license = "MIT"

keywords = [ "quickjs", "javascript", "ffi", "native" ]

description = "MoonBit bindings for the QuickJS JavaScript engine."

warnings = ""

preferred_target = "native"

options(
  source: "src",
  supported_targets: "+native",
  "--moonbit-unstable-prebuild": "native_link_config.mjs",
)
