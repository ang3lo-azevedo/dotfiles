{
  inputs,
  lib,
  ...
}: {
  imports = [
    (inputs.samsung-galaxy-book-linux-fixes + "/nixos/webcam-fix-book5.nix")
  ];

  hardware.samsungGalaxyBook.webcamFixBook5 = {
    enable = lib.mkDefault true;
    # ipu-bridge-fix already reports rotation=180, so forcing it again in
    # libcamera cancels out and turns the image upside down.
    videoFlip = false;
    # Past the ~35 IPU7 and USB nodes, so gaze can pin a stable path.
    loopbackVideoNr = 50;
    # In a dim room AGC runs the sensor at max analog gain and the image fills
    # with colour speckle; a 3x3 median on all planes costs ~11ms/frame at
    # 1080p on one core.
    relayColorFilter = "videomedian filtersize=9 lum-only=false ! videoconvert";
  };
}
