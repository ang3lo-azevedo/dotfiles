{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.letterboxd-trakt = {
    file = ./compose-files/letterboxd-trakt/docker-compose.yml;
    dataDir = "letterboxd-trakt";
  };
}
