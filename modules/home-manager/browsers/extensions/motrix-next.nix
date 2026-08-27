{pkgs, ...}: {
  my.browsers.extensions.motrix-next = {
    firefoxPackage = pkgs.firefoxAddons.motrix-next-extension;
    chromeId = null;
  };
}
