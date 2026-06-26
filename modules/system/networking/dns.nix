{lib, ...}: {
  # dnscrypt-proxy acts as a local DNS resolver that encrypts queries using DoH (DNS-over-HTTPS).
  # Unlike DoT (port 853), DoH sends DNS queries as regular HTTPS on port 443, ISPs cannot
  # distinguish it from normal web traffic and cannot block it without blocking all HTTPS.
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      # Listen on localhost so systemd-resolved can forward queries here
      listen_addresses = ["127.0.0.1:53" "[::1]:53"];

      # Primary: Mullvad DoH, Sweden jurisdiction, no-log, no ECS.
      # Fallback: Quad9 DoH, Swiss non-profit, no-log, DNSSEC, blocks malware.
      # dnscrypt-proxy picks the fastest available and falls back automatically.
      server_names = ["mullvad-base-doh" "mullvad-doh" "quad9-doh-ip4-filter-pri"];

      # Only use servers that validate responses (DNSSEC) and have a no-log policy
      require_dnssec = true;
      require_nolog = true;

      # Must be false to allow filtering servers (mullvad-base filters by design)
      require_nofilter = false;

      # Fetch and cache the public list of verified DNS resolvers
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        # Refresh the resolver list every 72 hours
        refresh_delay = 72;
      };
    };
  };

  # systemd-resolved acts as a local stub resolver (caching, mDNS, per-interface DNS)
  # and forwards all queries to dnscrypt-proxy which handles the actual encryption
  services.resolved = {
    enable = true;
    settings.Resolve = {
      # dnscrypt-proxy handles DNSSEC validation upstream
      DNSSEC = "false";

      # No DoT here, encryption is handled by dnscrypt-proxy
      DNSOverTLS = "no";

      # Apply this DNS server to all domains
      Domains = "~.";

      # Forward all queries to dnscrypt-proxy running on localhost
      DNS = "127.0.0.1";

      # Fall back to Mullvad plain DNS if dnscrypt-proxy is unreachable.
      # Still no-log (same provider), just unencrypted, better than no DNS at all.
      FallbackDNS = "194.242.2.2";
    };
  };

  # Prevent NetworkManager from pushing DHCP-provided DNS servers into systemd-resolved,
  # which would bypass dnscrypt-proxy. mkForce overrides the default set by resolved.nix.
  networking.networkmanager.dns = lib.mkForce "none";

  # Delay dnscrypt-proxy until the clock is synced: it verifies TLS certificates
  # when downloading the resolver list, which fails if the clock is wrong at boot.
  systemd.services.dnscrypt-proxy.after = ["time-sync.target"];
  systemd.services.dnscrypt-proxy.wants = ["time-sync.target"];
}
