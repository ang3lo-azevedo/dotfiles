{
  lib,
  stdenv,
  makeWrapper,
  chromium,
  chromedriver,
  python312,
  src,
}: let
  pythonEnv = python312.withPackages (ps:
    with ps; [
      selenium
      tkinter
      requests
      beautifulsoup4
    ]);
in
  stdenv.mkDerivation {
    pname = "ist-fenix-auto-enroller";
    version = "1.0.0";
    inherit src;

    nativeBuildInputs = [makeWrapper];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      appdir="$out/share/ist-fenix-auto-enroller"
      mkdir -p "$appdir"
      cp -r main.py src "$appdir"/

      makeWrapper ${pythonEnv}/bin/python "$out/bin/ist-fenix-auto-enroller" \
        --add-flags "$appdir/main.py" \
        --set CHROME_BIN ${chromium}/bin/chromium \
        --set CHROMEDRIVER_PATH ${chromedriver}/bin/chromedriver \
        --prefix PATH : ${lib.makeBinPath [chromium chromedriver]}

      runHook postInstall
    '';

    meta = {
      description = "Automatically enroll in IST Fénix shifts";
      homepage = "https://github.com/ang3lo-azevedo/ist-fenix-auto-enroller";
      license = lib.licenses.mit;
      mainProgram = "ist-fenix-auto-enroller";
      platforms = lib.platforms.linux;
    };
  }
