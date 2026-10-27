# Active Directory Tools

This module contains tools for enumerating, attacking, and exploiting Microsoft Active Directory environments.

## Enumeration & Analysis

### BloodHound CE
**What it is:** Active Directory domain privilege escalation mapping tool. The legacy Electron app is dead upstream, so this is BloodHound Community Edition (SpecterOps), a web UI backed by PostgreSQL + Neo4j. It runs as a NixOS service defined in [`modules/system/services/bloodhound-ce.nix`](../../../../system/services/bloodhound-ce.nix).
**When to use:** You need to visualize the complex attack paths, permissions, and trusts in an AD environment to find the shortest path to Domain Admin.
**How to run:** `bloodhound` starts the stack on demand and opens http://localhost:8080/ (login `admin` / `BloodHoundLocal1!`), then follows the API log; Ctrl+C stops BloodHound CE and both databases. Ingest with RustHound-CE or bloodhound-python, then query from the UI or with BloodHound-QuickWin.

### [BloodHound-QuickWin](./bloodhound-quickwin.nix)
**What it is:** kaluche's `bhqc.py`, which runs a batch of Cypher queries against a BloodHound Neo4j database to surface common attack paths and quick wins.
**When to use:** You have already ingested data into BloodHound's Neo4j (e.g. with RustHound-CE) and want a fast text summary (kerberoastable users, AS-REP roasting, unconstrained delegation, passwords in descriptions, etc.) without clicking through the GUI.
**How to run:** `bloodhound-quickwin -b bolt://127.0.0.1:7687 -u neo4j -p <password>` (add `--heavy` for ACL/relationship queries)

### [Enum4linux-ng](./enum4linux-ng.nix)
**What it is:** Next generation version of enum4linux, a tool for enumerating information from Windows and Samba systems.
**When to use:** You need to rapidly enumerate users, groups, shares, and policies from a domain controller via SMB/RPC.

### [NetExec](./netexec.nix)
**What it is:** A network service exploitation tool that helps automate assessing the security of large Active Directory networks (successor to CrackMapExec).
**When to use:** You have compromised a credential/hash and want to spray it across the domain to find where you have local admin access, or you want to dump SAM/LSA secrets from remote machines en masse.

### [ldapsearch](./ldapsearch.nix)
**What it is:** The OpenLDAP command-line client for querying an LDAP/Active Directory server directly.
**When to use:** You have domain credentials (or anonymous/null access) and want to read raw directory objects: users, groups, computers, attributes like userAccountControl or servicePrincipalName, without a heavier collector.
**How to run:** `ldapsearch -x -H ldap://dc.corp.local -D user@corp.local -w pass -b "dc=corp,dc=local" "(objectClass=user)"`

### [RustHound-CE](./rusthound-ce.nix)
**What it is:** BloodHound Community Edition data collector written in Rust.
**When to use:** You have domain credentials and need to collect users, groups, ACLs, and sessions over LDAP from Linux to feed into BloodHound CE.
**How to run:** `rusthound-ce -d corp.local -u user -p pass -z`

### [SMBMap](./smbmap.nix)
**What it is:** SMB share enumerator.
**When to use:** You want to list shares and your read/write access across hosts, or search and pull files from them.
**How to run:** `smbmap -H 10.0.0.5 -u user -p pass`

### [Kerbrute](./kerbrute.nix)
**What it is:** Kerberos pre-auth tool for validating usernames and testing credentials against a domain controller.
**When to use:** You have a user list and want to find which accounts exist, without the noise of SMB logons.
**How to run:** `kerbrute userenum -d corp.local --dc 10.0.0.1 users.txt`

## Exploitation & Post-Exploitation

### [Certipy](./certipy-ad.nix)
**What it is:** Tool for Active Directory Certificate Services (AD CS) enumeration and abuse.
**When to use:** You have access to the network and want to find vulnerable certificate templates (ESC1-ESC8) to forge certificates and escalate privileges.

### [Evil-WinRM](./evil-winrm.nix)
**What it is:** The ultimate WinRM shell for hacking/pentesting.
**When to use:** You have valid credentials (or a Pass-the-Hash NTLM hash) for a Windows machine and want to get a stable, interactive command shell over Windows Remote Management (port 5985/5986).

### [Coercer](./coercer.nix)
**What it is:** Tool that coerces a Windows host to authenticate to an arbitrary target over several RPC methods.
**When to use:** You want a machine account to authenticate to a relay or capture host as part of an NTLM relay chain.
**How to run:** `coercer coerce -t 10.0.0.5 -l 10.0.0.100 -u user -p pass -d corp.local`

### [mitm6](./mitm6.nix)
**What it is:** Replies to Windows DHCPv6 requests and advertises the attacker as the DNS server.
**When to use:** You want to redirect a network's name resolution to capture or relay authentication (typically paired with ntlmrelayx).
**How to run:** `mitm6 -d corp.local`
