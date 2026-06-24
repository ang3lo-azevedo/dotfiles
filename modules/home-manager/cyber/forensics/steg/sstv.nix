{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    (callPackage (inputs.self + "/pkgs/sstv/default.nix") {})
  ];
}
