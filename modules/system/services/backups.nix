{
  pkgs,
  ...
}:

{
  # Enable btrbk service for automated local Btrfs snapshots
  services.btrbk = {
    instances."btrbk" = {
      onCalendar = "daily";
      settings = {
        timestamp_format = "long";
        snapshot_preserve_min = "2d";
        snapshot_preserve = "14d";

        # Snapshot /home
        volume."/home" = {
          subvolume = ".";
          snapshot_dir = ".snapshots";
        };

        # Snapshot /persist (system state)
        volume."/persist" = {
          subvolume = ".";
          snapshot_dir = ".snapshots";
        };
      };
    };
  };

  # Restic Backup Configuration
  # Based on https://codewitchbella.com/blog/2024-nixos-automated-backup
  
  # TODO: Configure secrets for Restic
  # age.secrets.restic-repo.file = ../../../secrets/restic-repo.age;
  # age.secrets.restic-password.file = ../../../secrets/restic-password.age;

  services.restic.backups = {
    # --- Backup to NAS (SFTP) ---
    nas = {
      initialize = true;
      paths = [ "/persist" "/home" ];
      
      # Placeholder configuration - PLEASE UPDATE
      passwordFile = "/etc/nixos/restic-password-nas"; 
      repository = "sftp:user@nas-ip:/path/to/repo"; 

      exclude = [
        "/persist/@backup-snapshot-nas"
        "/home/@backup-snapshot-nas"
        "/home/*/.cache"
        "/home/*/.local/share/Trash"
      ];
      
      backupPrepareCommand = ''
        set -Eeuxo pipefail
        
        # --- Handle /persist ---
        if ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /persist/@backup-snapshot-nas; then
            echo "WARNING: previous run did not cleanly finish, removing old /persist snapshot"
        fi
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /persist /persist/@backup-snapshot-nas
        ${pkgs.util-linux}/bin/umount /persist
        ${pkgs.util-linux}/bin/mount -t btrfs -o subvol=/persist/@backup-snapshot-nas /dev/mapper/pool-root /persist

        # --- Handle /home ---
        if ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /home/@backup-snapshot-nas; then
            echo "WARNING: previous run did not cleanly finish, removing old /home snapshot"
        fi
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /home /home/@backup-snapshot-nas
        ${pkgs.util-linux}/bin/umount /home
        ${pkgs.util-linux}/bin/mount -t btrfs -o subvol=/home/@backup-snapshot-nas /dev/mapper/pool-root /home
      '';
      
      backupCleanupCommand = ''
        ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /persist/@backup-snapshot-nas
        ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /home/@backup-snapshot-nas
      '';

      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "1h";
      };
    };

    # --- Backup to Google Drive (Rclone) ---
    gdrive = {
      initialize = true;
      paths = [ "/persist" "/home" ];
      
      # Placeholder configuration - PLEASE UPDATE
      passwordFile = "/etc/nixos/restic-password-gdrive"; 
      repository = "rclone:gdrive:/backups"; 
      rcloneConfigFile = "/etc/nixos/rclone.conf"; # You need to generate this with `rclone config`

      exclude = [
        "/persist/@backup-snapshot-gdrive"
        "/home/@backup-snapshot-gdrive"
        "/home/*/.cache"
        "/home/*/.local/share/Trash"
      ];
      
      backupPrepareCommand = ''
        set -Eeuxo pipefail
        
        # --- Handle /persist ---
        if ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /persist/@backup-snapshot-gdrive; then
            echo "WARNING: previous run did not cleanly finish, removing old /persist snapshot"
        fi
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /persist /persist/@backup-snapshot-gdrive
        ${pkgs.util-linux}/bin/umount /persist
        ${pkgs.util-linux}/bin/mount -t btrfs -o subvol=/persist/@backup-snapshot-gdrive /dev/mapper/pool-root /persist

        # --- Handle /home ---
        if ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /home/@backup-snapshot-gdrive; then
            echo "WARNING: previous run did not cleanly finish, removing old /home snapshot"
        fi
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /home /home/@backup-snapshot-gdrive
        ${pkgs.util-linux}/bin/umount /home
        ${pkgs.util-linux}/bin/mount -t btrfs -o subvol=/home/@backup-snapshot-gdrive /dev/mapper/pool-root /home
      '';
      
      backupCleanupCommand = ''
        ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /persist/@backup-snapshot-gdrive
        ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /home/@backup-snapshot-gdrive
      '';

      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "1h";
      };
    };
  };

  # Grant permissions for private mounts to both services
  systemd.services.restic-backups-nas = {
    path = with pkgs; [ btrfs-progs util-linux ];
    serviceConfig.PrivateMounts = true;
  };
  systemd.services.restic-backups-gdrive = {
    path = with pkgs; [ btrfs-progs util-linux ];
    serviceConfig.PrivateMounts = true;
  };

  environment.systemPackages = [
    pkgs.btrbk
    pkgs.restic
    pkgs.rclone # Needed for Google Drive backend
  ];
}
