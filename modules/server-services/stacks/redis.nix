{config, lib, ...}: 
let inherit (lib) mkDefault; in
{
  config.services.docker-compose-stacks.stacks.redis = {
    file = ./compose-files/redis/docker-compose.yml;
    dataDir = "redis";
    env = {
      TZ = "UTC";
    };
  };
}
