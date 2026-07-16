final: prev: {
  python313Packages = prev.python313Packages.overrideScope (pyFinal: pyPrev: {
    # TODO: Remove when nixpkgs adds rust/cargo to angr's build dependencies upstream
    angr = pyPrev.angr.overridePythonAttrs (old: {
      buildInputs =
        (old.buildInputs or [])
        ++ [
          pyFinal.setuptools-rust
          final.rustc
          final.cargo
        ];
      nativeBuildInputs =
        (old.nativeBuildInputs or [])
        ++ [
          pyFinal.setuptools-rust
          final.rustc
          final.cargo
        ];
    });

    # TODO: remove once fs 2.4.x migrates from pkg_resources to importlib.metadata upstream.
    # Two pkg_resources issues, both because setuptools is not in the build sandbox:
    # (1) fs/__init__.py (and opener/__init__.py) call declare_namespace -- strip those
    #     (Python 3.3+ native namespace packages, PEP 420, make this a no-op).
    # (2) fs/opener/registry.py uses pkg_resources.iter_entry_points at module level;
    #     migrate that call to importlib.metadata.entry_points (stdlib since Python 3.9)
    #     so import fs never requires setuptools. Tests skip (doInstallCheck=false) because
    #     test_opener.py still imports pkg_resources directly.
    fs = pyPrev.fs.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
                    find . -name '__init__.py' -exec sed -i '/pkg_resources.*declare_namespace/d' {} +
                    python3 - <<'PYEOF'
          import re
          with open('fs/opener/registry.py') as f:
              src = f.read()
          src = src.replace('import pkg_resources',
              'from importlib.metadata import entry_points as _metadata_entry_points')
          def _repl(m):
              args = [a.strip() for a in m.group(1).split(',', 1)]
              if len(args) == 1:
                  return 'iter(_metadata_entry_points(group={}))'.format(args[0])
              return 'iter(_metadata_entry_points(group={}, name={}))'.format(args[0], args[1])
          src = re.sub(r'pkg_resources\.iter_entry_points\(([^)]+)\)', _repl, src)
          with open('fs/opener/registry.py', 'w') as f:
              f.write(src)
          PYEOF
        '';
      doInstallCheck = false;
      propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [pyPrev.setuptools];
    });
  });

  # click-threading's test suite imports docs/conf.py which uses pkg_resources
  # (setuptools), not declared as a dependency. Broken under Python 3.14.
  # vdirsyncer → click-threading; remove once fixed upstream.
  python3Packages = prev.python3Packages.overrideScope (_: pyPrev: {
    click-threading = pyPrev.click-threading.overridePythonAttrs (_: {doCheck = false;});
  });
}
