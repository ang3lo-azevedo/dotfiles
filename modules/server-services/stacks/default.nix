{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkDefault;
in
{
  imports = [
    ./redis.nix
    ./aiostreams.nix
    ./nextcloud.nix
    ./redlib.nix
    ./wetty.nix
    ./immich.nix
    ./pumpkin.nix
    ./vaultwarden.nix
    ./adguardhome.nix
    ./watchtower.nix
    ./grayjay.nix
    ./letterboxd-trakt.nix
    ./trakt.nix
    ./minepanel.nix
    ./minecraft.nix
    ./free-games-claimer.nix
    ./syncio.nix
    ./x-ui.nix
    ./phrack-rss.nix
  ];

  config = {
    # Enable docker-compose management
    services.docker-compose-stacks.enable = mkDefault true;
    services.docker-compose-stacks.dataDir = "/var/lib/docker-compose";
  };
}
