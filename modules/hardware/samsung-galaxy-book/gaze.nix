{
  config,
  inputs,
  ...
}: {
  imports = [inputs.gaze.nixosModules.default];

  services.gaze = {
    enable = true;

    # "primary" picks the first color node, which is a raw IPU7 node here.
    settings.cameras.rgb = "/dev/video${toString config.hardware.samsungGalaxyBook.webcamFixBook5.loopbackVideoNr}";

    # sudo stays fingerprint-only: exclude it from gaze's default PAM wiring.
    pam.defaultServices = ["polkit-1"];
  };

  # "login" is deliberately left without gaze. The greeter runs before the
  # user session starts camera-relay, so gazed is the first to open the
  # loopback: v4l2src negotiates its largest mode (3840x2160@120), fails to
  # allocate buffers, and the device stays latched on that format. The relay
  # then cannot pin 1920x1080 and crash-loops for the whole session. Face
  # login could never succeed there anyway, since nothing feeds the loopback
  # until the relay is up.
  security.pam.services.swaylock.gaze.enable = true;
}
