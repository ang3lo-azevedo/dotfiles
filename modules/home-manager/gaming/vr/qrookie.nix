{ pkgs, ... }:
let
  # Custom qcoro with Qml support enabled
  qcoro-with-qml = pkgs.qt6Packages.qcoro.overrideAttrs (oldAttrs: {
    cmakeFlags = [
      "-DQCORO_WITH_QML=ON"
      "-DBUILD_SHARED_LIBS=ON"
    ];
  });
in
{
  home.packages = with pkgs; [
    (glaumar_repo.qrookie.overrideAttrs (oldAttrs: {
      buildInputs = builtins.map (dep: 
        if dep.pname or "" == "qcoro" then qcoro-with-qml else dep
      ) (oldAttrs.buildInputs or []) ++ [ qt6.qtdeclarative ];
    }))
  ];
}