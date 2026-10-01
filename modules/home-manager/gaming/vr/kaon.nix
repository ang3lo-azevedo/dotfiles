{pkgs, ...}: {
  home.packages = with pkgs; [
    # Kaon is a Qt Quick app and takes its Controls style from
    # QT_STYLE_OVERRIDE. The session sets that to kvantum, which only exists as
    # a widget style, so Main.qml fails to load ("module kvantum is not
    # installed") and Kaon exits.
    (symlinkJoin {
      name = "kaon";
      paths = [xr.kaon];
      buildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/kaon --unset QT_STYLE_OVERRIDE
      '';
    })
  ];
}
