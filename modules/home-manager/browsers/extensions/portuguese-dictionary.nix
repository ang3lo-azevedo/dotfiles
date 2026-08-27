{pkgs, ...}: {
  my.browsers.extensions.portuguese-dictionary = {
    firefoxPackage = pkgs.firefoxAddons.european-portuguese-spellcheck;
    chromeId = null;
  };
}
