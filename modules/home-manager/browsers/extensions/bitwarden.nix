{pkgs, ...}: {
  my.browsers.extensions.bitwarden = {
    firefoxPackage = pkgs.firefoxAddons.bitwarden-password-manager;
    chromeId = "nngceckbapebfimnlniiiahkandclblb";
  };
}
