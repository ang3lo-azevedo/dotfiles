{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  # HACK: the switch knob is hardcoded white, which vanishes on the white accent track
  zapfast = inputs.zapfast.packages.x86_64-linux.zapfast.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace src/ui/widgets.rs --replace-fail \
          'egui::Rgba::from(palette.secondary)..=egui::Rgba::from(Color32::WHITE),' \
          'egui::Rgba::from(palette.secondary)..=egui::Rgba::from(palette.on_accent),'
      '';
  });
  colors = config.lib.stylix.colors.withHashtag;

  # Bubbles, links, and read receipts are derived by ZapFast from surface and accent
  # dim must differ from surface_active or row metadata vanishes on the selected chat
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
      secondary = colors.base05;
      dim = colors.base04;
      accent = colors.base07;
      accent_hover = colors.base06;
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
