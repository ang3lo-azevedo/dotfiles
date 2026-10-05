# Reverse Engineering Tools

This module contains tools for disassembling, decompiling, and analyzing binaries, from native executables to Android apps, .NET assemblies, and Godot games.

## Disassemblers & Decompilers

### [Ghidra](./decompiler/ghidra.nix)
**What it is:** The NSA's open-source software reverse engineering suite, with a strong multi-architecture decompiler.
**When to use:** You need to decompile a native binary to readable pseudo-C for free, across almost any CPU architecture.
**How to run:** `ghidra`

### [IDA Pro](./ida-pro/ida-pro.nix)
**What it is:** The industry-standard interactive disassembler and decompiler.
**When to use:** You want the most mature disassembly, cross-references, and Hex-Rays decompilation for serious binary analysis.

### [IDA Chat Plugin](./ida-pro/ida-chat-plugin.nix)
**What it is:** An IDA Pro plugin that lets you ask a language model about the code you are viewing.
**When to use:** You are reversing in IDA and want quick LLM explanations, renaming suggestions, or summaries of a decompiled function.

### [Binary Ninja](./binaryninja/binaryninja.nix)
**What it is:** A modern reverse engineering platform with a clean UI and a strong Python API.
**When to use:** You want scriptable analysis and a pleasant interface as an alternative to IDA/Ghidra.

### [reverser_ai](./binaryninja/reverser_ai.nix)
**What it is:** A Binary Ninja plugin that uses local LLMs to automatically propose function names and summaries.
**When to use:** You are triaging a large binary in Binary Ninja and want AI-generated names to orient yourself faster. Installed into `~/.binaryninja/plugins`.

### [radare2](./framework/radare2.nix)
**What it is:** A complete CLI reverse engineering framework (disassembler, debugger, hex editor).
**When to use:** You want a fast, scriptable, terminal-only workflow for binary analysis and patching.
**How to run:** `r2 ./binary`

### [angr-management](./angr-management.nix)
**What it is:** The GUI frontend for the `angr` binary analysis and symbolic execution engine.
**When to use:** You want to visually drive symbolic execution, for example to solve a crackme or find an input that reaches a target block.

### [ImHex](./imhex.nix)
**What it is:** A hex editor built for reverse engineers, with a pattern language for parsing binary structures.
**When to use:** You need to inspect or document a custom/unknown file format byte by byte.

## File & Capability Analysis

### [Detect It Easy (DiE)](./detect-it-easy.nix)
**What it is:** A packer, compiler, and file-type detector.
**When to use:** You have an unknown binary and want to know how it was built or packed before opening it in a disassembler.
**How to run:** `diec ./sample` (CLI) or `die` (GUI)

### [capa](./capa.nix)
**What it is:** FLARE's tool for identifying capabilities in executables (e.g. "sends HTTP", "encrypts files").
**When to use:** You are triaging malware and want a quick list of what a sample is capable of, mapped to ATT&CK.
**How to run:** `capa ./sample`

### [FLARE FLOSS](./flare-floss.nix)
**What it is:** The FLARE Obfuscated String Solver, which automatically extracts and deobfuscates hidden strings.
**When to use:** `strings` comes up empty on a malware sample because the strings are stack-built or encoded.
**How to run:** `floss ./sample`

## Android

### [jadx](./java/jadx.nix)
**What it is:** A Dex to Java decompiler.
**When to use:** You want to read an Android app's Java source from its APK/DEX.
**How to run:** `jadx-gui app.apk`

### [apktool](./android/apktool.nix)
**What it is:** A tool to decode and rebuild APK resources and smali.
**When to use:** You need to unpack an APK's resources/manifest, patch smali, and repackage it.
**How to run:** `apktool d app.apk`

### [apk-mitm](./android/apk-mitm.nix)
**What it is:** A CLI that automatically patches APKs to allow HTTPS inspection.
**When to use:** You want to intercept an app's TLS traffic and need to strip certificate pinning first.
**How to run:** `apk-mitm app.apk`

### [QARK](./android/qark.nix)
**What it is:** The Quick Android Review Kit, which looks for security vulnerabilities in Android apps.
**When to use:** You want an automated first pass for insecure components and misconfigurations in an APK or source tree.

## .NET & Game Engines

### [dnSpy](./windows/dnspy.nix)
**What it is:** A .NET assembly debugger, decompiler, and editor.
**When to use:** You are reversing a managed Windows binary and want to read, edit, and debug its IL/C#.

### [GDRE Tools (gdsdecomp)](./decompiler/gdsdecomp.nix)
**What it is:** A recovery and decompilation toolkit for Godot engine games.
**When to use:** You want to extract assets and recover GDScript from a packed `.pck` file or a Godot-built executable.
