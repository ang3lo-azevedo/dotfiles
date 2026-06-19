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

  # Don't use separate default search engines for private windows
  "browser.search.separatePrivateDefault" = false;

  # Enable search suggestions in the URL bar
  "browser.search.suggest.enabled" = true;

  # Enable search suggestions in private windows
  "browser.search.suggest.enabled.private" = true;

  # Ensure camera/microphone capture stays enabled in Zen.
  "media.navigator.enabled" = true;
  "media.peerconnection.enabled" = true;
  "media.webrtc.camera.allow-pipewire" = true;
  "permissions.default.camera" = 0;
  "permissions.default.microphone" = 0;
}
