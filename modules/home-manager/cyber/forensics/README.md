# Comprehensive Forensics Toolkit Guide

## Triage & Analysis ([triage/](./triage/))

### [SO-CRATES](./triage/so-crates.nix)
**What it is:** A containerized web UI for rapid, cross-platform analysis of forensic artifacts.
**When to use:** You have PCAPs, binary malware files, or system logs and need a visual, unified interface to analyze them against Suricata, YARA, and Sigma rules. Perfect for multi-artifact incidents.
**How to run:** Drop files in `~/socrates-data` and run `so-crates`.

### [YARA](./triage/yara.nix)
**What it is:** Pattern-matching engine that scans files and memory dumps against rules describing malware families or any byte and string pattern.
**When to use:** You have a folder of extracted files, a carved binary, or a process dump and want to know which known signatures hit, or you are writing a rule for an indicator you found.
**How to run:** `yara -r rules.yar extracted/` (add `-s` to print the matching strings)

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

### [RegRipper](./windows/registry/regripper.nix)
**What it is:** Plugin-based CLI that extracts and interprets known artifacts from offline Registry hives.
**When to use:** You want quick answers from a hive (USB history, run keys, user activity, installed software) instead of browsing keys by hand.
**How to run:** `regripper -r NTUSER.DAT -a` (all plugins that apply to the hive), or `-p <plugin>` for a single one

### [EDB Tools](./windows/edb/)
**What it is:** Tools for parsing Extensible Storage Engine (ESE / EDB) databases (e.g., `libesedb`, `ese-database-view`, `sidr`).
**When to use:** You need to extract data from Windows Search index, Active Directory `ntds.dit`, or Exchange databases.

### [libscca](./windows/prefetch/libscca.nix)
**What it is:** Library and CLI (`sccainfo`) for parsing Windows Prefetch (`.pf`) files, including the compressed Windows 10/11 format.
**When to use:** You pulled `C:\Windows\Prefetch` from an image and need evidence of execution: run count, last run times, and the files and volumes a program touched.
**How to run:** `sccainfo CMD.EXE-4A81B364.pf`

### [libfsntfs](./windows/libfsntfs.nix)
**What it is:** Library and tools for parsing NTFS file systems.
**When to use:** You are doing raw disk analysis on an NTFS image and need to parse the MFT (Master File Table) or other NTFS structures.

### [Impacket](./windows/impacket.nix)
**What it is:** Collection of Python classes for working with network protocols (especially Windows protocols like SMB, MSRPC). Includes tools like `secretsdump.py`.
**When to use:** You are doing Windows Active Directory lateral movement analysis, extracting hashes or registry hives directly from memory via LSASS dumps, or interacting directly with SMB shares.

## Memory Forensics ([memory/](./memory/))

See the [memory forensics guide](./memory/README.md) for capturing memory, symbols, the vol-rs fallback, BitLocker key recovery, and LSASS credential extraction.

### [vol-analyze](./memory/volatility-toolkit.nix)
**What it is:** Automated triage that runs 49 Volatility plugins on Windows dumps (31 on Linux), dumps files, extracts IOC strings, scans for BitLocker keys, and pulls credentials from LSASS with pypykatz.
**When to use:** First pass on any RAM dump, before digging in by hand.
**How to run:** `vol-analyze memory.raw --dump-files --extract-strings`

### [Volatility 2 & 3](./memory/)
**What it is:** The industry-standard memory forensics frameworks.
**When to use:** You have a raw RAM dump (`.raw`, `.mem`) and need to extract running processes, network connections, loaded DLLs, or injected malware. Volatility 3 is faster and uses symbol tables; Volatility 2 is better for older plugins.
**How to run:** `vol` (vol-rs with Volatility 3 fallback), `volatility`/`vol3` for Volatility 3 only, `vol2` for Volatility 2.

