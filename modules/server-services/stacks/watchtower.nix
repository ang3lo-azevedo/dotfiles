{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.watchtower = {
    file = ./compose-files/watchtower/docker-compose.yml;
    dataDir = "watchtower";
  };
}
