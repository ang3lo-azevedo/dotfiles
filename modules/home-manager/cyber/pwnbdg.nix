{ pkgs, inputs, ... }:
let
  pwndbg = inputs.pwndbg.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [
    pwndbg
  ];

  home.shellAliases = {
    gdb = "${pwndbg}/bin/pwndbg";
  };
}