{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  # Built in pkgs/ang3lo-nur from the latest release tag, which nvfetcher tracks there.
  # The on-state switch knob is hardcoded white, which vanishes on the white
  # accent, so draw it in on_accent like every other shape on the accent
  zapfast = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zapfast.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace src/ui/widgets.rs \
          --replace-fail \
            'egui::Rgba::from(palette.secondary)..=egui::Rgba::from(Color32::WHITE)' \
            'egui::Rgba::from(palette.secondary)..=egui::Rgba::from(palette.on_accent)'
      '';
  });
  colors = config.lib.stylix.colors.withHashtag;

  # Links and read receipts are derived by ZapFast from accent. Bubbles are set explicitly:
  # derived ones blend toward the accent and wash out on the black chat
  # Selection sits on base02 per base16, keeping dim text (base03) readable on the selected chat.
  themeFile = pkgs.writeText "zapfast-stylix.json" (builtins.toJSON {
    base =
      if config.stylix.polarity == "light"
      then "light"
      else "dark";
    colors = {
      window = colors.base00;
      panel = colors.base00;
      surface = colors.base02;
      surface_hover = colors.base02;
      surface_active = colors.base02;
      outline = colors.base03;
      text = colors.base05;
      secondary = colors.base04;
      dim = colors.base03;
      accent = colors.base07;
      accent_hover = colors.base05;
      on_accent = colors.base00;
      danger = colors.base08;
      warning = colors.base0A;
      chat = colors.base00;
      bubble_in = colors.base01;
      bubble_out = colors.base02;
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
