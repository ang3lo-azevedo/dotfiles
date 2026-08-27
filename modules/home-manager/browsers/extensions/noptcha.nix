{pkgs, ...}: {
  my.browsers.extensions.noptcha = {
    firefoxPackage = pkgs.firefoxAddons.noptcha;
    chromeId = "dknlfmjaanfblgfdfebhijalfmhmjjjo";
  };
}
