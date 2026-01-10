{
  programs.git = {
    settings = {
      user = {
        name = "[REDACTED NAME]";
        email = "[REDACTED EMAIL]";
      };
      init.defaultBranch = "main";
    };
    enable = true;
    lfs.enable = true;
  };
}