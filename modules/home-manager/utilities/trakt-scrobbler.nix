{ pkgs, ... }:

{
  home.packages = [ pkgs.trakt-scrobbler ];

  systemd.user.services.trakt-scrobbler = {
    Unit = {
      Description = "Trakt Scrobbler Service";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "${pkgs.trakt-scrobbler}/bin/trakts run";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}