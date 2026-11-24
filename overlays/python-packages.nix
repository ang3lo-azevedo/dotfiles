final: prev: let
  customOverrides = _pyFinal: pyPrev:
    {
      # Import our complex angr packaging fixes (commented out due to missing pyxdia in nixpkgs)
    }
    // (import ./angr.nix final _pyFinal pyPrev);
in {
  customPythonOverrides = customOverrides;
  python3 = prev.python3.override {packageOverrides = customOverrides;};
  python3Packages = final.python3.pkgs;
  customPython3Packages = prev.python3Packages.overrideScope customOverrides;
  customPython313 = prev.python313.override {packageOverrides = customOverrides;};
  customPython313Packages = final.customPython313.pkgs;
}
