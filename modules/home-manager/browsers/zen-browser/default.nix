{
  inputs,
  pkgs,
  lib,
  ...
}: let
  profileName = "ang3lo";
in {
  imports = [
    inputs.zen-browser.homeModules.beta
    ./extensions
    ./mods
    ./searxng-cookies.nix
  ];

  # installs.ini maps browser installation hashes to profiles and takes priority
  # over profiles.ini. Stale entries pointing to old profiles cause sessions to
  # open the wrong profile (no cookies/logins). Clear it whenever it doesn't
  # reference ang3lo so Firefox rebuilds it correctly from profiles.ini.
  home.activation.zenBrowserInstalls = lib.hm.dag.entryAfter ["writeBoundary"] ''
    _installs="$HOME/.config/zen/installs.ini"
    if [ -f "$_installs" ] && ! grep -q "Default=${profileName}" "$_installs" 2>/dev/null; then
      rm -f "$_installs"
    fi
  '';

  _module.args.profileName = profileName;

  stylix.targets.zen-browser.profileNames = [profileName];

  programs.zen-browser = {
    enable = true;
    profiles.${profileName} =
      {
        extensions.force = true;
        # Imported as plain attrsets, not modules: settings.nix returns an attrset of
        # about:config prefs, search.nix returns the search engine configuration.
        settings = import ./settings.nix;
        search = import ./search.nix {inherit pkgs;};
      }
      // import ./spaces {inherit (pkgs) lib;};
  };

  xdg.mimeApps = let
    value = let
      zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta; # or twilight
    in
      if zen-browser.meta ? desktopFileName
      then [zen-browser.meta.desktopFileName]
      else ["zen-beta.desktop"];

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
