{
  # https://kb.mozillazine.org/About:config_entries

  # Enable auto-scroll by middle-clicking
  "general.autoScroll" = true;

  # Enable Ctrl+Tab to switch tabs by recently used order
  "browser.ctrlTab.sortByRecentlyUsed" = true;

  # Ask where to save each file before downloading
  "browser.download.useDownloadDir" = false;

  # "Touchy" UI Density
  "browser.uidensity" = 2;

  # Restore previous session on startup
  "zen.workspaces.continue-where-left-off" = true;

  # Vertical tabs on the right side
  "zen.tabs.vertical.right-side" = true;

  # Enable compact mode
  "zen.view.compact.enable-at-startup" = true;

  # Always open the URL bar in floating mode
  "zen.urlbar.behavior" = "float";

  # optional: without this the addons need to be enabled manually after first install
  "extensions.autoDisableScopes" = 0;

  # Restore pinned tabs to their pinned URL on startup
  "pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;

  # Encrypted Client Hello: hides the SNI field from ISPs during TLS handshake
  "network.dns.echconfig.enabled" = true;

  # Required for ECH, fetch HTTPS DNS records that carry the ECH config
  "network.dns.use_https_rr_as_altsvc" = true;

  # Use Mullvad DoH as the browser's internal resolver (needed to fetch HTTPS DNS records)
  # Mode 2, use DoH with fallback to system DNS if unreachable
  "network.trr.mode" = 2;
  "network.trr.uri" = "https://dns.quad9.net/dns-query";

  # Show a warning bar when DoH is unavailable and the browser falls back to system DNS
  "network.trr.display_fallback_warning" = true;

  # Don't use separate \default search engines for private windows
  "browser.search.separatePrivateDefault" = false;

  # Enable search suggestions in the URL bar
  "browser.search.suggest.enabled" = true;

  # Enable search suggestions in private windows
  "browser.search.suggest.enabled.private" = true;

  # Ensure camera/microphone capture stays enabled in Zen.
  "media.navigator.enabled" = true;
  "media.peerconnection.enabled" = true;
  # Only expose the default route IP to WebRTC, not all local interfaces.
  # Prevents sites from discovering LAN IPs via ICE candidates.
  "media.peerconnection.ice.default_address_only" = true;
  # Route camera capture through PipeWire instead of direct V4L2, required on Wayland
  "media.webrtc.camera.allow-pipewire" = true;
  # 0 = ask each time (prompt), 1 = allow always, 2 = block always
  "permissions.default.camera" = 0;
  "permissions.default.microphone" = 0;
}
