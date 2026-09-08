{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.gaze.nixosModules.default];

  services.gaze.enable = true;

  # sudo stays fingerprint-only: exclude it from gaze's default PAM wiring.
  services.gaze.pam.defaultServices = ["polkit-1"];

  security.pam.services = {
    # The success jump skips only the password probe, so the TPM keyring
    # module still runs after a face login (same pattern as fprintd).
    login.gaze = {
      enable = true;
      control = lib.mkForce "[success=1 default=ignore]";
    };
    swaylock.gaze.enable = true;
  };
}
