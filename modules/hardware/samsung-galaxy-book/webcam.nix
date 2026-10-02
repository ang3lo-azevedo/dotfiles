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
    # Dim rooms otherwise run the sensor at 15.5x analog gain, where its
    # per-channel black offset drifts and shadows turn green.
    lowNoise.enable = true;
    # In a dim room AGC runs the sensor at max analog gain and the image fills
    # with colour speckle; a 3x3 median on all planes costs ~11ms/frame at
    # 1080p on one core.
    #
    # The soft ISP's plain gamma curve leaves shadows lifted next to a UVC
    # webcam. videobalance pivots contrast on black, so the negative
    # brightness moves the pivot to mid-grey.
    #
    # Reds come out of the CCM leaning magenta and undersaturated: skin
    # measured hue 4, saturation 0.18 against 17 and 0.30 on a UVC webcam in
    # the same light, with a grey wall neutral on both. The hue and saturation
    # values bring skin to 18 and 0.28.
    relayColorFilter = "videomedian filtersize=5 lum-only=false ! videobalance contrast=1.25 saturation=1.9 hue=-0.06 brightness=-0.11 ! videoconvert";
  };
}
