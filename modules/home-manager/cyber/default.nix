{ pkgs, inputs, ... }:
let
  pwndbg = inputs.pwndbg.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [
    ./python-pwntools.nix
  ];

  home.packages = with pkgs; [
    openvpn
    pwndbg
  ];

  home.shellAliases = {
    gdb = "${pwndbg}/bin/pwndbg";
  };
}