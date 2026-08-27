{pkgs, ...}: {
  my.browsers.extensions.user-agent-switcher = {
    firefoxPackage = pkgs.firefoxAddons.user-agent-string-switcher;
    chromeId = "djflhoibgkdhkhhcedjiklpkjnoahfmg";
  };
}
