{ pkgs, ... }:
{
  # Wrap the nuvio-desktop launcher so we can force UI scaling for HiDPI
  # Compose/Java apps sometimes ignore desktop scaling; these envs + Java option
  # increase UI size without changing the package itself.
  home.packages = with pkgs; [
    (let nuvio = callPackage ../../../pkgs/nuvio-desktop { }; in
      writeShellScriptBin "nuvio-desktop" ''
        # Adjust this factor if you want it larger/smaller
        SCALE=1.5

        export QT_SCALE_FACTOR=\"\$SCALE\"
        export GDK_DPI_SCALE=\"\$SCALE\"
        export GDK_SCALE=\"$(echo \"\$SCALE\" | cut -d. -f1)\"
        export JAVA_TOOL_OPTIONS=\"\$JAVA_TOOL_OPTIONS -Dsun.java2d.uiScale=\$SCALE\"

        exec ${nuvio}/bin/nuvio-desktop \"\$@\"
      '')
  ];
}
