{
  lib,
  python3Packages,
  src,
}:

let
  confuse_2_1_0 = python3Packages.buildPythonPackage rec {
    pname = "confuse";
    version = "2.1.0";
    format = "pyproject";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1391dqbx93m1dvvky1q38lqdvlpc0d2chbsfz2pfz9n7k556gfdb";
    };

    nativeBuildInputs = with python3Packages; [ poetry-core ];

    propagatedBuildInputs = with python3Packages; [ pyyaml ];

    doCheck = false; # No tests in sdist
  };

  click_8_1_7 = python3Packages.buildPythonPackage rec {
    pname = "click";
    version = "8.1.7";
    format = "pyproject";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1pm6khdv88h764scik67jki98xbyj367h591j8hpwy4y8nnm766a";
    };

    nativeBuildInputs = with python3Packages; [ setuptools ];
  };
in
python3Packages.buildPythonApplication {
  pname = "trakt-scrobbler";
  version = "1.8.0-unstable";
  format = "pyproject";

  inherit src;

  nativeBuildInputs = with python3Packages; [
    hatchling
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cleo
    confuse_2_1_0
    desktop-notifier
    guessit
    pydantic
    requests
    click_8_1_7
    typer
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
