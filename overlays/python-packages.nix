final: prev: let
  customOverrides = _pyFinal: pyPrev:
    {
      # Import our complex angr packaging fixes (commented out due to missing pyxdia in nixpkgs)
    }
    // (import ./angr.nix final _pyFinal pyPrev)
    // {
      # HACK: python-registry is broken in nixpkgs unstable because its derivation says 1.4
      # but the internal METADATA says 1.3.1. This causes pythonMetadataCheckPhase to fail.
      # Used by: Windows registry forensics tools (like volatility3).
      python-registry = pyPrev.python-registry.overridePythonAttrs (_: {
        version = "1.3.1";
        name = "python-registry-1.3.1";
      });
    };
in {
  customPythonOverrides = customOverrides;
  python3 = prev.python3.override {packageOverrides = customOverrides;};
  python3Packages = final.python3.pkgs;
  customPython3Packages = prev.python3Packages.overrideScope customOverrides;
  customPython313 = prev.python313.override {packageOverrides = customOverrides;};
  customPython313Packages = final.customPython313.pkgs;

  # HACK: anyio's test_tls_connectable fails on Python 3.12 in nixpkgs unstable
  # ("server_hostname can only be specified in client mode"), which breaks
  # everything on 3.12 that pulls httpx. Scoped to 3.12 so the cached builds
  # for the default Python keep their hashes. An extension rather than a
  # python312 override because netexec replaces packageOverrides with its own.
  # Used by: netexec, the reverser_ai Binary Ninja env.
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (_pyFinal: pyPrev: {
        anyio =
          if pyPrev.python.pythonVersion == "3.12"
          then
            pyPrev.anyio.overridePythonAttrs (old: {
              disabledTests = (old.disabledTests or []) ++ ["test_tls_connectable"];
            })
          else pyPrev.anyio;
      })
    ];

  # HACK: sage-tests fails in unstable with a permission error creating .pytest_cache.
  # We bypass this by completely disabling tests for sage.
  sage = prev.sage.override {requireSageTests = false;};
}
