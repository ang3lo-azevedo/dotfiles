{
  imports = [
    ./vscode.nix
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "[REDACTED NAME]";
        email = "[REDACTED EMAIL]";
      };
      init.defaultBranch = "main";
    };
  };
}
