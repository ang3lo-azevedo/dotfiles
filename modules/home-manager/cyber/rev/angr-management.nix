{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "angr-management" ''
      exec env -u QT_STYLE_OVERRIDE -u QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE=Fusion ${angr-management}/bin/angr-management "$@"
    '')
  ];

  xdg.desktopEntries.angr-management = {
    name = "angr management";
    exec = "angr-management";
    icon = "application-x-executable";
    categories = [ "Development" "Utility" ];
    comment = "GUI for angr";
  };
}
