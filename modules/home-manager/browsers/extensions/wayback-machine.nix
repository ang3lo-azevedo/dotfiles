{pkgs, ...}: {
  my.browsers.extensions.wayback-machine = {
    firefoxPackage = pkgs.firefoxAddons.wayback-machine_new;
    chromeId = "fpnmgdkabkmnadcjpehmlllkndpkmiak";
  };
}
