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
  options.services.nextcloud-native = {
    enable = mkEnableOption "Nextcloud (file sync and collaboration)";
    domain = mkOption {
      type = types.str;
      description = "Domain for Nextcloud";
      example = "nextcloud.example.com";
    };
    adminUser = mkOption {
      type = types.str;
      default = "admin";
      description = "Admin username";
    };
    adminPasswordFile = mkOption {
      type = types.str;
      description = "File containing admin password";
      example = "/run/secrets/nextcloud_admin_password";
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/nextcloud";
      description = "Data directory for Nextcloud files";
    };
  };

  config = mkIf config.services.nextcloud-native.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      hostName = config.services.nextcloud-native.domain;
      https = true;
      autoUpdateApps.enable = true;
      autoUpdateApps.autoRestartAfterUpdate = true;
      maxUploadSize = "512G";
      
      config = {
        adminuser = config.services.nextcloud-native.adminUser;
        adminpassFile = config.services.nextcloud-native.adminPasswordFile;
        dbtype = "pgsql";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        overwriteProtocol = "https";
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
    };

    services.nginx.virtualHosts."${config.services.nextcloud-native.domain}" = {
      forceSSL = true;
      enableACME = true;
    };

    systemd.tmpfiles.rules = [
      "d ${config.services.nextcloud-native.dataDir} 0700 nextcloud nextcloud -"
    ];
  };
}
