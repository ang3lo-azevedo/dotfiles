# rEFInd Configuration

This folder contains my rEFInd bootloader configuration files and management scripts.

## Automated Setup

Use the provided `setup-refind.sh` script for automated configuration management:

```bash
# Copy current rEFInd configuration from /boot
./setup-refind.sh copy

# Setup sync mechanism (attempts symlinks, falls back to copy-based)
./setup-refind.sh link

# For FAT32 EFI partitions, sync changes manually
./setup-refind.sh sync

# Check current status
./setup-refind.sh status
```

## FAT32 Filesystem Limitations

Most EFI system partitions use FAT32, which doesn't support symbolic links. The script automatically detects this and:

1. **Attempts symlinks first**: Tests if the filesystem supports them
2. **Falls back to copy-based sync**: Uses direct file copying when symlinks fail
3. **Provides sync command**: Manual synchronization from dotfiles to /boot
4. **Clear status reporting**: Shows current sync mechanism in use

## Manual Installation

To manually copy the current rEFInd configuration from `/boot`:

```bash
# Copy refind.conf
sudo cp /boot/EFI/refind/refind.conf ~/.config/refind/

# Copy any custom themes or icons if they exist
sudo cp -r /boot/EFI/refind/themes ~/.config/refind/ 2>/dev/null || true
sudo cp -r /boot/EFI/refind/icons ~/.config/refind/ 2>/dev/null || true
```

## Sync Management

**For filesystems supporting symlinks (ext4, btrfs, etc.)**:
- Changes in `~/.config/refind/` are automatically reflected in `/boot`
- No manual intervention required

**For FAT32 EFI partitions (most common)**:
- Use `./setup-refind.sh sync` after making changes to dotfiles
- The script will copy updated files from dotfiles to /boot
- Status command shows current sync mechanism

## Workflow

```bash
# Initial setup
./setup-refind.sh copy     # Copy from /boot to dotfiles
./setup-refind.sh link     # Setup sync (auto-detects filesystem)

# Making changes
# Edit files in ~/.config/refind/
./setup-refind.sh sync     # Sync to /boot (for FAT32)
./setup-refind.sh status   # Verify sync status
```

## Backup and Restore

```bash
# Automatic backup (done by setup script)
# Backups are created with timestamp: refind.conf.backup.YYYYMMDD_HHMMSS

# Manual restore from dotfiles
./setup-refind.sh restore
```

## Notes

- rEFInd is used as the primary bootloader for this system
- EFI system partitions typically use FAT32, which doesn't support symlinks
- The script intelligently handles different filesystem types
- Always backup existing configuration before making changes
- The setup script includes safety checks, filesystem detection, and colored output for clarity
