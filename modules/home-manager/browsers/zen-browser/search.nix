{ pkgs, ... }:
{
  force = true; # Needed for nix to overwrite search settings on rebuild
  default = "SearXNG";
  engines = {
    "SearXNG" = {
      urls = [{ template = "https://searxng.pi.at.eu.org/search?q={searchTerms}"; }];
      iconUpdateURL = "https://searxng.pi.at.eu.org/favicon.ico";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@sx" ];
    };

      # My nixos Option and package search shortcut
    mynixos = {
      name = "My NixOS";
      urls = [
        {
          template = "https://mynixos.com/search?q={searchTerms}";
          params = [
            {
              name = "query";
              value = "searchTerms";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@nx"]; # Keep in mind that aliases defined here only work if they start with "@"
    };
  };
}