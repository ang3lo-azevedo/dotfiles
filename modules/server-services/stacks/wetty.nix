{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.wetty = {
    file = ./compose-files/wetty/docker-compose.yml;
    dataDir = "wetty";
  };
}
