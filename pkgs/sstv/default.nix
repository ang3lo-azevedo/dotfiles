{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication {
  pname = "sstv";
  version = "0.1-unstable-2026-05-26";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "colaclanth";
    repo = "sstv";
    rev = "3e556eee8ad4c4425799cb652bac26ee58f8e113";
    hash = "sha256-s+G3MUVxEL/CwLaLk2nFcTFfRqq4Hrbj6qa/GhhzFMc=";
  };

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