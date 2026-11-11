{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.gaze.nixosModules.default];

  services.gaze = {
    enable = true;
    # zstd-sys 2.1.0 in gaze requires system libzstd to link successfully
    package = inputs.gaze.packages.${pkgs.stdenv.hostPlatform.system}.gaze.overrideAttrs (old: {
      buildInputs = (old.buildInputs or []) ++ [pkgs.zstd];
    });

    settings = {
      # "primary" picks the first color node, which is a raw IPU7 node here.
      cameras.rgb = "/dev/video${toString config.hardware.samsungGalaxyBook.webcamFixBook5.loopbackVideoNr}";

      # Encrypt enrolled face templates at rest (TPM sealed). Interim hardening:
      # the root btrfs LV spans an unencrypted LVM PV (nvme0n1p3), so ~half of
      # the filesystem, including these templates, can sit in cleartext on disk.
      # Sealing protects them wherever btrfs places them. This does not fix the
      # underlying partial encryption: the real fix is whole-disk LUKS, which
      # needs a reinstall with luksSizeGB = null in disko.nix. Note the TPM here
      # has no PCR policy, so a local root or live-USB attacker could still
      # unseal; the gain is against offline theft of the powered-off disk.
      # Turning this on invalidates existing plain templates: re-enroll after.
      storage.encrypt_templates = true;
    };

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
