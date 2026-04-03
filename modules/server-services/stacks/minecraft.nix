{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.minecraft = {
    file = ./compose-files/minecraft/docker-compose.yml;
    dataDir = "minecraft";
  };
}
