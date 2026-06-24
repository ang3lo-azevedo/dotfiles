{config, ...}: let
  gitConfigPath =
    if config ? osConfig
    then config.osConfig.age.secrets.git_config.path
    else "/run/agenix/git_config";
in {
  programs.git = {
    settings = {
      init.defaultBranch = "main";
    };
    includes = [
      {path = gitConfigPath;}
    ];
    enable = true;
    lfs.enable = true;
  };
}
