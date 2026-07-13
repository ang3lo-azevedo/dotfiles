{
  # https://kb.mozillazine.org/About:config_entries

  # ===========================================================================
  # Preferences
  # ===========================================================================

  # UI / UX
  "general.autoScroll" = true;
  "browser.ctrlTab.sortByRecentlyUsed" = true;
  # "Touchy" UI density
  "browser.uidensity" = 2;
  # Open popups as tabs instead of new windows; restriction=0 applies to all popup types.
  # Downside: payment flows and OAuth dialogs that open as positioned popup windows
  # (Stripe, Google OAuth on some sites) open as full tabs; sites that check
  # window.opener may break.
  "browser.link.open_newwindow" = 3;
  "browser.link.open_newwindow.restriction" = 0;
  # Block all media autoplay (audio and video). Value 5 = block audio+video.
  # Downside: embedded players that expect autoplay won't start automatically.
  "media.autoplay.default" = 5;

  # Spellcheck
  "spellchecker.dictionary" = "pt-PT";
  "layout.spellcheckDefault" = 1;

  # Zen Browser
  "zen.workspaces.continue-where-left-off" = true;
  "zen.tabs.vertical.right-side" = true;
  "zen.view.compact.enable-at-startup" = true;
  "zen.urlbar.behavior" = "float";
  # Without this, extensions need to be enabled manually after first install
  "extensions.autoDisableScopes" = 0;
  "pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;

  # Downloads
  # Ask where to save each file before downloading
  "browser.download.useDownloadDir" = false;
  # Downside: prompts every time a new file type is encountered instead of using
  # the previously chosen handler; mildly repetitive for common types.
  "browser.download.always_ask_before_handling_new_types" = true;

  # Search
  "browser.search.separatePrivateDefault" = false;
  "browser.search.suggest.enabled" = true;
  "browser.search.suggest.enabled.private" = true;

  # Camera / microphone
  "media.navigator.enabled" = true;
  "media.peerconnection.enabled" = true;
  # Route camera capture through PipeWire instead of direct V4L2, required on Wayland
  "media.webrtc.camera.allow-pipewire" = true;
  # 0 = ask each time (prompt), 1 = allow always, 2 = block always
  "permissions.default.camera" = 0;
  "permissions.default.microphone" = 0;

  # ===========================================================================
  # Privacy & Security
  # ===========================================================================

  # Prevent websites from moving or resizing the browser window via JS
  "dom.disable_window_move_resize" = true;
  # Sites can trigger the Firefox UI tour; disabling removes that attack surface
  "browser.uitour.enabled" = false;
  # Remote debugging listens on a local port; disable unless actively developing
  "devtools.debugger.remote-enabled" = false;
  # Middle-clicking a tab searches clipboard contents, leaking it to the URL bar
  "browser.tabs.searchclipboardfor.middleclick" = false;
  # CSP violation reports sent to report-uri endpoints can be used to track users
  "security.csp.reporting.enabled" = false;
  # Don't pin downloaded files to the OS recent-documents list
  "browser.download.manager.addToRecentDocs" = false;

  # ---------------------------------------------------------------------------
  # No phone-home: studies, experiments, crash reports, captive portal
  # ---------------------------------------------------------------------------

  # Opt out of Firefox shield studies (A/B experiments that change browser behaviour)
  "app.shield.optoutstudies.enabled" = false;
  # Normandy can push and run arbitrary JS experiments without explicit user consent
  "app.normandy.enabled" = false;
  "app.normandy.api_url" = "";
  # Don't send crash report URLs or submit crash data to Mozilla
  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = false;
  # Captive portal and connectivity checks phone home on every network change.
  # Disabled would require manually navigating to an HTTP URL on hotel/airport WiFi
  # to trigger the redirect page. Kept at defaults so captive portals open automatically.
  # "captivedetect.canonicalURL" = "";
  # "network.captive-portal-service.enabled" = false;
  # "network.connectivity-service.enabled" = false;

  # ---------------------------------------------------------------------------
  # Safe browsing
  # ---------------------------------------------------------------------------

  # The local malware/phishing check is kept; only the remote hash lookup that
  # sends file metadata to Google on every download is disabled.
  # Downside: novel malware not yet in the local database won't be flagged.
  "browser.safebrowsing.downloads.remote.enabled" = false;

  # ---------------------------------------------------------------------------
  # Network: DoH, ECH, prefetch
  # ---------------------------------------------------------------------------

  # Encrypted Client Hello: hides the SNI field from ISPs during TLS handshake.
  # Requires HTTPS DNS records to deliver the ECH config.
  "network.dns.echconfig.enabled" = true;
  # Fetch HTTPS DNS records so ECH can activate. Goes through the system resolver
  # (dnscrypt-proxy), which caches aggressively — no per-query overhead after warmup.
  "network.dns.use_https_rr_as_altsvc" = true;
  # Use the system resolver (dnscrypt-proxy) instead of browser-level DoH.
  # Mode 2 (browser DoH) bypasses dnscrypt-proxy entirely, so its cache never helps
  # and HTTPS record queries go cold to Quad9 on every new domain — causing 20 s+ loads.
  # Mode 0 lets dnscrypt-proxy handle all DNS including HTTPS records, with caching.
  "network.trr.mode" = 0;
  # Fetches full page resources before the user navigates: real content leak to third-party servers.
  "network.prefetch-next" = false;
  # DNS-only prefetch: queries go to Quad9 over DoH regardless, so disabling adds no extra protection.
  # "network.dns.disablePrefetch" = true;
  # "network.dns.disablePrefetchFromHTTPS" = true;
  # Pre-resolves DNS only for hostnames already visible on the current page: no new exposure.
  # "network.predictor.enabled" = false;
  # Opens TCP connections to domains on the current page: server sees a SYN, not what was clicked.
  # "network.http.speculative-parallel-limit" = 0;
  # "browser.places.speculativeConnect.enabled" = false;
  "browser.urlbar.speculativeConnect.enabled" = false;
  # GIO protocol handlers (gvfs mounts, smb://, sftp://) can be abused to trigger
  # outbound connections; clearing the list removes the attack surface on Linux.
  # Downside: clicking smb:// or sftp:// links in web pages silently does nothing.
  "network.gio.supported-protocols" = "";

  # ---------------------------------------------------------------------------
  # URL bar: disable Mozilla's expanding suggestion features
  # ---------------------------------------------------------------------------

  # These send URL bar keystrokes to Mozilla/partners for trending searches,
  # weather, Yelp, Wikipedia, MDN, and sponsored results.
  "browser.urlbar.quicksuggest.enabled" = false;
  "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
  "browser.urlbar.suggest.quicksuggest.sponsored" = false;
  "browser.urlbar.trending.featureGate" = false;
  "browser.urlbar.addons.featureGate" = false;
  "browser.urlbar.amp.featureGate" = false;
  "browser.urlbar.importantDates.featureGate" = false;
  "browser.urlbar.market.featureGate" = false;
  "browser.urlbar.mdn.featureGate" = false;
  "browser.urlbar.weather.featureGate" = false;
  "browser.urlbar.wikipedia.featureGate" = false;
  "browser.urlbar.yelp.featureGate" = false;
  "browser.urlbar.yelpRealtime.featureGate" = false;

  # ---------------------------------------------------------------------------
  # Passwords
  # ---------------------------------------------------------------------------

  # Don't autofill saved passwords into forms (requires explicit user action).
  # Downside: one extra click per login, you must click the field and pick from
  # the popup instead of having it filled automatically.
  "signon.autofillForms" = false;
  # Don't capture credentials from forms that lack a <form> element
  "signon.formlessCapture.enabled" = false;
  # Block subresource requests (images, scripts) from triggering HTTP auth dialogs,
  # which can be used to silently ping an attacker-controlled server with credentials.
  # Downside: authenticated CDN assets that use HTTP Basic auth may fail silently.
  "network.auth.subresource-http-auth-allow" = 1;

  # ---------------------------------------------------------------------------
  # Session / disk
  # ---------------------------------------------------------------------------

  # Don't write form data, scroll position, or POST data to the session store.
  # Level 2 = don't store session data for any page (HTTPS or HTTP).
  # Downside: if Zen crashes mid-form, text you typed is not recoverable on relaunch.
  "browser.sessionstore.privacy_level" = 2;

  # ---------------------------------------------------------------------------
  # TLS / HTTPS / certificates
  # ---------------------------------------------------------------------------

  # Reject plain HTTP connections; show an error page instead of silently downgrading.
  # Downside: router admin UIs (http://192.168.1.1), local dev servers
  # (http://localhost:3000), and captive portal redirect pages all require clicking
  # through the error page.
  "dom.security.https_only_mode" = true;
  # Don't send a background HTTP request when upgrading to HTTPS, it would reveal
  # the site visit to network observers even if the HTTPS connection succeeds.
  "dom.security.https_only_mode_send_http_background_request" = false;
  # Replay requires an active attacker + non-idempotent endpoint hit within the same session window.
  # "security.tls.enable_0rtt_data" = false;
  # Require RFC 5746 safe TLS renegotiation; drop connections that don't support it.
  # Downside: breaks servers older than ~2010 that never patched CVE-2009-3555.
  "security.ssl.require_safe_negotiation" = true;
  # Show a broken padlock indicator for connections that use unsafe renegotiation
  "security.ssl.treat_unsafe_negotiation_as_broken" = true;
  # Enforce certificate pinning for built-in pins; reject MITM certs even from trusted CAs.
  # Downside: breaks corporate TLS inspection proxies that intercept pinned connections.
  "security.cert_pinning.enforcement_level" = 2;
  # Use CRLite for certificate revocation: a local bloom filter updated in the background,
  # faster and more reliable than live OCSP lookups (which can time out and fail open).
  "security.remote_settings.crlite_filters.enabled" = true;
  # Mode 2: enforce CRLite, fall back to OCSP only when filter has no data.
  "security.pki.crlite_mode" = 2;

  # ---------------------------------------------------------------------------
  # Tracking protection
  # ---------------------------------------------------------------------------

  # Strict ETP: blocks cross-site tracking cookies and known fingerprinters.
  # Downside: embedded Spotify/YouTube players lose login state across pages;
  # Disqus comment sections may not load while logged in; some SSO/OAuth
  # redirects that rely on third-party cookies fail entirely.
  "browser.contentblocking.category" = "strict";

  # ---------------------------------------------------------------------------
  # WebRTC
  # ---------------------------------------------------------------------------

  # Only expose the default route IP to WebRTC, not all local interfaces.
  # Prevents sites from discovering LAN IPs via ICE candidates, but LAN peer-to-peer
  # video calls fall back to relay servers adding latency. LAN IP leakage is a low
  # threat in practice, so the tradeoff is not worth it.
  # "media.peerconnection.ice.default_address_only" = true;

  # ---------------------------------------------------------------------------
  # Fingerprinting
  # ---------------------------------------------------------------------------

  # Granular fingerprint protection suite: spoofs canvas, WebGL, AudioContext,
  # screen size, CPU, device memory, timezone, UA, and color scheme.
  # Replaces the legacy privacy.resistFingerprinting — supports per-target overrides.
  # Downside: same as RFP (UTC timestamps, rounded window sizes, UA quirks, canvas noise).
  "privacy.fingerprintingProtection" = true;
  # Explicitly disable the legacy RFP — it can linger in prefs.js from old configs and
  # overrides everything above, including per-target overrides and content-override.
  # "privacy.resistFingerprinting" = false;
  # Remove color scheme spoofing so dark mode works, and explicitly add ScreenSize
  # because fingerprintingProtection's default set doesn't spoof screen.width/height
  # (only screen.avail* and window inner/outer sizes), leaving the raw display
  # resolution (2880x1800 on this machine) exposed as a near-unique metric.
  "privacy.fingerprintingProtection.overrides" = "-CSSPrefersColorScheme,+ScreenSize";
  # Force dark mode for page content regardless of fingerprinting protection state.
  # 0 = follow browser, 1 = light, 2 = dark, 3 = follow system
  "layout.css.prefers-color-scheme.content-override" = 2;

  # Spoof the WebGL unmasked vendor and renderer strings. fingerprintingProtection
  # randomises the WebGL *hash* per first-party domain but leaves the vendor/renderer
  # strings readable, contributing ~6 bits. These values match common Intel Mesa
  # configurations on Linux so they blend into the crowd without conflicting with
  # the Firefox/Linux user agent.
  "webgl.override-unmasked-vendor" = "Intel Open Source Technology Center";
  "webgl.override-unmasked-renderer" = "Mesa Intel(R) HD Graphics 620 (KBL GT2)";

  # ---------------------------------------------------------------------------
  # Containers
  # ---------------------------------------------------------------------------

  # Enable container tabs (site isolation per identity context)
  "privacy.userContext.enabled" = true;
  # Show the container tab UI in the toolbar and new-tab menu
  "privacy.userContext.ui.enabled" = true;

  # ---------------------------------------------------------------------------
  # Misc
  # ---------------------------------------------------------------------------

  # Show internationalized domain names in punycode in the URL bar.
  # Prevents homograph phishing (e.g. аpple.com with a Cyrillic 'а' looks identical).
  "network.IDN_show_punycode" = true;
  # Block JavaScript execution inside PDFs.
  # Downside: fillable PDF forms with calculated fields (tax forms, invoices with
  # auto-totals) won't compute; the fields accept input but formulas don't run.
  "pdfjs.enableScripting" = false;
  # Disable the Beacon API (navigator.sendBeacon): used to fire analytics pings on page
  # unload, bypassing normal request cancellation when the user navigates away.
  # Downside: self-hosted analytics (Plausible, Matomo) and some contact-form completion
  # tracking that you may intentionally want will also stop working.
  "beacon.enabled" = false;
  # Cross-origin referrer policy:
  # XOriginPolicy = 0: always send Referer cross-origin. Setting this to 2 (never
  # send) breaks OAuth/SSO flows; the identity provider receives no Referer on the
  # redirect and some implementations reject the request. Keeping at 0 preserves flows.
  # XOriginTrimmingPolicy = 2: even though the Referer is sent cross-origin, it is
  # trimmed to the bare origin (https://example.com); path and query string are not exposed.
  "network.http.referer.XOriginPolicy" = 0;
  "network.http.referer.XOriginTrimmingPolicy" = 2;
}
