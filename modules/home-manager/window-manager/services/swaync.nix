{ pkgs, lib, config, ... }:
let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/${path}";
in
{
  services.swaync.enable = true;
  stylix.targets.swaync.enable = false;

  xdg.configFile."swaync/config.json" = lib.mkForce { source = mkSymlink "swaync/config.json"; };
  xdg.configFile."swaync/style.css" = lib.mkForce { source = mkSymlink "swaync/style.css"; };

  systemd.user.paths.swaync-config = {
    Unit.Description = "Watch SwayNC configuration for changes";
    Path.PathModified = [
      "/home/ang3lo/nix-config/home/ang3lo/.config/swaync/config.json"
      "/home/ang3lo/nix-config/home/ang3lo/.config/swaync/style.css"
    ];
    Path.Unit = "swaync-reload.service";
    Install.WantedBy = [ "swaync.service" ];
  };

  systemd.user.services.swaync-reload = {
    Unit.Description = "Reload SwayNC";
    Service.Type = "oneshot";
    Service.ExecStart = "${pkgs.bash}/bin/bash -c '${config.services.swaync.package}/bin/swaync-client -R && ${config.services.swaync.package}/bin/swaync-client -rs'";
  };
}
