{pkgs, ...}: {
  my.browsers.extensions.claude-qol = {
    firefoxPackage = pkgs.firefoxAddons.claude-qol;
    chromeId = null;
  };
}
