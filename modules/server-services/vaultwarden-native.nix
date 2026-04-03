{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
in
{
  options.services.vaultwarden-native = {
    enable = mkEnableOption "Vaultwarden (Bitwarden-compatible password manager)";
    domain = mkOption {
      type = types.str;
      description = "Domain for Vaultwarden";
      example = "vaultwarden.example.com";
    };
    port = mkOption {
      type = types.int;
      default = 80;
      description = "Port to listen on";
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/vaultwarden";
      description = "Data directory";
    };
  };

  config = mkIf config.services.vaultwarden-native.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        domain = "https://${config.services.vaultwarden-native.domain}";
        signupsAllowed = false;
        invitationsAllowed = true;
        showPasswordHint = false;
        websocketEnabled = true;
        logFile = "/var/log/vaultwarden/vaultwarden.log";
      };
      dbBackend = "sqlite";
      dataDir = config.services.vaultwarden-native.dataDir;
    };

    systemd.tmpfiles.rules = [
      "d ${config.services.vaultwarden-native.dataDir} 0700 vaultwarden vaultwarden -"
      "d /var/log/vaultwarden 0700 vaultwarden vaultwarden -"
    ];
  };
}
