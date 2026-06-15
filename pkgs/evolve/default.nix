{ lib
, python2Packages
, makeWrapper
, callPackage
}:

let
  sources = callPackage ../_sources/generated.nix { };
in
python2Packages.buildPythonApplication {
  pname = "evolve";
  version = sources.evolve.version;

  src = sources.evolve.src;

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
