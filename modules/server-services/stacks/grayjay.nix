{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.grayjay = {
    file = ./compose-files/grayjay/docker-compose.yml;
    dataDir = "grayjay";
    env = {
      COMPOSE_FILE = "docker-compose.yml:./stack.env";
    };
  };
}
