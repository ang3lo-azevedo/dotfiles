{pkgs, ...}: {
  my.browsers.extensions.adnauseam = {
    firefoxPackage = pkgs.firefoxAddons.adnauseam;
    chromeId = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
    chromiumUrl = "https://github.com/gorhill/uBlock/releases/download/1.75.0/uBlock0_1.75.0.chromium.zip";
    chromiumHash = "10mmyiyfjfzl4lg7yf12m19mqf9lwha903lp4904s1yi15bzjg1r";
    chromiumSubfolder = "uBlock0.chromium";
  };
}
