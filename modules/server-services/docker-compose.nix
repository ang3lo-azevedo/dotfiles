{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.docker-compose-stacks;
in
{
  options.services.docker-compose-stacks = {
    enable = mkEnableOption "Docker Compose Stacks Management";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/docker-compose";
      description = "Base directory for docker-compose stacks";
    };

    stacks = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkEnableOption "Docker Compose Stack" // { default = true; };
            file = mkOption {
              type = types.path;
              description = "Path to docker-compose.yml file";
            };
            dataDir = mkOption {
              type = types.str;
              default = "";
              description = "Data directory for this stack (relative to base dataDir)";
            };
            env = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Environment variables for this stack";
            };
          };
        }
      );
      default = { };
      description = "Docker Compose stacks to manage";
    };
  };

  config = mkIf cfg.enable {
    # Ensure Podman is enabled with Docker compatibility
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    # Create data directories
    systemd.tmpfiles.rules = 
      [ "d ${cfg.dataDir} 0755 root root -" ] ++
      (flatten (mapAttrsToList (name: stack:
        if (stack.enable && stack.dataDir != "") then
          [ "d ${cfg.dataDir}/${stack.dataDir} 0755 root root -" ]
        else
          [ ]
      ) cfg.stacks));

    # Create systemd services for each stack
    systemd.services = mapAttrs (name: stack:
      mkIf stack.enable {
        description = "Docker Compose Stack: ${name}";
        after = [ "network-online.target" "docker.service" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = stack.env // {
          COMPOSE_PROJECT_NAME = name;
        };

    preStart = ''
      mkdir -p ${cfg.dataDir}/${stack.dataDir}
      ${if lib.pathExists "${builtins.dirOf stack.file}/stack.env" then "cp ${builtins.dirOf stack.file}/stack.env ${builtins.dirOf stack.file}/.env" else ""}
    '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "${builtins.dirOf stack.file}";
          ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${stack.file} up -d";
          ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${stack.file} down";
          ExecReload = "${pkgs.docker-compose}/bin/docker-compose -f ${stack.file} up -d";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      }
    ) cfg.stacks;

    # Install docker-compose
    environment.systemPackages = with pkgs; [
      docker-compose
      docker
    ];
  };
}
