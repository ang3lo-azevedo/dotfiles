{
  pkgs,
  inputs,
  ...
}: let
  pwndbg =
    inputs.pwndbg.packages.${pkgs.unstable.stdenv.hostPlatform.system}.default.overrideAttrs
    (old: {
      preferLocalBuild = true;
      requiredSystemFeatures = (old.requiredSystemFeatures or []) ++ ["local"];
    });
in {
  home.packages = [pwndbg];

  home.shellAliases = {
    gdb = "${pwndbg}/bin/pwndbg";
  };
}
