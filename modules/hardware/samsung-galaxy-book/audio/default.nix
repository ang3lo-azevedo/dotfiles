{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.hardware.samsung-galaxy-book-audio;
  
  # Try to use the flake input script, fallback to local copy
  script = if builtins.pathExists inputs.samsung-audio-script
           then inputs.samsung-audio-script
           else ./necessary-verbs.sh;
in
{
  options.hardware.samsung-galaxy-book-audio = {
    enable = mkEnableOption "Enable audio fix for Samsung Galaxy Book";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.alsa-tools ];

    systemd.services.samsung-galaxy-book-audio-fix = {
      description = "Samsung Galaxy Book audio fix";
      after = [ "sound.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.alsa-tools ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/sh ${script}";
      };
    };
  };
}