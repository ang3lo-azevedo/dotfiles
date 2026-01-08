{ pkgs, inputs, ... }:
let
  pwndbg = inputs.pwndbg.packages.${pkgs.system}.default;
in
{
  imports = [
    ./python.nix
  ];

  home.packages = with pkgs; [
    openvpn
    pwndbg
  ];

  home.shellAliases = {
    gdb = "${pwndbg}/bin/pwndbg";
  };
}