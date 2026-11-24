{pkgs, ...}: {
  my.browsers.extensions.rayburst-connect = {
    firefoxPackage = pkgs.firefoxAddons.rayburst-connect;
    chromeId = "kkpbgjlkgljjlhjpabgjfgacafcdiffl";
    chromiumUrl = "https://github.com/AnInsomniacy/rayburst-connect/releases/download/v2.2.1/rayburst-connect-2.2.1-chromium-mv3.zip";
    chromiumHash = "0624fknlnigvxnbyzr1ylx8322f52048fmx71440cj8pqwmf1jx4";
  };
}
