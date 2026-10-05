# Red Team Tools

This module contains tools for offensive engagements: exploitation frameworks, network pivoting, credential theft, and local privilege escalation. Use only against systems you are authorized to test.

## Exploitation Framework

### [Metasploit](./framework/metasploit.nix)
**What it is:** The Metasploit Framework, a full exploitation platform with modules, payloads, and post-exploitation tooling.
**When to use:** You want ready-made exploits, payload generation (`msfvenom`), and a handler for catching shells.
**How to run:** `msfconsole`

## Pivoting & Tunneling

### [Chisel](./chisel.nix)
**What it is:** A fast TCP/UDP tunnel transported over HTTP and secured with SSH.
**When to use:** You have a foothold and need to tunnel or port-forward through it to reach an internal network.
**How to run:** `chisel server -p 8080 --reverse` / `chisel client <host>:8080 R:socks`

### [Ligolo-ng](./ligolo-ng.nix)
**What it is:** A tunneling tool that pivots through a lightweight TUN interface instead of SOCKS.
**When to use:** You want to reach an internal subnet as if it were routed locally, without configuring per-port forwards.

## Credential Access & Poisoning

### [Responder](./responder.nix)
**What it is:** An LLMNR, NBT-NS, and MDNS poisoner that captures hashes from Windows name resolution.
**When to use:** You are on an internal network and want to capture NetNTLM hashes by answering broadcast name-resolution requests.
**How to run:** `responder -I <interface>`

### [Mimikatz](./mimikatz.nix)
**What it is:** The classic Windows tool for extracting plaintext passwords, hashes, and Kerberos tickets from memory.
**When to use:** You have admin on a Windows host and want to dump credentials from LSASS or perform pass-the-hash / golden-ticket attacks.

## Privilege Escalation

### [pspy](./pspy.nix)
**What it is:** A tool that watches Linux processes without root privileges.
**When to use:** You have a low-privileged shell and want to spot cron jobs or other users' commands to find a privesc path.
**How to run:** `pspy64`
