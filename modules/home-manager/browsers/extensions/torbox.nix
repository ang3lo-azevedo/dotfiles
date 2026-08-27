{pkgs, ...}: {
  my.browsers.extensions.torbox = {
    firefoxPackage = pkgs.firefoxAddons.torbox-downloader;
    chromeId = null;
  };
}
