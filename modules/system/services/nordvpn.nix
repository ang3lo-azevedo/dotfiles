{
  users.users.ang3lo = {
    extraGroups = [ "nordvpn" ];
  };

  chaotic.nordvpn.enable = true;

  networking.firewall = {
    checkReversePath = false;
    allowedTCPPorts = [ 443 ];
    allowedUDPPorts = [ 1194 ];
  };
}
