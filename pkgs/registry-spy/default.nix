{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication {
  pname = "registry-spy";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andyjsmith";
    repo = "Registry-Spy";
    rev = "d0f623fa56964cc17ba5199d82814437d4b03cc6";
    hash = "sha256-7m3qWVqI0E0pVBSIExvRpqATb6jJmmzQF9W8FUU1Mg4=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    pyside6
    python-registry
  ];

  doCheck = false;

  meta = with lib; {
    description = "Cross-platform Windows Registry browser";
    homepage = "https://github.com/andyjsmith/Registry-Spy";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
