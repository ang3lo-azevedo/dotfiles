final: prev: {
  python313Packages = prev.python313Packages // {
    angr = prev.python313Packages.angr.overridePythonAttrs (old: {
      buildInputs = (old.buildInputs or []) ++ [
        final.python313Packages.setuptools-rust
        final.rustc
        final.cargo
      ];
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
        final.python313Packages.setuptools-rust
        final.rustc
        final.cargo
      ];
    });
  };
}

