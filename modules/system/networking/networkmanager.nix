{pkgs, ...}: {
  networking.networkmanager = {
    enable = true;
    plugins = [pkgs.networkmanager-openvpn];
  };
}
