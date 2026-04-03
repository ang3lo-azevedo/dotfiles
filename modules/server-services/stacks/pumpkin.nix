{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.pumpkin = {
    file = ./compose-files/pumpkin/docker-compose.yml;
    dataDir = "pumpkin";
  };
}
