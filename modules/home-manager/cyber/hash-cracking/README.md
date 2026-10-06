# Hash Cracking Tools

This module contains tools for identifying and cracking password hashes. See the [wordlists module](../wordlists/README.md) for the dictionaries these tools consume.

## Identification

### [Haiti](./haiti.nix)
**What it is:** A hash type identifier that suggests the hashcat/john mode for a given hash.
**When to use:** You have an unknown hash and need to know what algorithm it is before cracking it.
**How to run:** `haiti '<hash>'`

### [hashID](./hashid.nix)
**What it is:** A classic hash type identifier covering a large set of formats, with hashcat mode output.
**When to use:** A second opinion to Haiti, or when you want its broader format database.
**How to run:** `hashid -m '<hash>'`

## Cracking

### [Hashcat](./hashcat.nix)
**What it is:** The world's fastest password recovery tool, with GPU acceleration.
**When to use:** You have a large batch of hashes and want maximum throughput using your GPU.
**How to run:** `hashcat -m 1000 hashes.txt ~/.nix-profile/share/wordlists/rockyou.txt`

### [John the Ripper](./john.nix)
**What it is:** A flexible CPU password cracker with many `*2john` helpers (zip2john, ssh2john, etc.).
**When to use:** You need to extract a crackable hash from a file (ZIP, SSH key, PDF) or want John's rule engine and auto-detection.
**How to run:** `zip2john file.zip > hash.txt && john hash.txt`
