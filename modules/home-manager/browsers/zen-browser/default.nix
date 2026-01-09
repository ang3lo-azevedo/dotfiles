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


 # Use Zen Browser Beta as the default browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-browser-beta.desktop";
      "x-scheme-handler/http" = "zen-browser-beta.desktop";
      "x-scheme-handler/https" = "zen-browser-beta.desktop";
      "x-scheme-handler/about" = "zen-browser-beta.desktop";
      "x-scheme-handler/unknown" = "zen-browser-beta.desktop";
    };
  };
}
