{pkgs, ...}: {
  my.browsers.extensions.adnauseam = {
    firefoxPackage = pkgs.firefoxAddons.adnauseam;
    chromeId = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
  };
}
