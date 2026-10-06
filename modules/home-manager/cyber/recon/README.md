# Reconnaissance Tools

This module contains tools for passive and active reconnaissance: enumerating subdomains, hosts, ports, and public information about a target.

## Asset Discovery

### [subfinder](./subfinder.nix)
**What it is:** Passive subdomain enumeration tool from ProjectDiscovery.
**When to use:** You have a root domain and want to collect its subdomains from public sources (certificate logs, passive DNS, search engines) without touching the target.
**How to run:** `subfinder -d example.com`

### [httpx](./httpx.nix)
**What it is:** Fast multi-purpose HTTP probing toolkit from ProjectDiscovery.
**When to use:** You have a list of hosts or subdomains and want to find which are alive, their status codes, titles, and technologies.
**How to run:** `subfinder -d example.com | httpx -title -status-code -tech-detect`

### [naabu](./naabu.nix)
**What it is:** Fast SYN/CONNECT port scanner from ProjectDiscovery.
**When to use:** You want a quick port sweep across many hosts before handing the open ports to a deeper scanner like nmap.
**How to run:** `naabu -host example.com -top-ports 1000`

### [katana](./katana.nix)
**What it is:** Next-generation web crawler and spider from ProjectDiscovery.
**When to use:** You want to map a site's URLs, endpoints, and JavaScript references to feed into fuzzers or scanners.
**How to run:** `katana -u https://example.com`

## OSINT & Frameworks

### [theHarvester](./theharvester.nix)
**What it is:** Gathers emails, subdomains, hosts, and names from public sources.
**When to use:** Early OSINT on an organization: collect its exposed emails and hostnames from search engines and data sources.
**How to run:** `theHarvester -d example.com -b all`

### [Recon-ng](./recon-ng.nix)
**What it is:** Full-featured, modular web reconnaissance framework with a Metasploit-like workflow.
**When to use:** You want to run and chain many recon modules (API-backed lookups, breach data, DNS) against a target in one managed workspace.
**How to run:** `recon-ng`
