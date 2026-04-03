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
  options.services.redis-native = {
    enable = mkEnableOption "Redis service (native NixOS)";
    port = mkOption {
      type = types.int;
      default = 6379;
      description = "Redis port";
    };
  };

  config = mkIf config.services.redis-native.enable {
    services.redis = {
      servers."" = {
        enable = true;
        port = config.services.redis-native.port;
        save = [ [30 1] ]; # Save after 30s if 1+ keys changed
        logLevel = "warning";
      };
    };
  };
}
