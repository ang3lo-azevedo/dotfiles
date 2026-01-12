{ inputs, pkgs,... }:
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

  xdg.mimeApps = let
    value = let
      zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta; # or twilight
    in
      zen-browser.meta.desktopFileName;

    associations = builtins.listToAttrs (map (name: {
        inherit name value;
      }) [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "text/plain"
        "text/html"
      ]);
  in {
    associations.added = associations;
    defaultApplications = associations;
  };
}
