_: {
  # Use IP addresses for NTP so the clock syncs at boot even when DNS is broken.
  # Without this, dnscrypt-proxy fails TLS verification (cert "in the future") on boot
  # because the hardware clock is wrong, DNS breaks, and NTP can't resolve hostnames
  # to fix the clock, causing a boot-time deadlock.
  services.timesyncd = {
    enable = true;
    servers = [
      "194.242.2.4" # Mullvad, reachable by IP, no DNS needed
      "192.53.103.108" # PTB (Germany national metrology institute), reachable by IP, no DNS needed
    ];
    fallbackServers = [
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };
}
