{
  pkgs,
  inputs,
  ...
}: {
  # nuvio wrapped for this HiDPI x11 setup. The wrapper is declared through
  # nix-wrapper-modules (env/unsetVar/runShell as options) rather than a
  # hand-rolled symlinkJoin + wrapProgram. evalPackage returns the final package.
  home.packages = [
    (inputs.nix-wrapper-modules.lib.evalPackage [
      {inherit pkgs;}
      ({wlib, ...}: {
        imports = [wlib.modules.default];
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nuvio;
        # The AppImage binary is $out/bin/nuvio; it carries no meta.mainProgram.
        binName = "nuvio";

        # Force x11 so the bundled app uses its xcb backend, with 2x scaling.
        unsetVar = ["WAYLAND_DISPLAY"];
        env = {
          XDG_SESSION_TYPE = "x11";
          GDK_SCALE = "2";
          GDK_DPI_SCALE = "2";
          QT_SCALE_FACTOR = "2";
          QT_AUTO_SCREEN_SCALE_FACTOR = "0";
        };
        # The JVM reads its own scale factor from JAVA_TOOL_OPTIONS; append so an
        # externally set value survives.
        runShell = [''export JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -Dsun.java2d.uiScale=2"''];
      })
    ])
  ];
}
