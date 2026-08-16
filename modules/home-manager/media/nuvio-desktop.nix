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
          --run 'export JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -Dsun.java2d.uiScale=2"'
      '';
    })
  ];
}
