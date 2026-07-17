{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    (pkgs.callPackage (inputs.self + "/pkgs/jackify") {})
  ];
}
