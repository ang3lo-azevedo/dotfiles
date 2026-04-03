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
  options.services.adguardhome-native = {
    enable = mkEnableOption "AdGuard Home (DNS filtering and ad blocking)";
    bindHost = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Host to bind to";
    };
    port = mkOption {
      type = types.int;
      default = 3000;
      description = "Web UI port";
    };
  };

  config = mkIf config.services.adguardhome-native.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
    };
  };
}
