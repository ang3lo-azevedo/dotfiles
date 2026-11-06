{pkgs, ...}: {
  programs.zsh.shellAliases = {
    # Tool related alises
    "7z" = "7zz";
    c = "clear";
    ll = "eza -l";
    la = "eza -la";
    ls = "eza";
    cat = "bat";
    grep = "rg";
    code = "$EDITOR";
    btop = "WIDTH=$(niri msg -j focused-window | jq -r '.layout.window_size[0]'); niri msg action set-column-width 33%; command btop; niri msg action set-column-width $WIDTH";
    chainsaw-hunt = "chainsaw hunt --mapping ${pkgs.chainsaw-rules}/share/chainsaw/mappings/sigma-event-logs-all.yml --sigma ${pkgs.chainsaw-rules}/share/chainsaw/sigma/rules";
    blackarch = "distrobox enter blackarch";
    kali = "distrobox enter kali";
    phone = "gio mount -li | awk -F= '{if(index($2,\"mtp://\") != 0) system(\"gio mount \"$2)}'; yy /run/user/1000/gvfs/mtp*";

    # NixOS related aliases
    # internal-json + nom turns the raw -L build wall into a live tree that names the
    # derivation that failed; --keep-going lets nom collect every failure in one pass.
    # On success nvd prints what package versions actually changed in the new generation.
    fmt = "(cd ~/nix-config && pre-commit run --all-files)";
    # fastfetch counts nix packages from the 339MB db.sqlite and caches it per generation;
    # a read hitting that db while nixos-rebuild/home-manager still holds the store lock
    # blocks until the switch finishes, so fastfetch freezes if run mid build. Refreshing
    # the cache here, after the switch has freed the lock, keeps later interactive runs
    # instant instead of paying (or blocking on) the next cache miss.
    rebuild = "sudo -v && git -C ~/nix-config add -N . 2>/dev/null; fmt || true; before=$(readlink -f /run/current-system); sudo nixos-rebuild switch --accept-flake-config --impure --flake 'path:/home/ang3lo/nix-config#pc-angelo' --log-format internal-json -v --keep-going |& nom --json && nvd diff \"$before\" /run/current-system; fastfetch --structure packages --logo none > /dev/null 2>&1";
    hmrebuild = "git -C ~/nix-config add -N . 2>/dev/null; fmt || true; before=$(readlink -f ~/.local/state/nix/profiles/home-manager 2>/dev/null); home-manager switch --accept-flake-config --impure --flake 'path:/home/ang3lo/nix-config#ang3lo' --log-format internal-json -v |& nom --json && nvd diff \"$before\" ~/.local/state/nix/profiles/home-manager; fastfetch --structure packages --logo none > /dev/null 2>&1";
    # eglantine, lichii, pokedinner, nemyu and orchid track upstream AppImages that nvfetcher cannot
    # template (tag in the path, commit in the filename, prereleases), so their updaters
    # run here after the submodule pull and commit any bump locally; the ang3lo-nur relock
    # that follows then picks it up. A network/API failure is swallowed so it never
    # blocks the rest of the update.
    update = "(cd ~/nix-config && git submodule update --remote --merge home/ang3lo/.config/mpv pkgs/ang3lo-nur pkgs/th3m1ghtyduck-nur pkgs/samsung-galaxy-book-linux-fixes && { (cd pkgs/ang3lo-nur && bash pkgs/eglantine/update.sh && { git diff --quiet -- pkgs/eglantine/default.nix || git commit -q -m \"eglantine: bump to latest AppImage pre-release\" pkgs/eglantine/default.nix; }) || echo \"eglantine update skipped\"; } && { (cd pkgs/ang3lo-nur && bash pkgs/lichii/update.sh && { git diff --quiet -- pkgs/lichii/default.nix || git commit -q -m \"lichii: bump to latest AppImage pre-release\" pkgs/lichii/default.nix; }) || echo \"lichii update skipped\"; } && { (cd pkgs/ang3lo-nur && bash pkgs/pokedinner/update.sh && { git diff --quiet -- pkgs/pokedinner/default.nix || git commit -q -m \"pokedinner: bump to latest AppImage pre-release\" pkgs/pokedinner/default.nix; }) || echo \"pokedinner update skipped\"; } && { (cd pkgs/ang3lo-nur && bash pkgs/nemyu/update.sh && { git diff --quiet -- pkgs/nemyu/default.nix || git commit -q -m \"nemyu: bump to latest AppImage pre-release\" pkgs/nemyu/default.nix; }) || echo \"nemyu update skipped\"; } && { (cd pkgs/ang3lo-nur && bash pkgs/orchid/update.sh && { git diff --quiet -- pkgs/orchid/default.nix || git commit -q -m \"orchid: bump to latest AppImage release\" pkgs/orchid/default.nix; }) || echo \"orchid update skipped\"; } && nix flake update mpv-config ang3lo-nur th3m1ghtyduck-nur samsung-galaxy-book-linux-fixes --accept-flake-config && nix flake update --accept-flake-config)";
    upgrade = "sudo -v && git -C ~/nix-config pull && update && rebuild";
    u = "upgrade";
    rb = "rebuild";

    # Backup related aliases
    backup-all = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-nas.service restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service restic-backups-gdrive-shared.service && echo \"Backups started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl --output=with-unit -u restic-backups-nas.service -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
    backup-nas = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-nas.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service && echo \"NAS Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-nas.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
    backup-gdrive = "echo \"Manually triggering Server-Side Mirror from Shared Drive to Personal Drive...\" && sudo rclone sync -v --drive-server-side-across-configs --config /run/agenix/rclone-conf gdrive_shared_drive:/backups/pc-angelo gdrive:/backups/pc-angelo";
    backup-shared = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-gdrive-shared.service && echo \"Shared Drive Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
  };
}
