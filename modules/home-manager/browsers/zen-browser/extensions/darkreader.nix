{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions = {
    packages = [ pkgs.firefoxAddons.darkreader ];
    settings = {
      "addon@darkreader.org".settings = {
        disabledFor = [
            "web.stremio.com"
            "app.mailbox.org"
            "docs.google.com"
            "github.com"
            "portainer.at.eu.org"
        ];
      };
    };
  };
}
