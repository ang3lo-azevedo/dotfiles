{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.vaultwarden = {
    file = ./compose-files/vaultwarden/docker-compose.yml;
    dataDir = "vaultwarden";
  };
}
