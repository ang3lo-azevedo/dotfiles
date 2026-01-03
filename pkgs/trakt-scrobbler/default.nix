{
  lib,
  python3Packages,
  fetchFromGitHub,
  src,
}:

let
  cleo_0_8_1 = python3Packages.buildPythonPackage rec {
    pname = "cleo";
    version = "0.8.1";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "python-poetry";
      repo = "cleo";
      rev = version;
      sha256 = "13b8q6yvaiag4xnbaam2ilc14swspvimb6wvcrfj94qj9v4qaypn";
    };

    nativeBuildInputs = [ python3Packages.poetry-core ];
    propagatedBuildInputs = [ python3Packages.clikit ];
  };
in
python3Packages.buildPythonApplication {
  pname = "trakt-scrobbler";
  version = "1.7.2-unstable";
  format = "pyproject";

  inherit src;

  nativeBuildInputs = [
    python3Packages.poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cleo_0_8_1
    confuse
    desktop-notifier
    guessit
    pydantic
    requests
    urllib3
    urlmatch
  ];

  postPatch = ''
    sed -i 's/urllib3 = "^1.26.0"/urllib3 = "*"/' pyproject.toml
  '';

  meta = with lib; {
    description = "Trakt scrobbler for MPV, VLC, and other media players";
    homepage = "https://github.com/iamkroot/trakt-scrobbler";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
