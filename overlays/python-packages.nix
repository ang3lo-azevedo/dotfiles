final: prev: let
  customOverrides = _pyFinal: pyPrev: {
    # Import our complex angr packaging fixes (commented out due to missing pyxdia in nixpkgs)
    # } // (import ./angr.nix final _pyFinal pyPrev) // {

    # HACK: remove once fs 2.4.x migrates from pkg_resources to importlib.metadata upstream.
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

    # HACK: python-registry is broken in nixpkgs unstable because its derivation says 1.4
    # but the internal METADATA says 1.3.1. This causes pythonMetadataCheckPhase to fail.
    # Used by: Windows registry forensics tools (like volatility3).
    python-registry = pyPrev.python-registry.overridePythonAttrs (_: {
      version = "1.3.1";
      name = "python-registry-1.3.1";
    });
    # HACK: Python 3.14 removed setuptools (and pkg_resources) from the standard library.
    # wfuzz crashes with "ModuleNotFoundError: No module named 'pkg_resources'" without it.
    wfuzz = pyPrev.wfuzz.overridePythonAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace $(find . -name file_func.py | head -n 1) \
            --replace-fail "import pkg_resources" "import importlib.resources as pkg_resources" \
            --replace-fail "pkg_resources.resource_filename(\"wfuzz\", FILTER_HELP_FILE)" "str(pkg_resources.files(\"wfuzz\").joinpath(FILTER_HELP_FILE))"
        '';
    });
  };
in {
  customPythonOverrides = customOverrides;
  python3 = prev.python3.override {packageOverrides = customOverrides;};
  python3Packages = final.python3.pkgs;
  customPython3Packages = prev.python3Packages.overrideScope customOverrides;
  customPython313 = prev.python313.override {packageOverrides = customOverrides;};
  customPython313Packages = final.customPython313.pkgs;

  # HACK: Python 3.14 removed pkg_resources from setuptools.
  # wfuzz crashes with "ModuleNotFoundError: No module named 'pkg_resources'" without it.
  wfuzz = prev.wfuzz.overridePythonAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        sed -i 's/import pkg_resources/import importlib.resources as pkg_resources/g' src/wfuzz/helpers/file_func.py
        sed -i 's/pkg_resources.resource_filename("wfuzz", FILTER_HELP_FILE)/str(pkg_resources.files("wfuzz").joinpath(FILTER_HELP_FILE))/g' src/wfuzz/helpers/file_func.py
      '';
  });

  # HACK: sage-tests fails in unstable with a permission error creating .pytest_cache.
  # We bypass this by completely disabling tests for sage.
  sage = prev.sage.override {requireSageTests = false;};
}
