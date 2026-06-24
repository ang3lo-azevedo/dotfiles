{pkgs, ...}: {
  home.packages = with pkgs; [
    (callPackage ../../../../../pkgs/apk-mitm/default.nix {})
  ];
}
