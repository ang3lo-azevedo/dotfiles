{pkgs, ...}: {
  networking.networkmanager = {
    enable = true;
    plugins = [pkgs.networkmanager-openvpn];
  };

  environment.etc."ssl/certs/ist-eduroam.crt".source = pkgs.fetchurl {
    url = "https://si.tecnico.ulisboa.pt/configuracoes/cacert.crt";
    sha256 = "1yj2liyccwg6srxjzxfbk67wmkqdwxcx78khfi64ds8rgvs3n6hp";
  };
}
