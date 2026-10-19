{pkgs, ...}: let
  autopsy = pkgs.unstable.autopsy;

  # The package ships no desktop entry and only a Windows .ico, so its 256px
  # layer is turned into a PNG the launchers can show
  icon = pkgs.runCommand "autopsy-icon.png" {nativeBuildInputs = [pkgs.imagemagick];} ''
    magick '${autopsy}/icon.ico[0]' $out
  '';
in {
  home.packages = [autopsy];

  xdg.desktopEntries.autopsy = {
    name = "Autopsy";
    exec = "${autopsy}/bin/autopsy";
    icon = "${icon}";
    categories = ["System" "Utility"];
    comment = "Digital forensics platform for disk images and file systems";
  };
}
