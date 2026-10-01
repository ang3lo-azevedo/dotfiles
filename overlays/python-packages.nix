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

  # HACK: sage-tests fails in unstable with a permission error creating .pytest_cache.
  # We bypass this by completely disabling tests for sage.
  sage = prev.sage.override {requireSageTests = false;};
}
