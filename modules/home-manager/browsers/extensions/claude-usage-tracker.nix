{pkgs, ...}: {
  my.browsers.extensions.claude-usage-tracker = {
    firefoxPackage = pkgs.firefoxAddons.claude-usage-tracker;
    chromeId = null;
  };
}
