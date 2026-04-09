#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

function nativeLinkPath(filePath) {
  if (process.platform !== "win32") {
    return filePath;
  }
  return filePath.replace(/\\/g, "/");
}

function requireFile(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Missing vendored native library: ${filePath}`);
  }
  return filePath;
}

function main() {
  const payload = JSON.parse(fs.readFileSync(0, "utf8"));
  const env = payload.env ?? {};
  const isWindows = process.platform === "win32" || env.OS === "Windows_NT";
  const rootDir = path.dirname(fileURLToPath(import.meta.url));
  const vendoredLibDir = path.join(rootDir, "lib");

  if (isWindows) {
    const platformLibDir = nativeLinkPath(path.join(vendoredLibDir, "windows-x64"));
    requireFile(path.join(vendoredLibDir, "windows-x64", "quickjs.lib"));
    const quickjsStaticLib = nativeLinkPath(path.join(platformLibDir, "quickjs"));
    process.stdout.write(JSON.stringify({
      vars: {
        CC: "cl",
        STUB_CC: "cl",
      },
      link_configs: [
        {
          package: "justjavac/quickjs",
          link_libs: [quickjsStaticLib],
        },
      ],
    }));
    return;
  }

  if (process.platform === "darwin") {
    const platformLibDir = nativeLinkPath(path.join(vendoredLibDir, "macos-universal"));
    requireFile(path.join(vendoredLibDir, "macos-universal", "libquickjs.a"));
    process.stdout.write(JSON.stringify({
      vars: {
        CC: "clang",
        STUB_CC: "clang",
      },
      link_configs: [
        {
          package: "justjavac/quickjs",
          link_search_paths: [platformLibDir],
          link_libs: ["quickjs"],
        },
      ],
    }));
    return;
  }

  const platformLibDir = nativeLinkPath(path.join(vendoredLibDir, "linux-x64"));
  requireFile(path.join(vendoredLibDir, "linux-x64", "libquickjs.a"));
  process.stdout.write(JSON.stringify({
    vars: {
      CC: "gcc",
      STUB_CC: "gcc",
    },
    link_configs: [
      {
        package: "justjavac/quickjs",
        link_search_paths: [platformLibDir],
        link_libs: ["quickjs"],
        link_flags: "-lm",
      },
    ],
  }));
}

main();
