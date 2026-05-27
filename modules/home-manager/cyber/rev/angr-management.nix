{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "angr-management" ''
      exec env -u QT_STYLE_OVERRIDE -u QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE=Fusion ${angr-management}/bin/angr-management "$@"
    '')
  ];
}
