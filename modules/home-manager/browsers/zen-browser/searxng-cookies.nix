{
  pkgs,
  lib,
  ...
}: let
  cols = "originAttributes, name, value, host, path, expiry, lastAccessed, creationTime, isSecure, isHttpOnly, sameSite, schemeMap";
  host = "searxng.pi.at.eu.org";
  ts = "cast(strftime('%s', 'now') as integer) * 1000000";
  expiry = "4070908800";

  ins = n: v: "INSERT OR REPLACE INTO moz_cookies (${cols}) VALUES ('', '${n}', '${v}', '${host}', '/', ${expiry}, ${ts}, ${ts}, 0, 0, 0, 0);";

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

  sqlFile = pkgs.writeText "searxng-cookies.sql" (lib.concatStringsSep "\n" (lib.mapAttrsToList ins cookies));
in {
  home.activation.searxngCookies = lib.hm.dag.entryAfter ["writeBoundary"] ''
    _profile="$HOME/.config/zen/ang3lo/cookies.sqlite"
    [ -f "$_profile" ] || exit 0
    ${pkgs.sqlite}/bin/sqlite3 "$_profile" < ${sqlFile} 2>/dev/null || true
  '';
}
