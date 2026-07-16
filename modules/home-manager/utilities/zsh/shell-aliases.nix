{config, ...}: let
  # Dynamically pull the secret path if Home Manager is running as a NixOS module,
  # otherwise fallback to the default Agenix path for standalone Home Manager.
  keyfile =
    if config ? osConfig
    then config.osConfig.age.secrets.nvchecker_keyfile.path
    else "/run/agenix/nvchecker_keyfile";
in {
  programs.zsh.shellAliases = {
    # Tool related alises
    "7z" = "7zz";
    c = "clear";
    ll = "eza -l";
    la = "eza -la";
    ls = "eza";
    cat = "bat";
    y = "yazi";
    code = "$EDITOR";

    # NixOS related aliases
    fmt = "(cd ~/nix-config && pre-commit run --all-files)";
    rebuild = "sudo -v && git -C ~/nix-config add -N . 2>/dev/null; fmt || true; sudo nixos-rebuild switch --accept-flake-config --impure --flake ~/nix-config#pc-angelo -L --keep-going";
    hmrebuild = "git -C ~/nix-config add -N . 2>/dev/null; fmt || true; home-manager switch --accept-flake-config --impure --flake ~/nix-config#ang3lo";
    nvfetcher = "nvfetcher -c ~/nix-config/pkgs/nvfetcher.toml -o ~/nix-config/pkgs/_sources $([ -f ${keyfile} ] && echo \"-k ${keyfile}\")";
    update = "(cd ~/nix-config && nvfetcher && update-flake --accept-flake-config)";
    upgrade = "sudo -v && update && _cache-check && rebuild";
    u = "upgrade";
    rb = "rebuild";

    # Backup related aliases
    backup-all = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-nas.service restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service restic-backups-gdrive-shared.service && echo \"Backups started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl --output=with-unit -u restic-backups-nas.service -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
    backup-nas = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-nas.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service && echo \"NAS Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-nas.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
    backup-gdrive = "echo \"Manually triggering Server-Side Mirror from Shared Drive to Personal Drive...\" && sudo rclone sync -v --drive-server-side-across-configs --config /run/agenix/rclone-conf gdrive_shared_drive:/backups/pc-angelo gdrive:/backups/pc-angelo";
    backup-shared = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-gdrive-shared.service && echo \"Shared Drive Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
  };

  programs.zsh.initExtra = ''
    _cache-check() {
      print -P "%F{cyan}:: Checking binary cache...%f"
      local to_build
      to_build=$(nix build --accept-flake-config --impure --dry-run --no-link \
        ~/nix-config#nixosConfigurations.pc-angelo.config.system.build.toplevel 2>&1 \
        | awk '/will be built/{p=1} /will be fetched/{p=0} p && /\.drv/{print}')

      [[ -z "$to_build" ]] && return 0

      local -a heavy=(webkitgtk chromium libreoffice llvm gcc rustc ghc texlive mesa ffmpeg blender)
      local -a found=()
      for h in "''${heavy[@]}"; do
        echo "$to_build" | grep -qi "$h" && found+=("$h")
      done

      [[ ''${#found[@]} -eq 0 ]] && return 0

      local total
      total=$(echo "$to_build" | wc -l | tr -d ' ')
      print -P "%F{yellow}$total package(s) will be compiled locally (heavy: ''${(j:, :)found}).%f"
      print -P "%F{yellow}Cache may not be populated yet — this could take hours.%f"
      read -rk1 "?Proceed anyway? [y/N] "
      echo
      [[ "$REPLY" == [yY] ]]
    }
  '';
}
