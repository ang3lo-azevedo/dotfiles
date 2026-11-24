{
  lib,
  pkgs,
  config,
  ...
}: {
  # Persist the agy (Antigravity CLI) default execution mode. "accept-edits"
  # auto-applies file edits and still prompts before running commands.
  # Also set modelProvider = "gemini" to route requests through GOOGLE_GEMINI_BASE_URL.
  #
  # Unlike the IDE settings, agy rewrites this file at runtime (it appends to
  # trustedWorkspaces and permissions.allow as workspaces and commands are
  # approved), so we merge the single key with jq instead of copying a whole
  # file from the store, which would clobber those runtime additions.
  home.activation.antigravityCliSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settingsDir="${config.home.homeDirectory}/.gemini/antigravity-cli"
    settingsPath="$settingsDir/settings.json"

    $DRY_RUN_CMD mkdir -p "$settingsDir"

    if [ -f "$settingsPath" ]; then
      $DRY_RUN_CMD ${pkgs.jq}/bin/jq '.defaultMode = "accept-edits" | .modelProvider = "gemini"' "$settingsPath" > "$settingsPath.tmp"
      $DRY_RUN_CMD mv -f "$settingsPath.tmp" "$settingsPath"
    else
      $DRY_RUN_CMD echo '{"defaultMode":"accept-edits","modelProvider":"gemini"}' > "$settingsPath"
    fi
  '';
}
