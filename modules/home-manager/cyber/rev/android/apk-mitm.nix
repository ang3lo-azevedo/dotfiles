{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    (callPackage (inputs.self + "/pkgs/apk-mitm/default.nix") {})
  ];
}
