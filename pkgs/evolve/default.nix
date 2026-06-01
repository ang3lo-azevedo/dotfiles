{ lib
, fetchFromGitHub
, python2Packages
, makeWrapper
}:

python2Packages.buildPythonApplication {
  pname = "evolve";
  version = "unstable-20260531";

  src = fetchFromGitHub {
    owner = "JamesHabben";
    repo = "evolve";
    rev = "master";
    sha256 = "0pwx1r5sm5ip5n9w886d9dbnl7pfnh5c5yxzi1s2al547nd63rz8";
  };

  format = "setuptools";

  nativeBuildInputs = with python2Packages; [ setuptools ];

  propagatedBuildInputs = with python2Packages; [ bottle maxminddb ];

  doCheck = false;

  postInstall = ''
    install -Dm755 evolve.py $out/share/evolve/evolve.py
    makeWrapper ${python2Packages.python.interpreter} $out/bin/evolve \
      --add-flags $out/share/evolve/evolve.py
  '';

  meta = with lib; {
    description = "Volatility memory analysis plugin";
    homepage = "https://github.com/JamesHabben/evolve";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
