{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    (callPackage (inputs.self + "/pkgs/evolve/default.nix") {})
  ];
}
