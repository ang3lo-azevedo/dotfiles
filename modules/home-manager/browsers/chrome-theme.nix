{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.lib.stylix) colors;

  # Helper to convert a #RRGGBB hex string into a Chrome-compatible RGB array
  hexToRGB = hex: let
    # Ensure no # prefix
    cleanHex = lib.strings.removePrefix "#" hex;
    r = builtins.fromTOML "a = 0x${builtins.substring 0 2 cleanHex}";
    g = builtins.fromTOML "a = 0x${builtins.substring 2 2 cleanHex}";
    b = builtins.fromTOML "a = 0x${builtins.substring 4 2 cleanHex}";
  in [r.a g.a b.a];

  manifest = {
    manifest_version = 3;
    version = "1.0";
    name = "Stylix Theme";
    theme = {
      colors = {
        frame = hexToRGB colors.base00;
        frame_inactive = hexToRGB colors.base01;
        toolbar = hexToRGB colors.base01;
        ntp_text = hexToRGB colors.base05;
        ntp_background = hexToRGB colors.base00;
        bookmark_text = hexToRGB colors.base05;
        tab_text = hexToRGB colors.base05;
        tab_background_text = hexToRGB colors.base04;
      };
    };
  };
in
  pkgs.writeTextDir "manifest.json" (builtins.toJSON manifest)
