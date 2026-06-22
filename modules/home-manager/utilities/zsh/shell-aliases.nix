{ config, ... }:
let
  # Dynamically pull the secret path if Home Manager is running as a NixOS module,
  # otherwise fallback to the default Agenix path for standalone Home Manager.
  keyfile = 
    if config ? osConfig then config.osConfig.age.secrets.nvchecker_keyfile.path
    else "/run/agenix/nvchecker_keyfile";
in
{
  programs.zsh.shellAliases = {
    
    # Tool related alises
    ll = "eza -l";
    la = "eza -la";
    ls = "eza";
    cat = "bat";
    y = "yazi";

    # NixOS related aliases
    rebuild = "sudo nixos-rebuild switch --accept-flake-config --flake path:/home/ang3lo/nix-config#pc-angelo -L";
    hmrebuild = "home-manager switch --accept-flake-config --flake path:/home/ang3lo/nix-config#ang3lo";
    nvfetcher = "nix run nixpkgs#nvfetcher -- -c /home/ang3lo/nix-config/pkgs/nvfetcher.toml -o /home/ang3lo/nix-config/pkgs/_sources $([ -f ${keyfile} ] && echo \"-k ${keyfile}\")";
    update = "nvfetcher && nix flake update --accept-flake-config --flake /home/ang3lo/nix-config";

    # Fast day-to-day system apply: no lockfile bump, better progress output.
    upgrade = "update && rebuild";

    # Backup related aliases
    backup-all = "sudo systemctl start --no-block restic-backups-nas.service restic-backups-gdrive.service restic-backups-gdrive_shared.service && echo 'Backups started in the background. Now watching live logs (Press Ctrl+C to stop watching):' && journalctl --output=with-unit -u restic-backups-nas.service -u restic-backups-gdrive.service -u restic-backups-gdrive_shared.service -f";
    backup-nas = "sudo systemctl start --no-block restic-backups-nas.service && echo 'NAS Backup started. Watching live logs (Press Ctrl+C to stop watching):' && journalctl -u restic-backups-nas.service -f";
    backup-gdrive = "sudo systemctl start --no-block restic-backups-gdrive.service && echo 'GDrive Backup started. Watching live logs (Press Ctrl+C to stop watching):' && journalctl --output=with-unit -u restic-backups-gdrive.service -f";
    backup-shared = "sudo systemctl start --no-block restic-backups-gdrive_shared.service && echo 'Shared Drive Backup started. Watching live logs (Press Ctrl+C to stop watching):' && journalctl --output=with-unit -u restic-backups-gdrive_shared.service -f";

    # GUI Backup Browsing aliases
    browse-nas = "Restic-Browser -r rclone:nas:homes/ang3lo/backups";
    browse-gdrive = "Restic-Browser -r rclone:gdrive:/backups";
    browse-shared = "Restic-Browser -r rclone:gdrive_shared_drive:/backups";
  };
}