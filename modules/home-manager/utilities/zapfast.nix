{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  zapfast = inputs.zapfast.packages.x86_64-linux.zapfast;
  colors = config.lib.stylix.colors.withHashtag;

  # Bubbles, links, and read receipts are derived by ZapFast from surface and accent
  themeFile = pkgs.writeText "zapfast-stylix.json" (builtins.toJSON {
    base =
      if config.stylix.polarity == "light"
      then "light"
      else "dark";
    colors = {
      window = colors.base00;
      panel = colors.base01;
      surface = colors.base02;
      surface_hover = colors.base03;
      surface_active = colors.base03;
      outline = colors.base03;
      text = colors.base05;
      secondary = colors.base04;
      dim = colors.base03;
      accent = colors.base0D;
      accent_hover = "${colors.base0D}d9";
      on_accent = colors.base00;
      danger = colors.base08;
      warning = colors.base0A;
      chat = colors.base00;
    };
  });
in {
  home.packages = [zapfast];

  # ZapFast skips symlinks when scanning its themes dir, so an xdg.configFile link is never listed
  home.activation.zapfastTheme = lib.hm.dag.entryAfter ["linkGeneration"] ''
    themesDir="${config.xdg.configHome}/zapfast/themes"
    $DRY_RUN_CMD mkdir -p "$themesDir"
    $DRY_RUN_CMD cp "${themeFile}" "$themesDir/.Stylix.json.tmp"
    $DRY_RUN_CMD chmod 644 "$themesDir/.Stylix.json.tmp"
    $DRY_RUN_CMD mv -f "$themesDir/.Stylix.json.tmp" "$themesDir/Stylix.json"
    $DRY_RUN_CMD ${zapfast}/bin/zapfast reload-themes >/dev/null 2>&1 || true
  '';
}
