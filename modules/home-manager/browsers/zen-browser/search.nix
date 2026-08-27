{
  pkgs,
  config,
  ...
}: {
  force = true; # Needed for nix to overwrite search settings on rebuild
  default = config.my.browsers.search.name;
  engines = {
    "${config.my.browsers.search.name}" = {
      urls = [{template = config.my.browsers.search.url;}];
      icon = config.my.browsers.search.icon;
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = ["@sx"];
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
