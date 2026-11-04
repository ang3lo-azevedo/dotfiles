{pkgs, ...}: let
  # The upstream package installs the icon only under share/pixmaps, which fuzzel's
  # themed lookup does not resolve, so Icon=bambu-studio shows no icon. Mirror the
  # 192x192 pixmap into hicolor (a size its index.theme lists) to fix that.
  bambu-studio = pkgs.symlinkJoin {
    name = pkgs.xddxdd.bambu-studio-bin.name;
    paths = [pkgs.xddxdd.bambu-studio-bin];
    postBuild = ''
      install -Dm444 ${pkgs.xddxdd.bambu-studio-bin}/share/pixmaps/bambu-studio.png \
        $out/share/icons/hicolor/192x192/apps/bambu-studio.png
    '';
  };
in {
  home.packages = [bambu-studio];
}
