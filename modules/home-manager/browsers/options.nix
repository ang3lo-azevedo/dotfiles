{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.my.browsers = {
    extensions = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          firefoxPackage = mkOption {
            type = types.nullOr types.package;
            default = null;
            description = "The Nix package for the Firefox add-on (.xpi).";
          };
          chromeId = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "The ID of the extension in the Chrome Web Store.";
          };
        };
      });
      default = {};
      description = "Shared browser extensions.";
    };
    search = {
      name = mkOption {
        type = types.str;
        default = "SearXNG";
        description = "Name of the default search engine.";
      };
      url = mkOption {
        type = types.str;
        default = "https://searxng.pi.at.eu.org/search?q={searchTerms}";
        description = "URL of the search engine with {searchTerms} placeholder.";
      };
      icon = mkOption {
        type = types.str;
        default = "https://searxng.pi.at.eu.org/favicon.ico";
        description = "Icon URL for the search engine.";
      };
    };
  };
}
