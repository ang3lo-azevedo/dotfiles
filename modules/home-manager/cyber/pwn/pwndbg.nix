{
  pkgs,
  inputs,
  ...
}: let
  pwndbg = inputs.pwndbg.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # reverser_ai.nix sets PYTHONPATH to python3.12 site-packages; unset so Python 3.14 in pwndbg-env finds the right _sysconfigdata
  pwndbgWrapped = pkgs.writeShellScriptBin "pwndbg" ''
    unset PYTHONPATH
    exec ${pwndbg}/bin/pwndbg "$@"
  '';
in {
  home.packages = [pwndbgWrapped];

  home.shellAliases = {
    gdb = "${pwndbgWrapped}/bin/pwndbg";
  };
}
