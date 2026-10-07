{pkgs, ...}: {
  home.packages = with pkgs; [
    (python3Packages.toPythonApplication python3Packages.oletools)
  ];
}
