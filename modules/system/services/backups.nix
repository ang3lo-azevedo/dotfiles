{
  config,
  pkgs,
  ...
}:

let
  commonConfig = {
    initialize = true;
    paths = [ "/persist" "/home" ];
    passwordFile = config.age.secrets.restic_password.path;
    rcloneConfigFile = config.age.secrets.rclone-conf.path;
    extraBackupArgs = [ "-v" ]; # Enable verbose logging to see progress
    exclude = [
      "/home/*/.cache"
      "/home/*/.local/share/Trash"
    ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
    };
  };
in
{
  # Restic Backup Configuration
  # Backups are configured to run automatically every day.

  services.restic.backups = {
    # --- Backup to NAS (SMB via Rclone) ---
    nas = commonConfig // { repository = "rclone:nas:homes/ang3lo/backups/pc-angelo"; };

    # --- Backup to Google Drive (Rclone) ---
    gdrive = commonConfig // { repository = "rclone:gdrive:/backups/pc-angelo"; };

    # --- Backup to Google Shared Drive (Rclone) ---
    gdrive_shared = commonConfig // { repository = "rclone:gdrive_shared_drive:/backups/pc-angelo"; };
  };

  # Apply Rclone TPS limits and Chunk Sizes to avoid Google Drive Rate Limiting
  systemd.services.restic-backups-gdrive.environment = {
    RCLONE_TPSLIMIT = "3";
    RCLONE_TPSLIMIT_BURST = "3";
    RCLONE_DRIVE_CHUNK_SIZE = "64M";
  };
  systemd.services.restic-backups-gdrive_shared.environment = {
    RCLONE_TPSLIMIT = "3";
    RCLONE_TPSLIMIT_BURST = "3";
    RCLONE_DRIVE_CHUNK_SIZE = "64M";
  };

  environment.systemPackages = [
    pkgs.restic
    pkgs.rclone # Needed for Google Drive & SMB backends
  ];
}
