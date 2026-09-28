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
    # gaze sits right before fprintd in the "login" auth stack (its order is
    # computed as fprintd's order minus 10, see the gaze module), so skipping
    # forward 1 rule on success only skips fprintd itself, not fprintd's own
    # "[success=1 default=ignore]" skip target. That target is unix-early,
    # the module that would otherwise prompt for a password.
    #
    # With skip=1 a successful face login falls through into unix-early,
    # which has no try_first_pass/use_first_pass and so calls out for a
    # password the graphical greeter never prompts for, silently stalling
    # the login instead of reaching tpm_keyring_authtok. That module's own
    # source (pam_tpm_keyring_authtok.c) documents it as belonging directly
    # after the authenticating module and before pam_gnome_keyring.so, with
    # nothing else in between.
    #
    # skip=2 clears both fprintd and unix-early, landing gaze on the same
    # tpm_keyring_authtok -> gnome_keyring -> unix(sufficient) path fprintd's
    # own skip=1 already reaches. This assumes fprintd stays enabled ahead of
    # gaze in this stack (see fingerprint.nix); if fprintd is ever removed,
    # this needs to drop back to skip=1.
    login.gaze = {
      enable = true;
      control = lib.mkForce "[success=2 default=ignore]";
    };
    swaylock.gaze.enable = true;
  };
}
