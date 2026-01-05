{ inputs, pkgs, ... }:
let
  profileName = "ang3lo";
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./extensions
  ];

  _module.args.profileName = profileName;

  stylix.targets.zen-browser.profileNames = [ profileName ];

  programs.zen-browser = {
    enable = true;
    profiles.${profileName} = {
      extensions.force = true;
      settings = import ./settings.nix;
      search = import ./search.nix { inherit pkgs; };
    }
    // import ./spaces { inherit (pkgs) lib; };
  };
}
