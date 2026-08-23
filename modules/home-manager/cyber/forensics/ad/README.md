# Active Directory Tools

This module contains tools for enumerating, attacking, and exploiting Microsoft Active Directory environments.

## Enumeration & Analysis

### [BloodHound](./bloodhound.nix)
**What it is:** Active Directory domain privilege escalation mapping tool.
**When to use:** You need to visualize the complex attack paths, permissions, and trusts in an AD environment to find the shortest path to Domain Admin.

### [Enum4linux-ng](./enum4linux-ng.nix)
**What it is:** Next generation version of enum4linux, a tool for enumerating information from Windows and Samba systems.
**When to use:** You need to rapidly enumerate users, groups, shares, and policies from a domain controller via SMB/RPC.

### [NetExec](./netexec.nix)
**What it is:** A network service exploitation tool that helps automate assessing the security of large Active Directory networks (successor to CrackMapExec).
**When to use:** You have compromised a credential/hash and want to spray it across the domain to find where you have local admin access, or you want to dump SAM/LSA secrets from remote machines en masse.

## Exploitation & Post-Exploitation

### [Certipy](./certipy-ad.nix)
**What it is:** Tool for Active Directory Certificate Services (AD CS) enumeration and abuse.
**When to use:** You have access to the network and want to find vulnerable certificate templates (ESC1-ESC8) to forge certificates and escalate privileges.

### [Evil-WinRM](./evil-winrm.nix)
**What it is:** The ultimate WinRM shell for hacking/pentesting.
**When to use:** You have valid credentials (or a Pass-the-Hash NTLM hash) for a Windows machine and want to get a stable, interactive command shell over Windows Remote Management (port 5985/5986).
