{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (let nuvio = callPackage ../../../pkgs/nuvio-desktop { }; in
      writeShellScriptBin "nuvio-desktop" ''
        # Adjust this factor if you want it larger/smaller
        SCALE=1.75
        export JAVA_TOOL_OPTIONS="''$JAVA_TOOL_OPTIONS -Dsun.java2d.uiScale=''$SCALE"

        exec ${nuvio}/bin/nuvio-desktop "$@"
      '')
  ];
}
