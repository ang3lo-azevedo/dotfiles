{ pkgs, config, ... }:
let
  binjaZip = ./binaryninja_linux_stable_personal.zip;
  kgPath = ./keygen.py;
  kgExists = builtins.pathExists kgPath;
in
{
  home.file.".binaryninja/settings.json".text = builtins.toJSON {
    "python.binaryOverride" = "${pkgs.python312}/bin/python3.12";
    "python.interpreter" = "${pkgs.python312}/lib/libpython3.12.so";
  };

  programs.binary-ninja = {
    enable = true;
    package = (pkgs.binary-ninja-personal-wayland.override {
      overrideSource = binjaZip;
      python3 = pkgs.python312;

      # TODO: Remove this override once the upstream package is updated to work with the latest xorg server.
      xorg = pkgs.xorg // {
        libXi = pkgs.libxi;
        libXrender = pkgs.libxrender;
        xcbutilimage = pkgs.libxcb-image;
        xcbutilrenderutil = pkgs.libxcb-render-util;
      };
    }).overrideAttrs (old: {
      # Use Python 3.12 for Sidekick plugin compatibility (requires 3.10-3.12)
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.python312Packages.pycryptodome pkgs.makeWrapper ];

      postInstall = (old.postInstall or "") + (if kgExists then ''
        # Binary Ninja typically installs into $out/opt/binaryninja
        if [ -d "$out/opt/binaryninja" ]; then
          cp ${kgPath} "$out/opt/binaryninja/script.py"
          cd "$out/opt/binaryninja"
          ${pkgs.python312}/bin/python3 ./script.py
        fi
      '' else "");

      postFixup = (old.postFixup or "") + ''
        # Wrap the main binary to use Python 3.12 at runtime
        if [ -f "$out/bin/binaryninja" ]; then
          wrapProgram "$out/bin/binaryninja" \
            --set-default PYTHON ${pkgs.python312}/bin/python3 \
            --prefix PATH : ${pkgs.python312}/bin \
            --prefix PYTHONPATH : ${config.home.sessionVariables.PYTHONPATH}
        fi

        # Fix the icon path in the existing desktop entry
        if [ -f "$out/share/applications/Binary Ninja.desktop" ]; then
          sed -i 's|^Icon=.*|Icon='"$out"'/share/pixmaps/binaryninja.png|' "$out/share/applications/Binary Ninja.desktop"
        fi
      '';
    });
  };
}