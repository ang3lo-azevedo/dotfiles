{
  lib,
  python3Packages,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  python3Packages.buildPythonApplication {
    pname = "ctfd-parser";
    version = sources.ctfd-parser.version;
    format = "other";

    src = sources.ctfd-parser.src;

    propagatedBuildInputs = with python3Packages; [
      requests
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/ctfd-parser $out/bin
      cp -r * $out/opt/ctfd-parser/
      chmod +x $out/opt/ctfd-parser/ctfd_parser.py
      ln -s $out/opt/ctfd-parser/ctfd_parser.py $out/bin/ctfd-parser
      runHook postInstall
    '';

    meta = with lib; {
      description = "A python script to dump all the challenges locally of a CTFd-based Capture the Flag.";
      homepage = "https://github.com/p0dalirius/ctfd-parser";
      license = licenses.gpl2Only;
      maintainers = [];
      platforms = platforms.all;
    };
  }
