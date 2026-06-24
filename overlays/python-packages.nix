final: prev: {
  pythonPackagesExtensions =
    (prev.pythonPackagesExtensions or [])
    ++ [
      (python-final: python-prev: {
        # TODO: Remove this override when setuptools-scm is added to uefi-firmware-parser nativeBuildInputs upstream
        uefi-firmware-parser = python-prev.uefi-firmware-parser.overridePythonAttrs (old: {
          pyproject = true;
          build-system =
            (old.build-system or [])
            ++ [
              python-final.setuptools-scm
            ];
          nativeBuildInputs =
            (old.nativeBuildInputs or [])
            ++ [
              python-final.setuptools-scm
            ];
        });
      })
    ];
  python3Packages =
    prev.python3Packages
    // {
      # TODO: Remove this override when setuptools-scm is added to uefi-firmware-parser nativeBuildInputs upstream
      uefi-firmware-parser = prev.python3Packages.uefi-firmware-parser.overridePythonAttrs (old: {
        pyproject = true;
        build-system =
          (old.build-system or [])
          ++ [
            final.python3Packages.setuptools-scm
          ];
        nativeBuildInputs =
          (old.nativeBuildInputs or [])
          ++ [
            final.python3Packages.setuptools-scm
          ];
      });
    };

  python313Packages =
    prev.python313Packages
    // {
      # TODO: Remove this override when setuptools-scm is added to uefi-firmware-parser nativeBuildInputs upstream
      uefi-firmware-parser = prev.python313Packages.uefi-firmware-parser.overridePythonAttrs (old: {
        pyproject = true;
        build-system =
          (old.build-system or [])
          ++ [
            final.python313Packages.setuptools-scm
          ];
        nativeBuildInputs =
          (old.nativeBuildInputs or [])
          ++ [
            final.python313Packages.setuptools-scm
          ];
      });

      # TODO: Remove this override when rust tools are added to angr build dependencies upstream
      angr = prev.python313Packages.angr.overridePythonAttrs (old: {
        buildInputs =
          (old.buildInputs or [])
          ++ [
            final.python313Packages.setuptools-rust
            final.rustc
            final.cargo
          ];
        nativeBuildInputs =
          (old.nativeBuildInputs or [])
          ++ [
            final.python313Packages.setuptools-rust
            final.rustc
            final.cargo
          ];
      });
    };
}
