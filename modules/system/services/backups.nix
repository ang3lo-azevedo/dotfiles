{
  config,
  pkgs,
  ...
}:

let
  commonConfig = {
    initialize = true;
    paths = [ "/persist" "/home" ];
    passwordFile = config.age.secrets.user_password.path;
    rcloneConfigFile = config.age.secrets.rclone-conf.path;
    exclude = [
      "/home/*/.cache"
      "/home/*/.local/share/Trash"
    ];
    environment = {
      RCLONE_TPSLIMIT = "8";
      RCLONE_TPSLIMIT_BURST = "10";
    };
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
    nas = commonConfig // { repository = "rclone:nas:/backups"; };

    # --- Backup to Google Drive (Rclone) ---
    gdrive = commonConfig // { repository = "rclone:gdrive:/backups"; };

    # --- Backup to Google Shared Drive (Rclone) ---
    gdrive_shared = commonConfig // { repository = "rclone:gdrive_shared_drive:/backups"; };
  };

  environment.systemPackages = [
    pkgs.restic
    pkgs.rclone # Needed for Google Drive & SMB backends
  ];
}
