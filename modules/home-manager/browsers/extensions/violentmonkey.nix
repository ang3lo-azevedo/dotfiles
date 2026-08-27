{pkgs, ...}: {
  my.browsers.extensions.violentmonkey = {
    firefoxPackage = pkgs.firefoxAddons.violentmonkey;
    chromeId = "jinjaccalenkbemacfhnhbhgiignbcca";
  };
}
