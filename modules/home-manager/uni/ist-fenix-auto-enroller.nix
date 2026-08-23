{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.ist-fenix-auto-enroller
  ];
}
