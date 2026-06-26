{
  pkgs,
  config,
  lib ? pkgs.lib,
  ...
}: let
  binjaZip = ./binaryninja_linux_5.3.9434_personal.zip;
  kgPath = ../../../../../private/binary-ninja/keygen.py;
  kgExists = builtins.pathExists kgPath;
  binjaExists = builtins.pathExists binjaZip;
in {
  home.file.".binaryninja/settings.json".text = builtins.toJSON {
    "python.binaryOverride" = "${pkgs.python312}/bin/python3.12";
    "python.interpreter" = "${pkgs.python312}/lib/libpython3.12.so";
  };

  programs.binary-ninja = lib.mkIf binjaExists {
    enable = true;
    package =
      (pkgs.binary-ninja-personal-wayland.override {
        overrideSource = binjaZip;
        python3 = pkgs.python312;
      }).overrideAttrs (old: {
        # Use Python 3.12 for Sidekick plugin compatibility (requires 3.10-3.12)
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.python312Packages.pycryptodome pkgs.makeWrapper];

        autoPatchelfIgnoreMissingDeps =
          (old.autoPatchelfIgnoreMissingDeps or [])
          ++ [
            "libQt6WaylandEglClientHwIntegration.so.6"
          ];

        postInstall =
          (old.postInstall or "")
          + (
            if kgExists
            then ''
              # Binary Ninja typically installs into $out/opt/binaryninja
              if [ -d "$out/opt/binaryninja" ]; then
                cp ${kgPath} "$out/opt/binaryninja/script.py"
                cd "$out/opt/binaryninja"
                ${pkgs.python312}/bin/python3 ./script.py
              fi
            ''
            else ""
          );

        postFixup =
          (old.postFixup or "")
          + ''
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
