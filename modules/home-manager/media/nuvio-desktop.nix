{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    (symlinkJoin {
      name = "nuvio-desktop";
      paths = [inputs.self.packages.${pkgs.system}.nuvio];
      buildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/nuvio \
          --unset WAYLAND_DISPLAY \
          --set XDG_SESSION_TYPE x11 \
          --set GDK_SCALE 2 \
          --set GDK_DPI_SCALE 2 \
          --set QT_SCALE_FACTOR 2 \
          --set QT_AUTO_SCREEN_SCALE_FACTOR 0 \
          --run 'export JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -Dsun.java2d.uiScale=2"'
      '';
    })
  ];
}
