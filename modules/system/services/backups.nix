{
  config,
  pkgs,
  ...
}:

{
  # Restic Backup Configuration
  # Backups are configured to run automatically every day.

  services.restic.backups = {
    # --- Backup to NAS (SMB via Rclone) ---
    nas = {
      initialize = true;
      paths = [ "/persist" "/home" ];
      
      passwordFile = config.age.secrets.user_password.path;
      repository = "rclone:nas:/backups";
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

    # --- Backup to Google Drive (Rclone) ---
    gdrive = {
      initialize = true;
      paths = [ "/persist" "/home" ];
      
      passwordFile = config.age.secrets.user_password.path;
      repository = "rclone:gdrive:/backups"; 
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

    # --- Backup to Google Shared Drive (Rclone) ---
    gdrive_shared = {
      initialize = true;
      paths = [ "/persist" "/home" ];
      
      passwordFile = config.age.secrets.user_password.path;
      repository = "rclone:gdrive_shared_drive:/backups"; 
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
  };

  environment.systemPackages = [
    pkgs.restic
    pkgs.rclone # Needed for Google Drive & SMB backends
  ];
}
