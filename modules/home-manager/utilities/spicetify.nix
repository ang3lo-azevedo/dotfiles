{ spicetify-nix, ... }:
{
  imports = [
    spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
  };
}
