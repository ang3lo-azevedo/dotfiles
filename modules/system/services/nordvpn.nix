{pkgs, ...}: {
  users.users.ang3lo = {
    extraGroups = ["nordvpn"];
  };

  environment.systemPackages = [pkgs.nordvpn];

  users.groups.nordvpn = {};

  systemd.services.nordvpn = {
    description = "NordVPN daemon.";
    serviceConfig = {
      ExecStart = "${pkgs.nordvpn}/bin/nordvpnd";
      ExecStartPre = pkgs.writeShellScript "nordvpn-start" ''
        mkdir -m 700 -p /var/lib/nordvpn;
        if [ -z "$(ls -A /var/lib/nordvpn)" ]; then
          cp -r ${pkgs.nordvpn}/var/lib/nordvpn/* /var/lib/nordvpn;
        fi
      '';
      NonBlocking = true;
      KillMode = "process";
      Restart = "on-failure";
      RestartSec = 5;
      RuntimeDirectory = "nordvpn";
      RuntimeDirectoryMode = "0750";
      Group = "nordvpn";
    };
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };

  networking.firewall = {
    checkReversePath = false;
    allowedTCPPorts = [443];
    allowedUDPPorts = [1194];
  };
}
