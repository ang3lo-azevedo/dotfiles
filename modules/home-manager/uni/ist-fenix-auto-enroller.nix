{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.ist-fenix-auto-enroller.packages.${pkgs.system}.default
  ];
}
