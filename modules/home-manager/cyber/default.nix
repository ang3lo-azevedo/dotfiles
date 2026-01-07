{ pkgs, inputs, ... }:
let
  pwndbg = inputs.pwndbg.packages.${pkgs.system}.default;
in
{
  home.packages = with pkgs; [
    gdb
    openvpn
    pwndbg
    (python3.withPackages (ps: [ ps.pwntools ]))
  ];

  home.file.".gdbinit".text = ''
    source ${pwndbg}/share/pwndbg/gdbinit.py
  '';
}