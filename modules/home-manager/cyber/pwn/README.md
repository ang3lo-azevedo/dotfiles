# Binary Exploitation (Pwn) Tools

This module contains tools for developing memory-corruption exploits against native binaries, the core of CTF "pwn" challenges.

## Exploit Development

### [pwndbg](./pwndbg.nix)
**What it is:** A GDB plugin that makes the debugger usable for exploit development (heap view, registers, disassembly, telescope).
**When to use:** You are stepping through a binary to understand a crash and build an exploit. The de-facto GDB setup for pwn.
**How to run:** `gdb ./binary` (pwndbg loads automatically)

### [pwninit](./pwninit.nix)
**What it is:** A tool that automates the setup of a CTF pwn challenge.
**When to use:** You are given a binary plus a `libc`/loader and want them patched together and a solve-script template generated.
**How to run:** `pwninit` in the challenge directory

## Gadget Discovery

### [ropper](./ropper.nix)
**What it is:** A tool to find ROP/JOP gadgets and build rop chains.
**When to use:** You are bypassing NX/DEP and need gadgets to construct a return-oriented programming chain.
**How to run:** `ropper -f ./binary --search "pop rdi"`

### [one_gadget](./one_gadget.nix)
**What it is:** A tool that finds single-shot `execve("/bin/sh")` gadgets inside libc.
**When to use:** You have a libc leak and a single write/jump primitive and want one address that spawns a shell.
**How to run:** `one_gadget /path/to/libc.so.6`
