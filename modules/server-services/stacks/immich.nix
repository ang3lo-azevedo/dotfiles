{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.immich = {
    file = ./compose-files/immich/docker-compose.yml;
    dataDir = "immich";
    env = {
      COMPOSE_FILE = "docker-compose.yml:./stack.env";
    };
  };
}
