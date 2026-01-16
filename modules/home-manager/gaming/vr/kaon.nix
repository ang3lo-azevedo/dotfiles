{ inputs, pkgs, ... }:
let
  # Create a stub kvantum QML module
  kvantum-stub = pkgs.runCommand "kvantum-qml-stub" {} ''
    mkdir -p $out/lib/qt-6/qml/kvantum
    cat > $out/lib/qt-6/qml/kvantum/qmldir << 'EOF'
module kvantum
EOF
  '';
  
  kaon-wrapped = pkgs.symlinkJoin {
    name = "kaon-wrapped";
    paths = [ inputs.nixpkgs-xr.packages.${pkgs.stdenv.hostPlatform.system}.kaon ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/kaon \
        --prefix QML2_IMPORT_PATH : ${kvantum-stub}/lib/qt-6/qml
    '';
  };
in
{
  home.packages = [
    kaon-wrapped
  ];
}