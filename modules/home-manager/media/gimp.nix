{ pkgs, inputs, lib, ... }:
let
  photogimp = inputs.photogimp;
in
{
  home.packages = with pkgs; [
    gimp
  ];

  home.activation.photogimpConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    gimpConfigDir="$HOME/.config/GIMP"
    gimpProfileDir="$gimpConfigDir/3.0"

    if [ -e "$gimpConfigDir" ] && [ ! -d "$gimpConfigDir" ]; then
      $DRY_RUN_CMD rm -rf "$gimpConfigDir"
    fi

    if [ -L "$gimpProfileDir" ] || [ -f "$gimpProfileDir" ]; then
      $DRY_RUN_CMD rm -f "$gimpProfileDir"
    elif [ -d "$gimpProfileDir" ]; then
      $DRY_RUN_CMD rm -rf "$gimpProfileDir"
    fi

    $DRY_RUN_CMD mkdir -p "$gimpProfileDir"
    $DRY_RUN_CMD cp -r "${photogimp}/.var/app/org.gimp.GIMP/config/GIMP/3.0/." "$gimpProfileDir/"
    $DRY_RUN_CMD chmod -R u+rwX "$gimpProfileDir"
  '';

  home.file.".local/share/applications" = {
    source = "${photogimp}/.local/share/applications";
    recursive = true;
  };

  home.file.".local/share/icons" = {
    source = "${photogimp}/.local/share/icons";
    recursive = true;
  };
}