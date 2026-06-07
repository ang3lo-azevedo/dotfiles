{ inputs, ... }:

{
  imports = [
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/webcam-fix-book5.nix"
  ];

  hardware.samsungGalaxyBook.webcamFixBook5 = {
    videoFlip = true;
    relayColorFilter = "videoflip method=rotate-180 ! videobalance hue=0.05 saturation=0.95";
  };
}