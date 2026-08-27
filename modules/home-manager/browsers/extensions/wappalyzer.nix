{pkgs, ...}: {
  my.browsers.extensions.wappalyzer = {
    firefoxPackage = pkgs.firefoxAddons.wappalyzer;
    chromeId = "gppongmhjkpfnbhagpmjfkannfbllamg";
  };
}
