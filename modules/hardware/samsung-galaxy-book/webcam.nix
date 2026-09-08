{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/webcam-fix-book5.nix"
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/webcam-sensor-flip.nix"
  ];

  hardware.samsungGalaxyBook.webcamFixBook5 = {
    enable = false;

    # Must be inputs.nixpkgs.legacyPackages, NOT pkgs. The `pkgs` argument is
    # already the overlaid fixed-point, so pkgs.pipewire is the same patched
    # version that causes the cascade. Only a fresh legacyPackages evaluation
    # (before any overlays are applied) gives a truly unpatched package set.
    nixpkgsUnpatched = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  };

  # The OV02E10 sensor on Book5 convertibles is physically mounted upside
  # down, but the in-tree ipu-bridge never reports rotation=180 (the
  # webcam-fix module's videoFlip needs its patched libcamera + relay stack,
  # which is disabled here). The sensor flip module applies HFLIP + VFLIP at
  # the V4L2 subdev level instead, which equals a 180 degree rotation while
  # the driver's modify-layout flag keeps the bayer order correct.
  hardware.samsungGalaxyBook.webcamSensorFlip.enable = true;
}
