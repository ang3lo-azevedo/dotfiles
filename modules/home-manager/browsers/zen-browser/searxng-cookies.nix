{
  pkgs,
  lib,
  ...
}: let
  cols = "originAttributes, name, value, host, path, expiry, lastAccessed, creationTime, isSecure, isHttpOnly, sameSite, schemeMap";
  host = "searxng.pi.at.eu.org";
  ts = "cast(strftime('%s', 'now') as integer) * 1000000";
  expiry = "4070908800";

  ins = ctx: n: v: "INSERT OR REPLACE INTO moz_cookies (${cols}) VALUES ('${ctx}', '${n}', '${v}', '${host}', '/', ${expiry}, ${ts}, ${ts}, 0, 0, 0, 0);";

  cookies = {
    autocomplete = "google";
    categories = "general";
    center_alignment = "0";
    disabled_engines = "";
    disabled_plugins = "";
    doi_resolver = "oadoi.org";
    enabled_engines = "";
    enabled_plugins = "tor_check,oa_doi_rewrite";
    favicon_resolver = "";
    hotkeys = "default";
    image_proxy = "0";
    language = "auto";
    locale = "en";
    method = "POST";
    query_in_title = "0";
    results_on_new_tab = "0";
    safesearch = "0";
    search_on_category_select = "1";
    simple_style = "black";
    theme = "simple";
    tokens = "";
    url_formatting = "pretty";
  };

  # Insert cookies for every container context so preferences apply regardless
  # of which space (and thus which Firefox container) SearXNG is opened from.
  # originAttributes="" is the default (no container); "^userContextId=N" is container N.
  contexts = ["" "^userContextId=1"];

  sqlFile =
    pkgs.writeText "searxng-cookies.sql" (lib.concatStringsSep "\n"
      (lib.concatLists (map (ctx: lib.mapAttrsToList (ins ctx) cookies) contexts)));

  applyScript = pkgs.writeShellScript "searxng-cookies-apply" ''
    profile="$HOME/.config/zen/ang3lo/cookies.sqlite"
    [ -f "$profile" ] || exit 0
    if ! ${pkgs.sqlite}/bin/sqlite3 "$profile" < ${sqlFile} 2>&1; then
      echo "searxng-cookies: failed to write (browser may be open, will retry next login)" >&2
    fi
  '';
in {
  # Runs at each home-manager activation; fails visibly if the browser is open.
  home.activation.searxngCookies = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${applyScript}
  '';

  # Runs early in every graphical session, before the browser is open, so the
  # activation-time failure (browser was running during `home-manager switch`)
  # is always recovered on the next login.
  systemd.user.services.searxng-cookies = {
    Unit = {
      Description = "Write SearXNG preference cookies to Zen Browser profile";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${applyScript}";
      RemainAfterExit = false;
    };
    Install.WantedBy = ["graphical-session-pre.target"];
  };
}
