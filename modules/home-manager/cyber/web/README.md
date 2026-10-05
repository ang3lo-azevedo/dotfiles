# Web Exploitation Tools

This module contains tools for analyzing, scanning, and exploiting web applications and web services.

## Triage & Scanning

### [Caido](./scanning/caido.nix)
**What it is:** A lightweight web security auditing toolkit.
**When to use:** You want a faster, Rust-based alternative to Burp Suite for HTTP interception and proxying.

### [Raccoon Scanner](./scanning/raccoon-scanner.nix)
**What it is:** High-performance offensive security tool for reconnaissance and vulnerability scanning.
**When to use:** You need to rapidly scan a web application for common misconfigurations, exposed endpoints, and basic vulnerabilities.

### [Nuclei](./scanning/nuclei.nix)
**What it is:** Fast and customizable vulnerability scanner based on simple YAML-based DSL.
**When to use:** You want to send requests across multiple targets using templates that can detect CVEs, misconfigurations, and default credentials with zero false positives.

### [WhatWeb](./scanning/whatweb.nix)
**What it is:** Web technology fingerprinter.
**When to use:** You want to identify the CMS, framework, server, and libraries a site runs before choosing an attack.
**How to run:** `whatweb -a 3 https://target`

### [wafw00f](./scanning/wafw00f.nix)
**What it is:** Web application firewall detector.
**When to use:** Requests are being blocked and you want to know which WAF is in front of the target.
**How to run:** `wafw00f https://target`

### [git-dumper](./scanning/git-dumper.nix)
**What it is:** Reconstructs a git repository from an exposed `.git/` directory on a web server.
**When to use:** You find `/.git/` is reachable and want to recover the source code and history.
**How to run:** `git-dumper https://target/.git/ out/`

## Directory Fuzzing & Wordlists

### [Ffuf](./fuzzing/ffuf.nix)
**What it is:** Fast web fuzzer written in Go.
**When to use:** You need to rapidly discover hidden directories, files, or subdomains on a web server by fuzzing standard URL paths or headers.

### [Gobuster](./fuzzing/gobuster.nix)
**What it is:** Directory/File, DNS and VHost busting tool written in Go.
**When to use:** An alternative to ffuf, excellent for bruteforcing URIs, DNS subdomains, and virtual host names using a given wordlist.

### [feroxbuster](./fuzzing/feroxbuster.nix)
**What it is:** Fast recursive content discovery tool written in Rust.
**When to use:** You want recursive directory and file brute-forcing that automatically follows discovered directories, as an alternative to ffuf/gobuster.
**How to run:** `feroxbuster -u https://target -w wordlist.txt`

### [Arjun](./fuzzing/arjun.nix)
**What it is:** HTTP query and body parameter discovery tool.
**When to use:** An endpoint behaves differently with hidden parameters and you want to find their names.
**How to run:** `arjun -u https://target/endpoint`

## Exploitation

### [SQLmap](./exploitation/sqlmap.nix)
**What it is:** Automatic SQL injection and database takeover tool.
**When to use:** You have identified a potential SQL injection vulnerability in a URL parameter or POST body and want to automate the exploitation and data exfiltration process.

### [Commix](./exploitation/commix.nix)
**What it is:** Automated command injection exploitation tool.
**When to use:** You suspect an OS command injection vulnerability and need an automated way to test and exploit it to gain a reverse shell.

### [TPLmap](./exploitation/tplmap.nix)
**What it is:** Server-Side Template Injection and Code Injection detection and exploitation tool.
**When to use:** You are dealing with template engines (Jinja2, Twig, Freemarker) and want to exploit SSTI to achieve remote code execution.

### [Dalfox](./exploitation/dalfox.nix)
**What it is:** Fast parameter analysis and XSS scanner.
**When to use:** You want to test reflected and DOM parameters for cross-site scripting at scale.
**How to run:** `dalfox url https://target/search?q=1`

### [flask-unsign](./exploitation/flask-unsign.nix)
**What it is:** Tool to decode, brute-force, and craft Flask session cookies.
**When to use:** An app uses Flask's signed client-side session cookies and you want to read them or forge one once you recover the secret key.
**How to run:** `flask-unsign --decode --cookie '<cookie>'`
