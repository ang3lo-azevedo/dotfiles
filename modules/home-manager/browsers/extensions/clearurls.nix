{pkgs, ...}: {
  my.browsers.extensions.clearurls = {
    firefoxPackage = pkgs.firefoxAddons.clearurls;
    chromeId = "lckanjgmijmafbedllaakclkaicjfmnk";
    chromiumUrl = "https://github.com/ClearURLs/Addon/releases/download/1.27.3/ClearURLs.zip";
    chromiumHash = "0j6iaqan18jdpwvmdvfq0ks4x24l99dvvd7v1wmmd3vx7sfqfp1d";
  };
}
