{pkgs, ...}: {
  programs.zsh.shellAliases = {
    # Tool related alises
    "7z" = "7zz";
    c = "clear";
    ll = "eza -l";
    la = "eza -la";
    ls = "eza";
    cat = "bat";
    code = "$EDITOR";
    btop = "WIDTH=$(niri msg -j focused-window | jq -r '.layout.window_size[0]'); niri msg action set-column-width 33%; command btop; niri msg action set-column-width $WIDTH";
    chainsaw-hunt = "chainsaw hunt --mapping ${pkgs.chainsaw-rules}/share/chainsaw/mappings/sigma-event-logs-all.yml --sigma ${pkgs.chainsaw-rules}/share/chainsaw/sigma/rules";
    phone = "gio mount -li | awk -F= '{if(index($2,\"mtp://\") != 0) system(\"gio mount \"$2)}'; yy /run/user/1000/gvfs/mtp*";

    # NixOS related aliases
    fmt = "(cd ~/nix-config && pre-commit run --all-files)";
    rebuild = "sudo -v && git -C ~/nix-config add -N . 2>/dev/null; fmt || true; sudo nixos-rebuild switch --accept-flake-config --impure --flake 'path:/home/ang3lo/nix-config#pc-angelo' -L --keep-going";
    hmrebuild = "git -C ~/nix-config add -N . 2>/dev/null; fmt || true; home-manager switch --accept-flake-config --impure --flake 'path:/home/ang3lo/nix-config#ang3lo'";
    update = "(cd ~/nix-config && git submodule update --remote pkgs/ang3lo-nur pkgs/th3m1ghtyduck-nur && nix flake update ang3lo-nur th3m1ghtyduck-nur --accept-flake-config && nix flake update --accept-flake-config)";
    upgrade = "sudo -v && git -C ~/nix-config pull && git -C ~/nix-config submodule update --remote pkgs/ang3lo-nur pkgs/th3m1ghtyduck-nur && (cd ~/nix-config && nix flake update ang3lo-nur th3m1ghtyduck-nur --accept-flake-config) && rebuild";
    u = "upgrade";
    rb = "rebuild";

    # Backup related aliases
    backup-all = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-nas.service restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service restic-backups-gdrive-shared.service && echo \"Backups started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl --output=with-unit -u restic-backups-nas.service -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
    backup-nas = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-nas.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-nas.service && echo \"NAS Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-nas.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
    backup-gdrive = "echo \"Manually triggering Server-Side Mirror from Shared Drive to Personal Drive...\" && sudo rclone sync -v --drive-server-side-across-configs --config /run/agenix/rclone-conf gdrive_shared_drive:/backups/pc-angelo gdrive:/backups/pc-angelo";
    backup-shared = "bash -c 'trap \"kill 0 2>/dev/null\" EXIT; (while sleep 15; do sudo systemctl kill -s USR1 --kill-who=main restic-backups-gdrive-shared.service 2>/dev/null || true; done) & sudo systemctl start --no-block restic-backups-gdrive-shared.service && echo \"Shared Drive Backup started. Auto-pinging progress every 15s. (Press Ctrl+C to stop watching):\" && journalctl -u restic-backups-gdrive-shared.service -f | grep --line-buffered -v \"signal SIGUSR1\" | grep --line-buffered -v \"]: /\"'";
  };
}
