{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.redlib = {
    file = ./compose-files/redlib/docker-compose.yml;
    dataDir = "redlib";
  };
}
