{ pkgs, ... }:
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "wivrn-dashboard";
      paths = [ pkgs.wivrn-dashboard ];
      buildInputs = [ pkgs.qt5.qtquickcontrols2 ];
      postBuild = ''
        wrapProgram $out/bin/wivrn-dashboard \
          --prefix QT_PLUGIN_PATH : $out/lib/qt5/plugins
      '';
    })
  ];
}
