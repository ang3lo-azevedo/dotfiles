{
  inputs,
  pkgs,
  ...
}: {
  imports = ["${inputs.samsung-galaxy-book-linux-fixes}/nixos/webcam-fix-book5.nix"];

  hardware.samsungGalaxyBook.webcamFixBook5 = {
    enable = false;
    # Must be inputs.nixpkgs.legacyPackages, NOT pkgs. The `pkgs` argument is
    # already the overlaid fixed-point, so pkgs.pipewire is the same patched
    # version that causes the cascade. Only a fresh legacyPackages evaluation
    # (before any overlays are applied) gives a truly unpatched package set.
    nixpkgsUnpatched = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  };
}
