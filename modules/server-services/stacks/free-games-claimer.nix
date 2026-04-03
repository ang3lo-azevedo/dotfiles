{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.free-games-claimer = {
    file = ./compose-files/free-games-claimer/docker-compose.yml;
    dataDir = "free-games-claimer";
    env = {
      COMPOSE_FILE = "docker-compose.yml:./stack.env";
    };
  };
}
