{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.vol-rs
  ];
}
