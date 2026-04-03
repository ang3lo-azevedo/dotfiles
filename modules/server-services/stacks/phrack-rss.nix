{config, lib, ...}:
{
  config.services.docker-compose-stacks.stacks.phrack-rss = {
    file = ./compose-files/phrack-rss/docker-compose.yml;
    dataDir = "phrack-rss";
  };
}
