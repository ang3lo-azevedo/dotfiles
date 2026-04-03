{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.minepanel = {
    file = ./compose-files/minepanel/docker-compose.yml;
    dataDir = "minepanel";
    env = {
      COMPOSE_FILE = "docker-compose.yml:./stack.env";
    };
  };
}
