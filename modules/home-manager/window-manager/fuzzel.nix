{
  config,
  lib,
  ...
}: let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/${path}";
in {
  programs.fuzzel.enable = true;
  # Disable stylix theming so the hand-crafted fuzzel.ini colors are not overwritten
  stylix.targets.fuzzel.enable = false;

  # mkOutOfStoreSymlink points at the live repo path so edits to fuzzel.ini take effect
  # without a rebuild. mkForce overrides the source set by programs.fuzzel or stylix.
  xdg.configFile."fuzzel/fuzzel.ini" = lib.mkForce {source = mkSymlink "fuzzel/fuzzel.ini";};
  xdg.configFile."fuzzel/scripts" = lib.mkForce {source = mkSymlink "fuzzel/scripts";};
}
