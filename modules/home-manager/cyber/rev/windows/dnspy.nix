{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.self.packages.${pkgs.unstable.stdenv.hostPlatform.system}.dnspy
  ];
}
