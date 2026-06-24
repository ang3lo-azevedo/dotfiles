{
  lib,
  python3Packages,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  python3Packages.buildPythonApplication {
    pname = "registry-spy";
    version = sources.registry-spy.version;
    format = "setuptools";

    src = sources.registry-spy.src;

    nativeBuildInputs = with python3Packages; [setuptools];

    propagatedBuildInputs = with python3Packages; [
      pyside6
      python-registry
    ];

    doCheck = false;

    meta = with lib; {
      description = "Cross-platform Windows Registry browser";
      homepage = "https://github.com/andyjsmith/Registry-Spy";
      license = licenses.gpl3;
      maintainers = [];
      platforms = platforms.all;
    };
  }
