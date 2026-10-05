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
      commandLineArgs = lib.concatStringsSep " " (import ./chromium-flags.nix {inherit pkgs config lib;});
    })
  ];

  # Chromium counterparts of zen-browser/settings.nix and search.nix, plus
  # "Use system title bar and borders". Only applied while the browser is
  # closed: a running instance rewrites Preferences on exit.
  home.activation.chromiumPreferences = let
    inherit (config.my.browsers) search;
    prefs = {
      browser = {
        custom_chrome_frame = false;
        enable_spellchecking = true;
      };
      spellcheck.dictionaries = ["pt-PT"];
      default_search_provider_data.mirrored_template_url_data = {
        alternate_urls = [];
        default_search_provider = {
          context_menu_access_allowed = false;
          enabled = true;
        };
        id = "0";
        keyword = builtins.head (builtins.match "[a-z]+://([^/]+).*" search.url);
        safe_for_autoreplace = true;
        short_name = search.name;
        inherit (search) url;
        favicon_url = search.icon;
      };
      search.suggest_enabled = true;
      download.prompt_for_download = true;
      session.restore_on_startup = 1;
      enable_a_ping = false;
      # 2 = never preload pages
      net.network_prediction_options = 2;
      profile = {
        # 1 = block third-party cookies
        cookie_controls_mode = 1;
        # 2 = block
        default_content_setting_values = {
          notifications = 2;
          geolocation = 2;
        };
      };
    };
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      for dir in ~/.config/chromium ~/.config/net.imput.helium; do
        if [ -f "$dir/Default/Preferences" ]; then
          $DRY_RUN_CMD ${pkgs.jq}/bin/jq --argjson prefs ${lib.escapeShellArg (builtins.toJSON prefs)} \
            '. * $prefs' "$dir/Default/Preferences" > "$dir/Default/Preferences.tmp" && \
          $DRY_RUN_CMD mv "$dir/Default/Preferences.tmp" "$dir/Default/Preferences"
        fi
      done
    '';
}
