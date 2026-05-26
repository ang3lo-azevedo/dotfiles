{ pkgs }:

let
  upstream = import (builtins.fetchGit {
    url = "https://github.com/faukah/angr-management-nix";
    ref = "main";
  }) { inherit pkgs; };
in
upstream.angr-management
