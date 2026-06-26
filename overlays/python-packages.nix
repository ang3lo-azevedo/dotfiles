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
}
