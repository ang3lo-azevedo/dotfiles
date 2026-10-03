{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./options.nix
    ./extensions
    ./zen-browser
    ./helium-browser
  ];

  my.browsers.insecureOriginsAsSecure = ["http://pkappa.ecsc.pt"];

  home.packages = [
    (pkgs.ungoogled-chromium.override {
      commandLineArgs = let
        loadExtensionsFlag = import ./chromium-extensions.nix {inherit pkgs config lib;};
      in "--enable-features=WebRTCPipeWireCapturer ${loadExtensionsFlag}";
    })
  ];

  # Enforce "Use system title bar and borders" and Default Search Engine
  home.activation.chromiumPreferences = lib.hm.dag.entryAfter ["writeBoundary"] ''
    for dir in ~/.config/chromium ~/.config/net.imput.helium; do
      if [ -f "$dir/Default/Preferences" ]; then
        $DRY_RUN_CMD ${pkgs.jq}/bin/jq '
          .browser.custom_chrome_frame = false |
          .default_search_provider_data.mirrored_template_url_data = {
            "alternate_urls": [],
            "default_search_provider": {"context_menu_access_allowed": false, "enabled": true},
            "id": "0",
            "keyword": "searxng.pi.at.eu.org",
            "safe_for_autoreplace": true,
            "short_name": "SearXNG",
            "url": "https://searxng.pi.at.eu.org/search?q={searchTerms}"
          }
        ' "$dir/Default/Preferences" > "$dir/Default/Preferences.tmp" && \
        $DRY_RUN_CMD mv "$dir/Default/Preferences.tmp" "$dir/Default/Preferences"
      fi
    done
  '';
}
