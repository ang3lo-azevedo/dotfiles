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
    code = "antigravity-ide";

    # NixOS related aliases
    rebuild = "sudo nixos-rebuild switch --accept-flake-config --flake path:/home/ang3lo/nix-config#pc-angelo -L";
    hmrebuild = "home-manager switch --accept-flake-config --flake path:/home/ang3lo/nix-config#ang3lo";
    nvfetcher = "nix run nixpkgs#nvfetcher -- -c /home/ang3lo/nix-config/pkgs/nvfetcher.toml -o /home/ang3lo/nix-config/pkgs/_sources $([ -f ${keyfile} ] && echo \"-k ${keyfile}\")";
    update = "nvfetcher && nix flake update --accept-flake-config --flake /home/ang3lo/nix-config";

    # Fast day-to-day system apply: no lockfile bump, better progress output.
    upgrade = "update && rebuild";

    # Backup related aliases
    backup-all = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 restic-backups-nas.service restic-backups-gdrive.service restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service restic-backups-gdrive.service restic-backups-gdrive-shared.service && echo \"Backups started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl --output=with-unit -u restic-backups-nas.service -u restic-backups-gdrive.service -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\"'";
    backup-nas = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 restic-backups-nas.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service && echo \"NAS Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-nas.service -f | grep --line-buffered -v \"signal SIGUSR1\"'";
    backup-gdrive = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 restic-backups-gdrive.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-gdrive.service && echo \"GDrive Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-gdrive.service -f | grep --line-buffered -v \"signal SIGUSR1\"'";
    backup-shared = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-gdrive-shared.service && echo \"Shared Drive Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\"'";
  };
}