### [vol-rs](./memory/vol-rs.nix)
**What it is:** Volatility 3 ported to Rust, with the same output and much faster.
**When to use:** Quick repeated plugin runs on Windows and Linux dumps. It cannot load Python plugins or download Linux symbols (it reuses Volatility 3's), so use it through `vol`, which falls back to Volatility 3 in those cases (see the guide).
**How to run:** `vol -f memory.raw windows.pslist`, or `vol-rs -f memory.raw windows.pslist` for vol-rs alone

### [avml](./memory/avml.nix)
**What it is:** Linux memory acquisition tool from Microsoft, no kernel module needed.
**When to use:** You need to capture the RAM of a running Linux machine for analysis.
**How to run:** `sudo avml acquire memory.lime`

### [dwarf2json](./memory/dwarf2json.nix)
**What it is:** Volatility's tool for building symbol files from a kernel with debug info.
**When to use:** Volatility 3 cannot analyze a Linux dump because its kernel is not in the online symbol index, e.g. custom kernels like CachyOS.
**How to run:** `dwarf2json linux --elf vmlinux | xz > kernel.json.xz` (see the [guide](./memory/README.md#missing-linux-symbols))

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

### [TestDisk](./files/testdisk.nix)
**What it is:** Data recovery utility.
**When to use:** You have a full raw disk image (`.dd`, `.E01`) or logical partition and need to analyze file systems, recover deleted files, search by keywords, or generate forensic case reports. It is also used when a partition table is corrupted, a partition was accidentally deleted, or you need to carve files.

### [Autopsy & Sleuthkit](./files/)
**What it is:** The complete disk forensics platform.
**When to use:** You have a full raw disk image (`.dd`, `.E01`) or logical partition and need to analyze file systems, recover deleted files, search by keywords, or generate forensic case reports.

### [libewf](./files/libewf.nix)
**What it is:** Library and tools for EnCase / Expert Witness (`.E01`, `.Ex01`) evidence images.
**When to use:** You were handed an `.E01` and need to check it, read its acquisition metadata, or expose it as a raw image that `mount`, Sleuthkit, or any other tool can open.
**How to run:** `ewfinfo image.E01`, `ewfverify image.E01`, then `ewfmount image.E01 /mnt/ewf` and work on `/mnt/ewf/ewf1`

### [libguestfs](./files/libguestfs.nix)
**What it is:** Tools for reading virtual machine disks (`.vmdk`, `.vhdx`, `.qcow2`, `.vdi`) without booting them.
**When to use:** The evidence is a VM disk and you want its file system mounted read-only, or a quick listing of what it holds.
**How to run:** `guestmount -a disk.vmdk -i --ro /mnt/vm` (`guestunmount /mnt/vm` when done), or `guestfish --ro -a disk.vmdk -i` for a shell inside the image

### [Dislocker](./files/dislocker.nix)
**What it is:** BitLocker volume decryptor for Linux.
**When to use:** A Windows disk image or partition is BitLocker-encrypted and you have the recovery key, user password, or a `.bek` file.
**How to run:** `dislocker -V /dev/sdX1 -p<recovery-key> -- /mnt/dislocker` then `mount -o loop,ro /mnt/dislocker/dislocker-file /mnt/win`

### [analyzeMFT](./files/analyzeMFT.nix)
**What it is:** Tool to parse the NTFS Master File Table.
**When to use:** You extracted `$MFT` from a Windows drive and need a timeline of file creation, modification, and deletion.
**How to run:** `analyzemft -f '$MFT' -o mft.csv` (or `--json`, `--body` for mactime, `--l2t` for log2timeline)

### [ExifTool](./files/exiftool.nix)
**What it is:** Metadata parser.
**When to use:** You need to extract hidden metadata (GPS, camera info, author, creation date) from images, PDFs, and documents.

### [PDF Tools](./files/pdf/)
**What it is:** PDF analysis and cracking tools.
**When to use:** You need to brute-force a password-protected PDF or extract images/text streams from malicious PDFs.

### [oletools](./files/oletools.nix)
**What it is:** Analysis tools for Microsoft Office and OLE2 files: `olevba` extracts and deobfuscates VBA macros, `oleid` flags risky features, `rtfobj` and `oleobj` pull out embedded objects.
**When to use:** You have a suspicious `.doc`, `.xlsm`, `.rtf`, or similar and need the macro source, the auto-exec triggers, or the embedded payload.
**How to run:** `oleid file.docm`, then `olevba --decode file.docm`

### [libpff](./files/libpff.nix)
**What it is:** Library and tools for Outlook `.pst` and `.ost` mailboxes.
**When to use:** You recovered a mailbox and need its messages, attachments, and deleted items as plain files.
**How to run:** `pffexport -m all mailbox.pst` (writes `mailbox.pst.export/`, plus `.recovered/` for deleted items)

### [Scalpel](./files/scalpel.nix)
**What it is:** File carver that recovers files by their headers and footers.
**When to use:** The file system is damaged or missing, or you want to carve specific file types out of a raw image or unallocated space.
**How to run:** `scalpel -c scalpel.conf -o out/ image.dd` (uncomment the wanted file types in a copy of the config first)

### [bkcrack](./files/bkcrack.nix)
**What it is:** Known-plaintext attack on legacy ZipCrypto archives.
**When to use:** A zip is encrypted with ZipCrypto (not AES) and you know at least 12 bytes of one of its files, e.g. a file header or a file you also have in clear.
**How to run:** `bkcrack -C enc.zip -c file.png -p known.bin`

### [pdfid & pdf-parser](./files/pdf/)
**What it is:** Didier Stevens' PDF triage tools: `pdfid` counts suspicious keywords, `pdf-parser.py` walks the objects and streams.
**When to use:** You have a suspicious PDF and want to see if it carries JavaScript, auto-open actions, or embedded files, then dump the offending object.
**How to run:** `pdfid file.pdf`, then `pdf-parser.py --search javascript file.pdf`

## Steganography ([steg/](./steg/))

### [Steghide](./steg/steghide.nix)
**What it is:** Hides/extracts data inside images and audio.
**When to use:** You suspect data is hidden in a JPEG or WAV file and you have a passphrase.

### [Zsteg](./steg/zsteg.nix)
**What it is:** Detects hidden data in PNG and BMP.
**When to use:** You are doing a CTF challenge and need to check a lossless image (PNG/BMP) for LSB (Least Significant Bit) steganography or hidden payloads.

### [Stegseek](./steg/stegseek.nix)
**What it is:** Very fast steghide passphrase cracker.
**When to use:** You suspect steghide was used but do not have the passphrase. It runs through rockyou in seconds.
**How to run:** `stegseek image.jpg wordlist.txt`

### [OutGuess](./steg/outguess.nix)
**What it is:** Hides/extracts data in the redundant bits of JPEG images.
**When to use:** Steghide finds nothing in a JPEG and the challenge hints at OutGuess.
**How to run:** `outguess -r image.jpg out.txt` (add `-k <key>` if a key was used)

### [Stegsolve](./steg/stegsolve.nix)
**What it is:** GUI image analyzer that flips through bit planes, color channels, and frame combinations.
**When to use:** You want to look for hidden content by eye: a message in one bit plane or the alpha channel, or the difference between two images.
**How to run:** `stegsolve`

### [pngcheck](./steg/pngcheck.nix)
**What it is:** Verifies PNG integrity and lists its chunks.
**When to use:** A PNG will not open or looks truncated, and you need to find the broken CRC, wrong dimensions, or extra data after `IEND`.
**How to run:** `pngcheck -v image.png`

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

### [Zeek](./net/zeek.nix)
**What it is:** Network analysis framework that turns a capture into structured logs (`conn.log`, `dns.log`, `http.log`, `files.log`, ...).
**When to use:** The PCAP is too large to click through in Wireshark and you want to query connections, DNS, and HTTP as tables, or extract every transferred file.
**How to run:** `zeek -C -r capture.pcap` in an empty directory, then `zeek-cut id.orig_h id.resp_h query < dns.log`

## General Utilities ([utils/](./utils/))

### [Binutils](./utils/binutils.nix)
**What it is:** Standard binary tools (`strings`, `objdump`, `nm`).
**When to use:** You need to extract readable text from a compiled binary (`strings`) or look at its headers/symbols.

### [Unzip & FFmpeg](./utils/unzip.nix)
**What it is:** Archive and multimedia utilities.
**When to use:** Decompressing zip files and analyzing/converting video and audio formats.

### [VisiData](./utils/visidata.nix)
**What it is:** Terminal spreadsheet for large CSV, JSON, and SQLite files.
**When to use:** A tool produced a timeline with hundreds of thousands of rows (Hayabusa, analyzeMFT, Volatility) and you need to sort, filter, and pivot it without a GUI.
**How to run:** `vd timeline.csv` (`[` / `]` sort, `|` select by regex, `"` open selected rows, `Shift+F` frequency table)
