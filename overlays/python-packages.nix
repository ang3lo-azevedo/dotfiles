final: prev: {
  python313Packages =
    prev.python313Packages
    // {
      # TODO: Remove when nixpkgs adds rust/cargo to angr's build dependencies upstream
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

  # click-threading's test suite imports docs/conf.py which uses pkg_resources
  # (setuptools), not declared as a dependency. Broken under Python 3.14.
  # vdirsyncer → click-threading; remove once fixed upstream.
  python3Packages = prev.python3Packages.overrideScope (_: pyPrev: {
    click-threading = pyPrev.click-threading.overridePythonAttrs (_: {doCheck = false;});
  });
}
