{ inputs, ... }:

{
  imports = [
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/webcam-fix-book5.nix"
  ];

  hardware.samsungGalaxyBook.webcamFixBook5.videoFlip = true;
}