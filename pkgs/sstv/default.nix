{ lib
, python3Packages
, callPackage
}:

let
  sources = callPackage ../_sources/generated.nix { };
in
python3Packages.buildPythonApplication {
  pname = "sstv";
  version = sources.sstv.version;
  format = "setuptools";

  src = sources.sstv.src;

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    pillow
    soundfile
    scipy
  ];

  doCheck = false;

  meta = with lib; {
    description = "Command-line slow-scan television decoder for audio files";
    homepage = "https://github.com/colaclanth/sstv";
    license = licenses.gpl3Only;
    mainProgram = "sstv";
    platforms = platforms.linux;
  };
}