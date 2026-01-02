{
  imports = [
    ./vscode.nix
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Angelo Azevedo";
        email = "ang3lo@azevedos.eu.org";
      };
      init.defaultBranch = "main";
    };
  };
}
