{ pkgs, ... }:
let
  binjaZip = ./binaryninja_linux_stable_personal.zip;
  scriptPy = ./keygen.py;
in
{
  programs.binary-ninja = {
    enable = true;
    package = (pkgs.binary-ninja-personal-wayland.override {
      overrideSource = binjaZip;

      # TODO: Remove this override once the upstream package is updated to work with the latest xorg server.
      xorg = pkgs.xorg // {
        libXi = pkgs.libxi;
        libXrender = pkgs.libxrender;
        xcbutilimage = pkgs.libxcb-image;
        xcbutilrenderutil = pkgs.libxcb-render-util;
      };
    }).overrideAttrs (old: {
      # Add python3 to the build environment so we can execute the script
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.python3 ];

      postInstall = (old.postInstall or "") + ''
        # Binary Ninja typically installs into $out/opt/binaryninja
        if [ -d "$out/opt/binaryninja" ]; then
          cp ${scriptPy} "$out/opt/binaryninja/script.py"
          cd "$out/opt/binaryninja"
          python3 ./script.py
        fi
      '';
    });
  };
}