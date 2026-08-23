{
  pkgs,
  inputs,
  ...
}: let
  pwndbg = inputs.pwndbg.packages.${pkgs.unstable.stdenv.hostPlatform.system}.default;
in {
  home.packages = [pwndbg];

  home.shellAliases = {
    gdb = "${pwndbg}/bin/pwndbg";
  };
}
