# Comprehensive Forensics Toolkit Guide

## Triage & Analysis ([triage/](./triage/))

### [SO-CRATES](./triage/so-crates.nix)
**What it is:** A containerized web UI for rapid, cross-platform analysis of forensic artifacts.
**When to use:** You have PCAPs, binary malware files, or system logs and need a visual, unified interface to analyze them against Suricata, YARA, and Sigma rules. Perfect for multi-artifact incidents.
**How to run:** Drop files in `~/socrates-data` and run `so-crates`.

## Windows Forensics ([windows/](./windows/))

### [Chainsaw](./windows/triage/chainsaw.nix)
**What it is:** An extremely fast Sigma-rule matching engine for Windows Event Logs.
**When to use:** You need to rapidly scan a massive directory of `.evtx` files for known threat signatures (SigmaHQ).
**How to run:** `chainsaw-hunt <target-path>`

### [Hayabusa](./windows/triage/hayabusa.nix)
**What it is:** A timeline generator and threat hunting tool for Windows logs.
**When to use:** You need to generate a chronological timeline (CSV/HTML) of an attack or system events for deep-dive host forensics rather than just triggering alerts.
**How to run:** `hayabusa help`

### [SysmonTools](./windows/triage/sysmontools.nix)
**What it is:** GUI utilities for configuring and analyzing Microsoft Sysmon.
**When to use:** You are dealing explicitly with Sysmon EVTX logs and want to visually explore process execution trees and network connections.

### [EVTX](./windows/evtx/evtx.nix)
**What it is:** CLI utilities (like `evtx_dump`) for parsing EVTX files.
**When to use:** You need to convert an `.evtx` file to XML or JSON programmatically to feed it into another script.

### [Registry-Spy](./windows/registry/registry-spy.nix)
**What it is:** A Python-based GUI tool for parsing offline Windows Registry hives.
**When to use:** You have extracted `NTUSER.DAT`, `SYSTEM`, `SOFTWARE`, etc., and need to explore the registry keys offline.

### [EDB Tools](./windows/edb/)
**What it is:** Tools for parsing Extensible Storage Engine (ESE / EDB) databases (e.g., `libesedb`, `ese-database-view`, `sidr`).
**When to use:** You need to extract data from Windows Search index, Active Directory `ntds.dit`, or Exchange databases.

### [libfsntfs](./windows/libfsntfs.nix)
**What it is:** Library and tools for parsing NTFS file systems.
**When to use:** You are doing raw disk analysis on an NTFS image and need to parse the MFT (Master File Table) or other NTFS structures.

### [Impacket](./windows/impacket.nix)
**What it is:** Collection of Python classes for working with network protocols (especially Windows protocols like SMB, MSRPC). Includes tools like `secretsdump.py`.
**When to use:** You are doing Windows Active Directory lateral movement analysis, extracting hashes or registry hives directly from memory via LSASS dumps, or interacting directly with SMB shares.

## Memory Forensics ([memory/](./memory/))

### [Volatility 2 & 3](./memory/)
**What it is:** The industry-standard memory forensics frameworks.
**When to use:** You have a raw RAM dump (`.raw`, `.mem`) and need to extract running processes, network connections, loaded DLLs, or injected malware. Volatility 3 is faster and uses symbol tables; Volatility 2 is better for older plugins.

### [MemProcFS](./memory/memprocfs.nix)
**What it is:** Maps physical memory dumps to a virtual file system.
**When to use:** You want to browse a RAM dump like a regular folder (e.g., just `cat` a process's memory or see all network connections as files in a directory).

### [bulk_extractor](./memory/bulk_extractor.nix)
**What it is:** Extremely fast bulk data extraction tool.
**When to use:** You have a memory dump (or disk image) and just want to extract every email address, URL, IP address, or credit card number without parsing the OS structures.

### [Evolve](./memory/evolve.nix)
**What it is:** Web interface for Volatility.
**When to use:** You prefer using a GUI to browse Volatility outputs and query memory images.

## File & Disk Forensics ([files/](./files/))

### [Autopsy & Sleuthkit](./files/)
**What it is:** The complete disk forensics platform.
**When to use:** You have a full raw disk image (`.dd`, `.E01`) or logical partition and need to analyze file systems, recover deleted files, search by keywords, or generate forensic case reports.

### [TestDisk](./files/testdisk.nix)
**What it is:** Data recovery utility.
**When to use:** A partition table is corrupted, a partition was accidentally deleted, or you need to carve/undelete files.

### [analyzeMFT](./files/analyzeMFT.nix)
**What it is:** Tool to parse the NTFS Master File Table.
**When to use:** You extracted `$MFT` from a Windows drive and need a timeline of file creation, modification, and deletion.

### [ExifTool](./files/exiftool.nix)
**What it is:** Metadata parser.
**When to use:** You need to extract hidden metadata (GPS, camera info, author, creation date) from images, PDFs, and documents.

### [PDF Tools](./files/pdf/)
**What it is:** PDF analysis and cracking tools.
**When to use:** You need to brute-force a password-protected PDF or extract images/text streams from malicious PDFs.

## Steganography ([steg/](./steg/))

### [Steghide](./steg/steghide.nix)
**What it is:** Hides/extracts data inside images and audio.
**When to use:** You suspect data is hidden in a JPEG or WAV file and you have a passphrase.

### [Zsteg](./steg/zsteg.nix)
**What it is:** Detects hidden data in PNG and BMP.
**When to use:** You are doing a CTF challenge and need to check a lossless image (PNG/BMP) for LSB (Least Significant Bit) steganography or hidden payloads.

### [Binwalk & Unblob](./steg/binwalk.nix)
**What it is:** Firmware extraction tools.
**When to use:** You have an opaque binary blob or firmware image and need to extract hidden filesystems, compressed archives, or embedded images from inside it.

### [Sonic Visualiser](./steg/sonic-visualiser.nix)
**What it is:** Audio spectrogram viewer.
**When to use:** You are investigating a suspicious audio file and need to look for hidden messages or images drawn in the frequency spectrogram.

### [SSTV](./steg/sstv.nix)
**What it is:** Slow Scan Television decoder.
**When to use:** You have an audio file that sounds like weird robotic fax noises and you need to decode it into an image.

## Network Forensics ([net/](./net/))

### [Nmap](./net/nmap.nix)
**What it is:** The premier network scanner.
**When to use:** You need to discover hosts, open ports, and running services on a network segment.

### [Bettercap](./net/bettercap.nix)
**What it is:** Network attack and monitoring framework.
**When to use:** You are simulating network attacks (MITM, ARP spoofing) or sniffing active local network traffic for analysis.

### [NetworkMiner](./net/networkminer.nix)
**What it is:** Network Forensic Analysis Tool (NFAT) for Windows (run via Mono/Wine) or native platforms.
**When to use:** You have a PCAP file and want to extract files, images, emails, and credentials automatically without manually carving streams in Wireshark.

## General Utilities ([utils/](./utils/))

### [Binutils](./utils/binutils.nix)
**What it is:** Standard binary tools (`strings`, `objdump`, `nm`).
**When to use:** You need to extract readable text from a compiled binary (`strings`) or look at its headers/symbols.

### [Unzip & FFmpeg](./utils/unzip.nix)
**What it is:** Archive and multimedia utilities.
**When to use:** Decompressing zip files and analyzing/converting video and audio formats.
