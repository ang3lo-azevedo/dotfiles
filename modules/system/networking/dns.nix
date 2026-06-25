{lib, ...}: {
  # dnscrypt-proxy acts as a local DNS resolver that encrypts queries using DoH (DNS-over-HTTPS).
  # Unlike DoT (port 853), DoH sends DNS queries as regular HTTPS on port 443, ISPs cannot
  # distinguish it from normal web traffic and cannot block it without blocking all HTTPS.
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      # Listen on localhost so systemd-resolved can forward queries here
      listen_addresses = ["127.0.0.1:53" "[::1]:53"];

      # Mullvad Base (blocks ads, trackers, and malware via DoH)
      # Sweden jurisdiction, no-log, no ECS (your IP is never forwarded to authoritative servers)
      server_names = ["mullvad-base-doh"];

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
      # No DoT here — encryption is handled by dnscrypt-proxy
      DNSOverTLS = "no";
      # Apply this DNS server to all domains
      Domains = "~.";
      # Forward all queries to dnscrypt-proxy running on localhost
      DNS = "127.0.0.1";
      # Disable fallback DNS, if dnscrypt-proxy is down, DNS should fail rather
      # than silently leaking queries to unencrypted servers
      FallbackDNS = "";
    };
  };

  # Prevent NetworkManager from pushing DHCP-provided DNS servers into systemd-resolved,
  # which would bypass dnscrypt-proxy. mkForce overrides the default set by resolved.nix.
  networking.networkmanager.dns = lib.mkForce "none";
}
