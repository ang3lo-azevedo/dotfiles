{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (wlr-layout-ui.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        sed -i 's/new_hyprland = not LEGACY/new_hyprland = False/' $out/lib/python*/site-packages/wlr_layout_ui/screens.py
      '';
    }))
  ];
}