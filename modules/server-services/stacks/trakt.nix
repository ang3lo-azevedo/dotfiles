{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.trakt = {
    file = ./compose-files/trakt/docker-compose.yml;
    dataDir = "trakt";
    env = {
      COMPOSE_FILE = "docker-compose.yml:./stack.env";
    };
  };
}
