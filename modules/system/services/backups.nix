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
    gdrive-shared = commonConfig // { repository = "rclone:gdrive_shared_drive:/backups/pc-angelo"; };
  };

  environment.systemPackages = [
    pkgs.restic
    pkgs.rclone # Needed for Google Drive & SMB backends
  ];
}
