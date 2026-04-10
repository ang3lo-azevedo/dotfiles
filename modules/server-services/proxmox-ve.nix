{
  services.proxmox-ve = {
    enable = true;
    # Replace with this node's LAN IP used by other hosts to reach Proxmox.
    ipAddress = "REPLACE_WITH_SERVER_LAN_IP";
    # Add your bridge names here once configured (e.g. [ "vmbr0" ]).
    bridges = [ ];
  };
}
