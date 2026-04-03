{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.syncio = {
    file = ./compose-files/syncio/docker-compose.yml;
    dataDir = "syncio";
    env = {
      COMPOSE_FILE = "docker-compose.yml:./stack.env";
    };
  };
}
