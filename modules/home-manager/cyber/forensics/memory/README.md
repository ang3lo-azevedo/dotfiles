# Memory Forensics

Tools for analyzing RAM dumps (`.raw`, `.mem`, `.vmem`, `.dmp`, `.lime`).

## Commands

| Command | Tool | Defined in |
|---|---|---|
| `vol-analyze` | Automated triage, runs 49 Windows / 31 Linux plugins plus BitLocker and LSASS credential scans | [volatility-toolkit.nix](./volatility-toolkit.nix) |
| `vol` | vol-rs, falling back to Volatility 3 when it fails (the same shim `vol-analyze` uses, see [How it runs plugins](#how-it-runs-plugins)) | [volatility-toolkit.nix](./volatility-toolkit.nix) |
| `vol-rs` | [vol-rs](https://github.com/daffainfo/vol-rs), Volatility 3 ported to Rust, with no fallback | [vol-rs.nix](./vol-rs.nix) |
| `volatility`, `vol3` | Volatility 3, with [third-party plugins](#third-party-plugins) and Linux symbol auto-download | [volatility3.nix](./volatility3.nix) |
| `volshell` | Volatility 3 interactive shell | [volatility3.nix](./volatility3.nix) |
| `vol2`, `volatility2` | Volatility 2, for plugins never ported to 3 | [volatility2.nix](./volatility2.nix) |
| `avml` | Captures a running Linux machine's memory (see [Capturing memory](#capturing-memory-linux)) | [avml.nix](./avml.nix) |
| `dwarf2json` | Builds Linux symbols for kernels the online index lacks (see [Missing Linux symbols](#missing-linux-symbols)) | [dwarf2json.nix](./dwarf2json.nix) |
| `memprocfs` | Mounts a dump as a file system | [memprocfs.nix](./memprocfs.nix) |
| `bulk_extractor` | Carves emails, URLs, IPs without parsing OS structures | [bulk_extractor.nix](./bulk_extractor.nix) |
| `evolve` | Web UI for Volatility | [evolve.nix](./evolve.nix) |

Use `vol` by default. It accepts short plugin names (`vol -f dump windows.pslist`), runs vol-rs when it can, and otherwise runs Volatility 3, including for plugins vol-rs is known to get wrong. Its output only appears once the plugin finishes, so a failed vol-rs attempt never mixes with the retry. Use `vol-rs` or `volatility`/`vol3` to run one tool directly.

## vol-analyze

```bash
vol-analyze memory.raw                                   # auto-detect OS
vol-analyze memory.raw --os windows --dump-files --extract-strings
vol-analyze memory.raw --os windows --no-bitlocker --no-credentials -o case-001/
vol-analyze memory.raw --os windows --deep --timeline      # slow, most thorough
```

| Flag | Effect |
|---|---|
| `--os windows\|linux\|mac` | Skip auto-detection |
| `-o DIR` | Output directory (default `volatility_output/`) |
| `-j N` | Parallel plugins |
| `--dump-files` | Extract cached files (Windows) |
| `--dump-registry` | Dump registry hives (Windows) |
| `--extract-strings` | Categorize IPs, URLs, emails, domains, paths |
| `--no-bitlocker` | Skip the BitLocker key scan (Windows) |
| `--no-credentials` | Skip the pypykatz LSASS credential scan (Windows) |
| `--deep` | Also run `windows.ptemalfind`, `windows.imgmalfind` and `windows.mftscan` (MFT records and alternate data streams) (Windows, slow) |
| `--timeline` | Also run `timeliner.Timeliner` under Volatility 3: a super-timeline across all plugins that support it, in `timeliner.txt`, plus a bodyfile in `timeline/volatility.body`. Turn it into a CSV with `mactime -b timeline/volatility.body -d > timeline.csv` (slow, about 2 minutes on a 1 GB dump) |
| `--json` | Also write `analysis_summary.json`: per-plugin status and line counts, plus `bitlocker` (`status`: `found`/`none`/`error`/`skipped`, `candidates`) and `credentials` (`status`: `found`/`none`/`not_resident`/`error`/`skipped`, `entries`) |

Besides the upstream lists, it also runs these on Windows:

| Plugins | Why |
|---|---|
| `cmdscan`, `consoles` | Commands typed in cmd.exe windows |
| `registry.cachedump` | Domain cached credentials (DCC2), which `hashdump`/`lsadump` do not cover |
| `malware.psxview` | Processes hidden from some process lists but not others |
| `malware.ldrmodules` | DLLs unlinked from the loader lists, which `dlllist` misses |
| `malware.hollowprocesses`, `malware.processghosting`, `malware.suspicious_threads` | Injection techniques `malfind` does not catch |
| `malware.svcdiff` | Services hidden from the service list |
| `etwpatch`, `malware.unhooked_system_calls` | ETW patching and unhooked `ntdll` calls, both used to blind EDR |
| `malware.skeleton_key_check` | Skeleton Key backdoor in LSASS (Active Directory) |
| `malware.drivermodule`, `unloadedmodules`, `driverirp` | Hidden drivers, recently unloaded drivers and IRP hooks |
| `shimcachemem`, `registry.amcache`, `registry.scheduled_tasks` | Evidence of execution and persistence |
| `truecrypt` | Cached TrueCrypt passphrases |

If `pslist` finds `KeePass.exe`, it also runs `windows.keepass.KeePass --pid <pid>` for each one and writes `keepass_<pid>.txt`. KeePassXC is a different program and not affected.

And these on Linux:

| Plugins | Why |
|---|---|
| `psscan`, `ptrace` | Hidden processes, and processes being traced or injected into |
| `ip.Addr`, `ip.Link` | Network interfaces and addresses |
| `malware.hidden_modules`, `malware.modxview` | Kernel modules hidden from `lsmod` |
| `malware.netfilter` | Netfilter hooks, used by backdoors that wait for "magic" packets |
| `ebpf`, `tracing.ftrace`, `tracing.tracepoints` | eBPF programs and ftrace/tracepoint hooks, where current Linux rootkits hide. `ebpf` fails with `Unsupported kernel` on kernels older than 3.18, which have no eBPF |

On macOS it also runs `mac.dmesg`, `mac.timers` and `mac.vfsevents`.

Several upstream entries were renamed to their current names (`windows.malfind` → `windows.malware.malfind`, `windows.hashdump` → `windows.registry.hashdump`, `linux.check_*` → `linux.malware.check_*`, and so on). Volatility 3 2.28 marks the old names as deprecated with a removal date that has passed. The output files follow the new names, e.g. `malware_malfind.txt`.

Output, all in the output directory:
- `<plugin>.txt` and `<plugin>.err` per plugin. An `.err` file that is not empty means the plugin failed or warned.
- `analysis_summary.txt`, plus `analysis_summary.json` with `--json`.
- `bitlocker.txt` and `bitlocker/*.fvek` (Windows), `pypykatz.txt` (Windows), `keepass_<pid>.txt` (Windows, when KeePass was running).
- `timeliner.txt` and `timeline/volatility.body` with `--timeline`.

### How it runs plugins

The upstream script expects Volatility 3. Here it is pointed at a shim ([vol-shim.sh](../../../../../pkgs/ang3lo-nur/pkgs/volatility-toolkit/vol-shim.sh)), which is also installed as `vol`. It:

1. Expands short plugin names (`windows.pslist`) to full ones (`windows.pslist.PsList`), which the rules below are matched against.
2. Runs the plugin with **vol-rs** first, because it is much faster.
3. If vol-rs fails, reruns the same command with **Volatility 3** and prints `[vol-rs failed, retrying with Volatility 3] <error>` to stderr (the plugin's `.err` file in `vol-analyze`). It uses your `volatility` if installed, otherwise a bundled copy.
4. Sends plugins vol-rs does not have (BitLocker, pypykatz, the `--deep` plugins) straight to Volatility 3, since vol-rs cannot load Python plugins.
5. Also sends `timeliner` and every `mac.*` plugin straight to Volatility 3. vol-rs's `timeliner` output differs from Volatility 3's but exits successfully, so step 3 would never catch it, and its macOS plugins are untested (see [Known limitations](#known-limitations)).

So a plugin only fails if **both** tools fail on it.

## Symbols

Plugins need a symbol file (ISF) for the exact kernel build in the dump.

**Volatility 3** downloads them automatically:
- **Windows:** from the Microsoft symbol server, cached in `~/.local/share/volatility3/symbols`.
- **Linux:** from the [Abyss-W4tcher/volatility3-symbols](https://github.com/Abyss-W4tcher/volatility3-symbols) banner index. [volatility3.nix](./volatility3.nix) patches `REMOTE_ISF_URL` for this.

**vol-rs** downloads Windows symbols too: it fetches the kernel's PDB from the Microsoft symbol server and converts it, which takes about 4 s for a Windows 10 kernel (the PDB is kept in `~/.cache/volatility3/vol-rs`). It does not download Linux or macOS symbols.

Both tools share `~/.local/share/volatility3/symbols`: the [vol-rs package](../../../../../pkgs/ang3lo-nur/pkgs/vol-rs/default.nix) puts it in `VOLRS_SYMBOL_PATH`, so vol-rs writes the Windows symbols it builds there (as `windows/<pdb>/<GUID>-<AGE>.json`, the layout Volatility 3 uses) and reads what Volatility 3 downloaded. So a Windows build is fetched once, by whichever tool sees it first, and Linux symbols fetched by Volatility 3 (the first plugin falls back to it) are used by vol-rs from then on. Do not pass Volatility 3 an extra `-s` directory to share symbols: it then downloads the PDB again into that directory even when its own already has the file.

`vol-analyze` fetches the symbols with one serial run before starting plugins in parallel (also reported in volatility3#2042). Volatility 3 writes a downloaded symbol file in place while the download runs, so parallel plugins would otherwise read a half-written file or find the symbol cache locked. In a test from an empty home directory without that step, 4 plugins failed and 12 downloaded the same files at once. For the same reason, OS auto-detection gives each probe 300 s (`VOL_DETECT_TIMEOUT`) instead of upstream's 60 s: the first probe may be downloading symbols, and killing it breaks the cache (see below).

**Broken symbol cache** ([volatility3#2042](https://github.com/volatilityfoundation/volatility3/issues/2042)). If Volatility 3 is killed (SIGTERM, e.g. by `timeout`, or a crash) while downloading a PDB, the truncated PDB stays in `~/.cache/volatility3/data_*.cache`, and every later run on that Windows build fails with `Unsatisfied requirement ... symbol_table_name` and `Offset outside of the buffer boundaries`. Ctrl-C is handled and does not cause this. Fix it by running once with `--clear-cache`:

```bash
volatility --clear-cache -f memory.raw windows.info
```

A symbol file that fails `xz -t` (`EOFError: Compressed file ended before the end-of-stream marker was reached`) is broken too. Find those and delete them; Volatility 3 downloads them again:

```bash
find ~/.local/share/volatility3/symbols -name '*.xz' -exec sh -c 'xz -t "$1" 2>/dev/null || echo "$1"' _ {} \;
```

### Missing Linux symbols

The online index only covers common distribution kernels (about 11,000, none of them CachyOS). For any other kernel, Volatility 3 fails with `Unsatisfied requirement` on the kernel symbol table, and you have to build the symbols yourself with `dwarf2json` from a `vmlinux` that still has its debug info:

```bash
dwarf2json linux --elf /path/to/vmlinux | xz > kernel.json.xz
mkdir -p ~/.local/share/volatility3/symbols/linux
mv kernel.json.xz ~/.local/share/volatility3/symbols/linux/
```

The file name does not matter: Volatility 3 matches it to a dump by the kernel banner stored inside. Where to get the `vmlinux`:
- **This machine:** NixOS keeps it in the kernel's `dev` output, e.g. `nix eval --raw .#nixosConfigurations.pc-angelo.config.boot.kernelPackages.kernel.dev` then `<path>/vmlinux`. The CachyOS kernel is built with `CONFIG_DEBUG_INFO`, so it works: tested on 7.2.8-cachyos-lto, 54 s, a 3.4 MB file whose banner matches `/proc/version` exactly.
- **Distribution kernels:** the debug package, e.g. `linux-image-<version>-dbg` on Debian/Ubuntu or `kernel-debuginfo` on Fedora/RHEL.

A `vmlinux` without debug info (most `/boot/vmlinuz` files) does not work.

## Capturing memory (Linux)

`avml` dumps a running Linux machine's RAM to a file Volatility can read, without a kernel module (unlike LiME). It needs root:

```bash
sudo avml acquire memory.lime
sudo avml acquire --compress memory.lime.compressed    # smaller, but convert it before analysis:
avml convert memory.lime.compressed memory.lime
```

Volatility cannot read the compressed format directly. The dump is as large as the machine's RAM, and it contains everything in memory, passwords and keys included, so treat it like the machine itself. For this machine, [build its symbols](#missing-linux-symbols) first, since its kernel is not in the online index.

For Windows machines, capture on the machine itself with a Windows tool (WinPmem, DumpIt, FTK Imager) and copy the dump over.

## BitLocker

[lorelyai/volatility3-bitlocker](https://github.com/lorelyai/volatility3-bitlocker) scans kernel pools for AES key schedules and recovers the Full Volume Encryption Key (FVEK). A key only exists in RAM if a BitLocker volume was **unlocked** when the dump was taken.

`vol-analyze` runs it automatically on Windows dumps and writes:
- `bitlocker.txt`: one row per candidate (pool tag, cipher, FVEK, tweak)
- `bitlocker/<offset>-Dislocker.fvek`: a key file for each candidate

To run it by hand:

```bash
volatility -o fvek_out -f memory.raw windows.bitlocker.BitlockerFVEKScan --dislocker
volatility -f memory.raw windows.bitlocker.BitlockerFVEKScan --tags FVEc Cngb None dFVE
```

### Picking the right candidate

The plugin reports anything that looks like an AES key, so expect false positives:
- A hit **with a tweak key** matches BitLocker's default on Windows 10/11 (XTS-AES), so try those first.
- `Cngb` hits without a tweak may be CNG keys that Windows uses for unrelated purposes.

The only real test is unlocking the disk image.

### Unlocking the disk

```bash
# Dislocker, using the generated file
sudo dislocker -v -k bitlocker/<offset>-Dislocker.fvek -V disk.dd /mnt/dislocker
sudo mount -t ntfs-3g -o ro /mnt/dislocker/dislocker-file /mnt/decrypted

# libbde, using the raw hex keys from bitlocker.txt
sudo bdemount -k <FVEK>:<TWEAK> disk.dd /mnt/decrypted
```

For a partitioned image, point `-V` at the BitLocker partition (for example via `losetup -P`), not the whole disk.

## Credentials (pypykatz)

[skelsec/pypykatz-volatility3](https://github.com/skelsec/pypykatz-volatility3) runs [pypykatz](https://github.com/skelsec/pypykatz) (Mimikatz in Python) against the LSASS process in the dump. It recovers NT/LM hashes, Kerberos tickets, DPAPI master keys and, on older systems or with WDigest enabled, plaintext passwords.

It is a separate source from `windows.registry.hashdump`/`windows.registry.lsadump`, which read the SAM and SECURITY registry hives. When those come back empty, LSASS may still have the credentials of users who were logged on.

`vol-analyze` runs it automatically on Windows dumps and writes `pypykatz.txt`. To run it by hand:

```bash
volatility -f memory.raw windows.pypykatz
```

If it fails with `All detection methods failed` / `LSA signature not found`, the `lsasrv.dll` pages holding the LSA encryption keys were paged out when the dump was taken, so nothing can be decrypted. `vol-analyze` reports this as `none (LSA keys not resident in dump)`, not as an error. To confirm, dump the module and check how much of it is present:

```bash
volatility -f memory.raw windows.dlllist --pid <lsass pid> | grep -i lsasrv
volatility -o out -f memory.raw windows.pedump --pid <lsass pid> --base <lsasrv base>
```

A module file that is mostly zero pages means the data is not in the dump. That is a limitation of the dump, not of the tooling.

The plugin needs the `pypykatz` Python library installed in Volatility 3's own environment, so [volatility3.nix](./volatility3.nix) and the toolkit's bundled Volatility 3 add it as a dependency. Passing the plugin folder with `-p` alone is not enough.

## Third-party plugins

All of these are merged into one plugin folder by the [volatility3-plugins](../../../../../pkgs/ang3lo-nur/pkgs/volatility3-plugins/) package, which `volatility`/`vol3` and the toolkit's bundled Volatility 3 both load. They run only under Volatility 3, since vol-rs cannot load Python plugins; `vol` sends them there automatically.

| Plugin | What it finds | Source |
|---|---|---|
| `windows.bitlocker.BitlockerFVEKScan` | BitLocker FVEKs (see [BitLocker](#bitlocker)) | lorelyai/volatility3-bitlocker |
| `windows.pypykatz` | LSASS credentials (see [Credentials](#credentials-pypykatz)) | skelsec/pypykatz-volatility3 |
| `windows.keepass.KeePass --pid <pid>` | KeePass 2.x master password leftovers (CVE-2023-32784); point it at the KeePass process | forensicxlab |
| `windows.prefetch.Prefetch` | Prefetch files cached in memory, with run count and last execution | forensicxlab |
| `windows.anydesk.AnyDesk` | AnyDesk trace log entries cached in memory | forensicxlab |
| `linux.inodes.Inodes` | Open file inodes per process, with MAC times | forensicxlab |
| `windows.cobaltstrike.CobaltStrike` | Cobalt Strike beacon configs (C2 server, pipe, sleep, license ID) | kevthehermit |
| `windows.passwordmanagers.PasswordManager` | LastPass browser-extension credentials in browser process memory (LastPass only) | kevthehermit |
| `windows.richheader.RichHeader` | Rich header XOR key and hash per process, for binary clustering | kevthehermit |
| `windows.zoneid3.ZoneID3` | `Zone.Identifier` streams for files downloaded from the internet (ZoneId=3), with the source and referrer URLs | kevthehermit |
| `linux.openssh_sessionkeys.SSHKeys` | OpenSSH session keys, to decrypt captured SSH traffic | fox-it/OpenSSH-Session-Key-Recovery |
| `windows.ptemalfind.PteMalfind` | Injected code, via page table entries (finds more than `malfind`) | f-block |
| `windows.imgmalfind.ImageMalfind` | Hooks and patches in loaded DLLs and executables | f-block |
| `windows.apisearch.ApiSearch` | Pointers to API functions in process memory | f-block |
| `windows.simple_pteenum.SimplePteEnumerator`, `windows.swap_enum.SwapEnumerator`, `windows.pte_resolve.PteResolve` | Raw PTE, pagefile and address-translation helpers | f-block |

The forensicxlab, kevthehermit and fox-it plugins were written for Volatility 3 1.x and no longer run on 2.x unchanged. Each package carries a small patch that raises the core plugin versions they require and updates the changed `pslist`/`filescan`/`yarascan` calls. The f-block package replaces an import from the Python 2 `future` library and two APIs that Volatility 3 2.28 deprecates (`PluginRequirement`, `interfaces.renderers.Disassembly`), which otherwise print a warning on every `volatility` run. A Volatility 3 upgrade that changes those APIs again will break them the same way: the plugin reports `Unsatisfied requirement ... dependency ... unmet`, and the fix belongs in that package's patch.

## Package layout

| Piece | Location |
|---|---|
| Toolkit package, shim (`vol`), and patches to the upstream script | [pkgs/ang3lo-nur/pkgs/volatility-toolkit/](../../../../../pkgs/ang3lo-nur/pkgs/volatility-toolkit/) |
| vol-rs package | [pkgs/ang3lo-nur/pkgs/vol-rs/](../../../../../pkgs/ang3lo-nur/pkgs/vol-rs/) |
| BitLocker plugin package | [pkgs/ang3lo-nur/pkgs/volatility3-bitlocker/](../../../../../pkgs/ang3lo-nur/pkgs/volatility3-bitlocker/) |
| pypykatz plugin package | [pkgs/ang3lo-nur/pkgs/volatility3-pypykatz/](../../../../../pkgs/ang3lo-nur/pkgs/volatility3-pypykatz/) |
| Other plugin packages, with their port patches | `pkgs/ang3lo-nur/pkgs/volatility3-{fblock,forensicxlab,kevthehermit,openssh-sessionkeys}/` |
| Combined plugin folder | [pkgs/ang3lo-nur/pkgs/volatility3-plugins/](../../../../../pkgs/ang3lo-nur/pkgs/volatility3-plugins/) |
| Source pins | `pkgs/ang3lo-nur/nvfetcher.toml` |

Patches to the upstream script, in the order applied:

| Patch | Adds |
|---|---|
| `bitlocker-scan.patch` | BitLocker FVEK scan, `--no-bitlocker` |
| `credentials-scan.patch` | pypykatz LSASS scan, `--no-credentials` |
| `extra-plugins.patch` | The extra Windows and Linux plugins, the deprecated-name renames, `--deep`, `--timeline` |
| `completions.patch` | The new flags in the bash and zsh completions |
| `json-report.patch` | `bitlocker` and `credentials` in the `--json` report |
| `timeline-keepass.patch` | The KeePass step, the timeline step with bodyfile, the macOS plugins |
| `symbol-fetch.patch` | The serial symbol fetch, the 300 s detection timeout |

Plus fixes in `postPatch`:
- `(( i++ ))` aborting under `set -e` when `i=0`
- Color codes printed as literal `\033[...]` text
- Help text naming the script `.vol-analyze-wrapped` (the `wrapProgram` wrapper) instead of `vol-analyze`

## Known limitations

- **vol-rs:** no Python plugins (`-p` is accepted but ignored), and no Linux or macOS symbol download (it reuses Volatility 3's, see [Symbols](#symbols)). Both are covered by the fallback. The fallback only triggers when vol-rs *fails*: a vol-rs plugin that returns different results with exit code 0 goes unnoticed. Known cases, routed to Volatility 3 by the shim:
  - **timeliner** ([vol-rs#7](https://github.com/daffainfo/vol-rs/issues/7), marked `FIXME(vol-rs)` in [vol-shim.sh](../../../../../pkgs/ang3lo-nur/pkgs/volatility-toolkit/vol-shim.sh)): with `--plugin-filter` both tools print the same rows, but an unfiltered run uses a different plugin order than Volatility 3 2.28.2. Volatility's timeliner prints the rows so far again after each plugin, so the order changes the totals: 87,235 rows from vol-rs against 137,769 on Volatility's Windows 10 test dump. Drop the rule once they match.
  - **macOS:** not compared, since no macOS dump was available, and upstream has not run those plugins on a real capture either. It goes to Volatility 3 as a precaution.

  Fixed in vol-rs 1.0.2 and checked against Volatility 3 on its own test images (`linux-sample-1.bin`, `win-10_19041-2025_03.dmp`): `windows.cmdscan`/`consoles` ([vol-rs#5](https://github.com/daffainfo/vol-rs/issues/5)), the Linux plugins ([vol-rs#6](https://github.com/daffainfo/vol-rs/issues/6)) and Windows crash dumps ([vol-rs#4](https://github.com/daffainfo/vol-rs/issues/4)) now give identical output.

  If a plugin's output looks odd, compare it with `volatility -f <dump> <plugin>`.
- **Missing credentials:** `registry.hashdump`/`registry.lsadump` often return nothing because the needed registry pages were not resident in RAM. `pypykatz.txt` is the fallback, but it has the same limitation for the `lsasrv.dll` pages (see [Credentials](#credentials-pypykatz)).
