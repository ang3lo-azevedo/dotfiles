{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    (callPackage (inputs.self + "/pkgs/registry-spy/default.nix") {})
  ];
}
