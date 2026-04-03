{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.x-ui = {
    file = ./compose-files/x-ui/docker-compose.yml;
    dataDir = "x-ui";
  };
}
