{pkgs, ...}: {
  my.browsers.extensions.pwnfox = {
    firefoxPackage = pkgs.firefoxAddons.pwnfox;
    chromeId = null;
  };
}
