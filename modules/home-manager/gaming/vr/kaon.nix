{
  pkgs,
  inputs,
  ...
}: {
  # Kaon is a Qt Quick app and takes its Controls style from QT_STYLE_OVERRIDE.
  # The session sets that to kvantum, which only exists as a widget style, so
  # Main.qml fails to load ("module kvantum is not installed") and Kaon exits.
  # The unset is declared through nix-wrapper-modules rather than a hand-rolled
  # symlinkJoin + wrapProgram.
  home.packages = [
    (inputs.nix-wrapper-modules.lib.evalPackage [
      {inherit pkgs;}
      ({wlib, ...}: {
        imports = [wlib.modules.default];
        package = pkgs.xr.kaon;
        binName = "kaon";
        unsetVar = ["QT_STYLE_OVERRIDE"];
      })
    ])
  ];
}
