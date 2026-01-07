{ pkgs, inputs, ... }:
let
  pwndbg = inputs.pwndbg.packages.${pkgs.system}.default;
in
{
  home.packages = with pkgs; [
    openvpn
    pwndbg
    (lib.hiPrio (python3.withPackages (ps: [ ps.pwntools ])))
  ];

  home.shellAliases = {
    gdb = "${pwndbg}/bin/pwndbg";
  };
}