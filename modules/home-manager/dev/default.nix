{ pkgs, ... }:
{
  imports = [
    ./code-editors
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Angelo Azevedo";
        email = "ang3lo@azevedos.eu.org";
      };
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [
    nixfmt-rfc-style
    nil
  ];
}
