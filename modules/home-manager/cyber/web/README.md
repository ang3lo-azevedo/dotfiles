# Web Exploitation Tools

This module contains tools for analyzing, scanning, and exploiting web applications and web services.

## Triage & Scanning

### [Burp Suite](./scanning/burpsuite.nix)
**What it is:** Web vulnerability scanner and interception proxy.
**When to use:** You need to intercept, modify, or replay HTTP/HTTPS requests between your browser and a target web application.

### [Caido](./scanning/caido.nix)
**What it is:** A lightweight web security auditing toolkit.
**When to use:** You want a faster, Rust-based alternative to Burp Suite for HTTP interception and proxying.

### [Raccoon Scanner](./scanning/raccoon-scanner.nix)
**What it is:** High-performance offensive security tool for reconnaissance and vulnerability scanning.
**When to use:** You need to rapidly scan a web application for common misconfigurations, exposed endpoints, and basic vulnerabilities.

### [Nuclei](./scanning/nuclei.nix)
**What it is:** Fast and customizable vulnerability scanner based on simple YAML-based DSL.
**When to use:** You want to send requests across multiple targets using templates that can detect CVEs, misconfigurations, and default credentials with zero false positives.

## Directory Fuzzing & Wordlists

### [Ffuf](./fuzzing/ffuf.nix)
**What it is:** Fast web fuzzer written in Go.
**When to use:** You need to rapidly discover hidden directories, files, or subdomains on a web server by fuzzing standard URL paths or headers.

### [Gobuster](./fuzzing/gobuster.nix)
**What it is:** Directory/File, DNS and VHost busting tool written in Go.
**When to use:** An alternative to ffuf, excellent for bruteforcing URIs, DNS subdomains, and virtual host names using a given wordlist.

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
