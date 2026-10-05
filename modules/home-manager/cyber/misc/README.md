# Miscellaneous Tools

This module contains cross-cutting utilities that do not belong to a single category: CTF challenge downloaders, secret scanning, and a scripting environment.

## CTF Workflow

### [ctf-dl](./ctf-dl.nix)
**What it is:** A downloader that bulk-fetches challenge files from a CTF platform.
**When to use:** A competition starts and you want every challenge's attachments pulled locally in one go.

### [ctfd-parser](./ctfd-parser.nix)
**What it is:** A scraper for CTFd instances that exports challenges, descriptions, and files.
**When to use:** The event runs on CTFd and you want a local, organized copy of all challenges and their metadata.

## Scripting

### [uv-angr](./python.nix)
**What it is:** A small wrapper that runs Python with `angr` loaded on demand through `uv`, so the heavy dependency is not installed globally.
**When to use:** You want to run a quick `angr` script or an interactive symbolic-execution shell without a dedicated project environment.
**How to run:** `uv-angr script.py` or `uv-angr` for a REPL

## Secrets

### [TruffleHog](./trufflehog.nix)
**What it is:** A scanner that finds and verifies leaked credentials in git history, filesystems, and other sources.
**When to use:** You want to hunt for exposed API keys and secrets in a repository or a dump of files.
**How to run:** `trufflehog git file://./repo`
