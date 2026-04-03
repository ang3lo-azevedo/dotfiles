{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.adguardhome = {
    file = ./compose-files/adguardhome/docker-compose.yml;
    dataDir = "adguardhome";
  };
}
