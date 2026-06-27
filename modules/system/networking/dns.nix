{
  lib,
  pkgs,
  ...
}: {
  # dnscrypt-proxy acts as a local DNS resolver that encrypts queries using DoH (DNS-over-HTTPS).
  # Unlike DoT (port 853), DoH sends DNS queries as regular HTTPS on port 443, ISPs cannot
  # distinguish it from normal web traffic and cannot block it without blocking all HTTPS.
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      # Listen on localhost so systemd-resolved can forward queries here
      listen_addresses = ["127.0.0.1:53" "[::1]:53"];

      # Both are DoH (HTTPS port 443, indistinguishable from web traffic), no-log, no-ECS.
      # Quad9: Swiss non-profit, ~69ms from PT. Mullvad: fallback, different jurisdiction.
      # Ad/tracker blocking is handled locally by the OISD blocklist.
      server_names = ["quad9-doh-ip4-filter-pri" "mullvad-doh"];

      # Only use servers that validate DNSSEC and have a strict no-log policy
      require_dnssec = true;
      require_nolog = true;

      # quad9 filters malware, which is fine since local OISD handles ads/trackers
      require_nofilter = false;

      # Block ads/trackers/malware, file populated by oisd-blocklist-update.service
      blocked_names.blocked_names_file = "/var/lib/dnscrypt-proxy/blocked-names.txt";

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
  systemd = {
    services = {
      dnscrypt-proxy = {
        after = ["time-sync.target"];
        wants = ["time-sync.target"];
        # Create blocklist file if missing so dnscrypt-proxy doesn't crash on first boot.
        # Runs as DynamicUser within the service namespace, so it can create files in the state dir.
        serviceConfig.ExecStartPre = pkgs.writeShellScript "ensure-blocklist" ''
          [ -f /var/lib/dnscrypt-proxy/blocked-names.txt ] || touch /var/lib/dnscrypt-proxy/blocked-names.txt
        '';
      };

      # Downloads the OISD big blocklist after dnscrypt-proxy is up, then restarts it
      # so the new rules take effect. Runs once 5 minutes after boot, then weekly.
      oisd-blocklist-update = {
        description = "Update OISD blocklist for dnscrypt-proxy";
        after = ["dnscrypt-proxy.service" "network-online.target"];
        wants = ["network-online.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "update-oisd-blocklist" ''
            dir=/var/lib/private/dnscrypt-proxy
            tmp=$(mktemp "$dir/blocked-names.XXXXXX")
            if ${pkgs.curl}/bin/curl -fsSL https://big.oisd.nl/domainswild -o "$tmp"; then
              mv "$tmp" "$dir/blocked-names.txt"
              chmod 644 "$dir/blocked-names.txt"
              systemctl restart dnscrypt-proxy
            else
              rm -f "$tmp"
            fi
          '';
        };
      };
    };
    timers.oisd-blocklist-update = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5min";
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
  };
}
