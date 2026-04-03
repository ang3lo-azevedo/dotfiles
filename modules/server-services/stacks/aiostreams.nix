{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.aiostreams = {
    file = ./compose-files/aiostreams/docker-compose.yml;
    dataDir = "aiostreams";
    env = {
      COMPOSE_FILE = "docker-compose.yml:./stack.env";
    };
  };
}
