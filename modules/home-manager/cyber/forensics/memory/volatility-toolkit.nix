{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    (callPackage (inputs.self + "/pkgs/volatility-toolkit/default.nix") {})
  ];
}
