{pkgs, ...}: {
  my.browsers.extensions.gemini-voyager = {
    firefoxPackage = pkgs.firefoxAddons.gemini-voyager;
    chromeId = null;
  };
}
