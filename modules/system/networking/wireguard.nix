{pkgs, ...}: {
  # NetworkManager speaks WireGuard natively, so imported .conf profiles and
  # tunnels created with nmcli work without an extra plugin. wireguard-tools is
  # still what provides wg(8), wg-quick(8) and key generation.
  environment.systemPackages = [pkgs.wireguard-tools];

  # Declarative tunnels belong here. Use privateKeyFile with an agenix secret
  # rather than privateKey: the latter is inlined into a world readable path in
  # /nix/store. A server also needs its listen port opened in the firewall.
  #
  # networking.wireguard.interfaces.wg0 = {
  #   ips = ["10.0.0.2/24"];
  #   privateKeyFile = config.age.secrets.wireguard_key.path;
  #   peers = [
  #     {
  #       publicKey = "...";
  #       allowedIPs = ["0.0.0.0/0"];
  #       endpoint = "host:51820";
  #       persistentKeepalive = 25;
  #     }
  #   ];
  # };
}
