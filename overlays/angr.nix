final: pyFinal: pyPrev: {
  angr = pyPrev.angr.overridePythonAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        sed -i -E 's/(archinfo|cle|pyvex)==[0-9.]+/\1/' pyproject.toml
        sed -i 's/self.clex.filename = filename/if not isinstance(getattr(type(self.clex), "filename", None), property): self.clex.filename = filename/' angr/sim_type.py
        sed -i 's/self.clex.reset_lineno()/if hasattr(self.clex, "reset_lineno"): self.clex.reset_lineno()/' angr/sim_type.py
      '';
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (old) src;
      name = "angr-${old.version}";
      hash = "sha256-HnvNJW7Q3bWr2VxtM+Ux0gyDC5P5QlHjZwooyOkGaow=";
    };
    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ [
        pyFinal.setuptools-rust
        final.rustPlatform.cargoSetupHook
        final.rustc
        final.cargo
      ];
    dependencies =
      builtins.filter (p: (p.pname or "") != "ailment") (old.dependencies or [])
      ++ [
        pyFinal.lmdb
        pyFinal.msgspec
        pyFinal.pypcode
      ];
  });

  cle = pyPrev.cle.overridePythonAttrs (old: {
    version = "9.2.193";
    src = final.fetchPypi {
      pname = "cle";
      version = "9.2.193";
      sha256 = "5551287b59c4b30e25e872b8280932e7702077aab8016232bb0405c5cf73f0c3";
    };
    postPatch =
      (old.postPatch or "")
      + ''
        sed -i -E 's/arpy==[0-9.]+/arpy/g' pyproject.toml || true
        sed -i -E 's/arpy==[0-9.]+/arpy/g' setup.cfg || true
        sed -i 's/import pyxdia/pyxdia = None/g' cle/backends/pe/pe.py || true
        sed -i 's/import pyxdia/pyxdia = None/g' cle/backends/pe/pe_stubs.py || true
        sed -i '/from .uefi_firmware import UefiFirmware/d' cle/backends/__init__.py || true
        sed -i '/UefiFirmware,/d' cle/__init__.py || true
        sed -i '/UefiFirmware,/d' cle/backends/__init__.py || true
      '';
    dependencies =
      (old.dependencies or [])
      ++ [
        pyFinal.arpy
        pyFinal.minidump
        pyFinal.pyxbe
      ];
    pythonRemoveDeps = [
      "pyxdia"
      "uefi-firmware"
    ];
    pythonImportsCheck = [];
    doCheck = false;
  });

  archinfo = pyPrev.archinfo.overridePythonAttrs (_: {
    version = "9.2.193";
    src = final.fetchPypi {
      pname = "archinfo";
      version = "9.2.193";
      sha256 = "b46da3d0ee6cc7b46230c8e4f1dec9606b9acf814ea585ddaa794b82a7976628";
    };
  });

  pyvex = pyPrev.pyvex.overridePythonAttrs (old: {
    version = "9.2.193";
    src = final.fetchPypi {
      pname = "pyvex";
      version = "9.2.193";
      sha256 = "f097bf9aac73cc7e9d1fa1480375b11300bfa9f6b7740a953d3a036ea1b7a944";
    };
    preBuild = "";
    dontUseCmakeConfigure = true;
    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ [
        final.cmake
        final.ninja
      ];
    build-system =
      (old.build-system or [])
      ++ [
        pyFinal.scikit-build-core
        pyFinal.cffi
      ];
  });
}
