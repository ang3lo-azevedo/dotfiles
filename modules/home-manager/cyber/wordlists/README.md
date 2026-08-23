# Global Wordlists

This module installs global wordlists that are accessible to all your cybersecurity tools, whether you are doing web fuzzing, password cracking, or directory brute-forcing.

## Tools Included

### [Wordlists](./wordlists.nix)
**What it is:** The Nix `wordlists` package bundles some of the most famous and widely used wordlists in the cybersecurity industry (like `SecLists` and `rockyou`).
**When to use:** Whenever you need to brute-force a login portal, fuzz API endpoints, or crack password hashes.

## How to use them

When you install the `wordlists` package via Home Manager or Nix, all the text files are placed inside your Nix profile's `share` directory.

You can access them from any tool using the absolute path:
```bash
~/.nix-profile/share/wordlists/
```
*(Or `/run/current-system/sw/share/wordlists/` if installed system-wide).*

### Common Examples

**1. Using Ffuf to brute-force web directories (using SecLists):**
```bash
ffuf -u http://target.thm/FUZZ -w ~/.nix-profile/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-small.txt
```

**2. Using Hashcat or John to crack hashes (using rockyou):**
```bash
hashcat -m 1000 hashes.txt ~/.nix-profile/share/wordlists/rockyou.txt
```

**3. Using Gobuster for subdomains:**
```bash
gobuster vhost -u http://target.thm -w ~/.nix-profile/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt
```
