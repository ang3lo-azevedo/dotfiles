{pkgs, ...}: {
  my.browsers.extensions.clearurls = {
    firefoxPackage = pkgs.firefoxAddons.clearurls;
    chromeId = "lckanjgmijmafbedllaakclkaicjfmnk";
  };
}
