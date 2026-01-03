{
  users.users.ang3lo = {
    extraGroups = [ "nordvpn" ];
  };

  services.nordvpn = {
    enable = true;
    firewallChanges = true; # true by default
  };
}
