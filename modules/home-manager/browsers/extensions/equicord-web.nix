{pkgs, ...}: {
  my.browsers.extensions.equicord-web = {
    firefoxPackage = pkgs.firefoxAddons.equicord-web;
    chromeId = null;
  };
}
