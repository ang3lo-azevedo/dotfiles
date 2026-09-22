{
  inputs,
  lib,
  ...
}: {
  imports = [
    (inputs.samsung-galaxy-book-linux-fixes + "/nixos/webcam-fix-book5.nix")
  ];

  hardware.samsungGalaxyBook.webcamFixBook5.enable = lib.mkDefault true;
  hardware.samsungGalaxyBook.webcamFixBook5.videoFlip = lib.mkDefault true;
}
