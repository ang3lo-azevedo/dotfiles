{pkgs, ...}: {
  my.browsers.extensions.darkreader = {
    firefoxPackage = pkgs.firefoxAddons.darkreader;
    chromeId = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
  };
}
