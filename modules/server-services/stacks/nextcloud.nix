{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.nextcloud = {
    file = ./compose-files/nextcloud/docker-compose.yml;
    dataDir = "nextcloud";
  };
}
