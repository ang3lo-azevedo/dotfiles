{
  programs.git = {
    settings = {
      init.defaultBranch = "main";
    };
    includes = [
      { path = "/run/secrets/git_config"; }
    ];
    enable = true;
    lfs.enable = true;
  };
}