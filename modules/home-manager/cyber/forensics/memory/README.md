# Memory Forensics

Tools for analyzing RAM dumps (`.raw`, `.mem`, `.vmem`, `.dmp`, `.lime`).

## Commands

| Command | Tool | Defined in |
|---|---|---|
| `vol-analyze` | Automated triage, runs ~30 plugins plus a BitLocker scan | [volatility-toolkit.nix](./volatility-toolkit.nix) |
| `vol`, `vol-rs` | [vol-rs](https://github.com/daffainfo/vol-rs), Volatility 3 ported to Rust | [vol-rs.nix](./vol-rs.nix) |
| `volatility`, `vol3` | Volatility 3, with the BitLocker plugin and Linux symbol auto-download | [volatility3.nix](./volatility3.nix) |
| `volshell` | Volatility 3 interactive shell | [volatility3.nix](./volatility3.nix) |
| `vol2`, `volatility2` | Volatility 2, for plugins never ported to 3 | [volatility2.nix](./volatility2.nix) |
| `memprocfs` | Mounts a dump as a file system | [memprocfs.nix](./memprocfs.nix) |
| `bulk_extractor` | Carves emails, URLs, IPs without parsing OS structures | [bulk_extractor.nix](./bulk_extractor.nix) |
| `evolve` | Web UI for Volatility | [evolve.nix](./evolve.nix) |

Plain `vol` is **vol-rs**, not Volatility 3. Use `volatility` or `vol3` for the Python version.

## vol-analyze

```bash
vol-analyze memory.raw                                   # auto-detect OS
vol-analyze memory.raw --os windows --dump-files --extract-strings
vol-analyze memory.raw --os windows --no-bitlocker -o case-001/
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
| `--json` | Also write a JSON summary |

Output: one `<plugin>.txt` and `<plugin>.err` per plugin, plus `analysis_summary.txt`. An `.err` file that is not empty means the plugin failed or warned.

### How it runs plugins

The upstream script expects Volatility 3. Here it is pointed at a shim ([vol-shim.sh](../../../../../pkgs/ang3lo-nur/pkgs/volatility-toolkit/vol-shim.sh)) that:

1. Expands short plugin names (`windows.pslist`) to the full names vol-rs requires (`windows.pslist.PsList`).
2. Runs the plugin with **vol-rs** first, because it is much faster.
3. If vol-rs fails, reruns the same command with **Volatility 3** and prints `[vol-rs failed, retrying with Volatility 3] <error>` to the `.err` file. It uses your `volatility` if installed, otherwise a bundled copy.
4. Sends `windows.bitlocker*` straight to Volatility 3, since vol-rs cannot load Python plugins.

So a plugin only fails if **both** tools fail on it.

## Symbols

Windows plugins need a symbol file (ISF) for the exact kernel build in the dump.

**Volatility 3** downloads them automatically:
- **Windows:** from the Microsoft symbol server, cached in `~/.local/share/volatility3/symbols`.
- **Linux:** from the [Abyss-W4tcher/volatility3-symbols](https://github.com/Abyss-W4tcher/volatility3-symbols) banner index. [volatility3.nix](./volatility3.nix) patches `REMOTE_ISF_URL` for this.

**vol-rs does not download kernel symbols.** For a new Windows build it logs

```
This kernel is described by windows/ntkrnlmp.pdb/<GUID>-<AGE>, which is not installed
```

and `vol-analyze` falls back to Volatility 3. To let vol-rs handle that build itself, generate the ISF once:

```bash
python -m volatility3.framework.symbols.windows.pdbconv \
  -p ntkrnlmp.pdb -g <GUID><AGE> \
  -o ~/.local/share/vol-rs/symbols/windows/ntkrnlmp.pdb/<GUID>-<AGE>.json.xz
```

Note `-g` takes GUID and age joined, while the file name separates them with `-`. Run it with the Python from the `volatility3` package so the module is importable.

The generic ISFs vol-rs does not ship (netscan, registry, services, callbacks, mbr) come from the Volatility 3 source tree. The [vol-rs package](../../../../../pkgs/ang3lo-nur/pkgs/vol-rs/default.nix) adds them to `VOLRS_SYMBOL_PATH`.

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

## Package layout

| Piece | Location |
|---|---|
| Toolkit package, shim, BitLocker step patch | [pkgs/ang3lo-nur/pkgs/volatility-toolkit/](../../../../../pkgs/ang3lo-nur/pkgs/volatility-toolkit/) |
| vol-rs package | [pkgs/ang3lo-nur/pkgs/vol-rs/](../../../../../pkgs/ang3lo-nur/pkgs/vol-rs/) |
| BitLocker plugin package | [pkgs/ang3lo-nur/pkgs/volatility3-bitlocker/](../../../../../pkgs/ang3lo-nur/pkgs/volatility3-bitlocker/) |
| Source pins | `pkgs/ang3lo-nur/nvfetcher.toml` |

Upstream script fixes applied in the toolkit package:
- `(( i++ ))` aborting under `set -e` when `i=0`
- Color codes printed as literal `\033[...]` text

## Known limitations

- **vol-rs:** no Python plugins (`-p` is accepted but ignored), and no kernel symbol download. Both are covered by the fallback.
- **Deprecated plugin names:** Volatility 3 2.28 warns that `windows.hashdump` and `windows.lsadump` (used by the upstream script) are deprecated and will be removed in a later release. vol-rs still has them, so only the Volatility 3 fallback for those two would break.
- **Missing credentials:** `hashdump`/`lsadump` often return nothing because the needed registry pages were not resident in RAM. That is the dump, not the tooling.
