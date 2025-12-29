{ pkgs, inputs, ... }:
let
  trakt-scrobbler = pkgs.python3Packages.buildPythonApplication rec {
    pname = "trakt-scrobbler";
    version = "latest";

    src = inputs.trakt-src;

    # Add dependencies required by the script (found on its GitHub/PyPI)
    propagatedBuildInputs = with pkgs.python3Packages; [
      requests
      trakt
      guessit
      click
      appdirs
      pyyaml
      desktop-notifier
    ];

    doCheck = false;
  };
in
{
  home.packages = [ trakt-scrobbler ];
}