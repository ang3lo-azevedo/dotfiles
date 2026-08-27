{pkgs, ...}: {
  my.browsers.extensions.duckduckgo = {
    firefoxPackage = pkgs.firefoxAddons.duckduckgo-for-firefox;
    chromeId = "bkdgflcldnnnapblkhphbgpggdiikepg";
  };
}
