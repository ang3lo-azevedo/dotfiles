{
  lib,
  python3Packages,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  python3Packages.buildPythonApplication rec {
    pname = "analyzeMFT";
    version = sources.analyzeMFT.version;
    format = "pyproject";

    src = sources.analyzeMFT.src;

    build-system = with python3Packages; [
      setuptools
      wheel
    ];

    dependencies = with python3Packages; [
      openpyxl
    ];

    meta = with lib; {
      description = "Parse and analyze NTFS Master File Table (MFT) files";
      homepage = "https://github.com/rowingdude/analyzeMFT";
      license = licenses.mit;
      maintainers = with maintainers; [];
      mainProgram = "analyzemft";
    };
  }
