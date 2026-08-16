{
  lib,
  python3Packages,
  customPython3Packages,
  callPackage,
  copyDesktopItems,
  makeDesktopItem,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  python3Packages.buildPythonApplication {
    pname = "registry-spy";
    version = sources.registry-spy.version;
    format = "setuptools";

    src = sources.registry-spy.src;

    nativeBuildInputs = with python3Packages; [setuptools] ++ [copyDesktopItems];

    propagatedBuildInputs = [
      python3Packages.pyside6
      customPython3Packages.python-registry
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "registry-spy";
        exec = "registryspy";
        desktopName = "Registry Spy";
        comment = "Cross-platform Windows Registry browser";
        categories = ["Utility" "System"];
      })
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
