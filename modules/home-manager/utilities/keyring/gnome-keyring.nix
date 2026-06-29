{pkgs, ...}: {
  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  home.packages = [
    pkgs.gcr
    pkgs.dconf
    pkgs.seahorse
  ];
}
