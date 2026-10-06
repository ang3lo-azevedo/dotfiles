{
  config,
  lib,
  pkgs,
  ...
}: let
  prefs = "${config.xdg.dataHome}/com.example.quickgui/shared_preferences.json";
in {
  home.packages = [pkgs.quickgui];

  # Quickgui rewrites this file at runtime, so it is only seeded when missing
  # instead of being linked read-only from the store.
  home.activation.quickguiWorkingDirectory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -e "${prefs}" ]; then
      run mkdir -p "$(dirname "${prefs}")"
      run sh -c 'printf "%s\n" "$1" > "$2"' sh \
        '{"flutter.workingDirectory":"${config.home.homeDirectory}/vms"}' "${prefs}"
    fi
  '';
}
