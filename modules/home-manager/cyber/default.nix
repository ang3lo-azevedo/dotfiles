{ pkgs, inputs, ... }:
let
  pwndbg = inputs.pwndbg.packages.${pkgs.system}.default;
in
{
  home.packages = with pkgs; [
    openvpn
    pwndbg
    pwntools
  ];

  home.shellAliases = {
    gdb = "${pwndbg}/bin/pwndbg";
  };
}