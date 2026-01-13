{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.samsung-galaxy-book-audio;
  script = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/joshuagrisham/galaxy-book2-pro-linux/main/sound/necessary-verbs.sh";
    sha256 = "1ix9s9bkycl7af4bpfw23wq30z9db8syhgch57k7rkp0rags6zdw";
  };
in
{
  options.hardware.samsung-galaxy-book-audio = {
    enable = mkEnableOption "Enable audio fix for Samsung Galaxy Book";
  };

  config = mkIf cfg.enable {
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