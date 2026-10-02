{
  pkgs,
  lib,
  ...
}: let
  cols = "originAttributes, name, value, host, path, expiry, lastAccessed, creationTime, updateTime, isSecure, isHttpOnly, sameSite, schemeMap";
  host = "searxng.pi.at.eu.org";
  now = "cast(strftime('%s', 'now') as integer)";
  ts = "${now} * 1000000";
  # Cookie DB schema 17 stores expiry in milliseconds (timestamps stay in
  # microseconds). A value in seconds is read as a 1970 date, so the row is
  # dropped as expired and takes the site-set cookie it replaced with it.
  # 400 days is the browser's own lifetime cap for cookies.
  expiry = "(${now} + 400 * 86400) * 1000";

  # sameSite=256 (unset) and schemeMap=2 (https) match what the site itself sets.
  ins = ctx: n: v: "INSERT OR REPLACE INTO moz_cookies (${cols}) VALUES ('${ctx}', '${n}', '${v}', '${host}', '/', ${expiry}, ${ts}, ${ts}, ${ts}, 0, 0, 256, 2);";

  cookies = {
    autocomplete = "google";
    categories = "general";
    center_alignment = "0";
    disabled_engines = "";
    disabled_plugins = "";
    doi_resolver = "oadoi.org";
    enabled_engines = "";
    enabled_plugins = "oa_doi_rewrite";
    favicon_resolver = "";
    hotkeys = "vim";
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

  # Single transaction: a locked database fails once instead of once per row,
  # and never leaves a half-written set of preferences.
  sqlFile = pkgs.writeText "searxng-cookies.sql" (lib.concatStringsSep "\n"
    (["BEGIN IMMEDIATE;"]
      ++ lib.concatLists (map (ctx: lib.mapAttrsToList (ins ctx) cookies) contexts)
      ++ ["COMMIT;"]));

  applyScript = pkgs.writeShellScript "searxng-cookies-apply" ''
    profile="$HOME/.config/zen/ang3lo/cookies.sqlite"
    [ -f "$profile" ] || exit 0
    if ! ${pkgs.sqlite}/bin/sqlite3 -bail "$profile" < ${sqlFile} 2>&1; then
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
