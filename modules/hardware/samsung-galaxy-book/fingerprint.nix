{
  inputs,
  lib,
  pkgs,
  ...
}: {
  services.fprintd.enable = true;

  environment.systemPackages = [pkgs.tpm-keyring-unlock];

  users.users.ang3lo.extraGroups = ["tss"];

  security = {
    tpm2 = {
      enable = true;
      tctiEnvironment.enable = true;
    };

    pam.services = {
      # Enable fingerprint authentication for system services
      sudo.fprintAuth = true;
      swaylock.fprintAuth = true;
      greetd.fprintAuth = true;
      polkit.fprintAuth = true;

      # fprintd only returns success/failure. This optional module supplies
      # the TPM-unsealed keyring password to pam_gnome_keyring so fingerprint
      # login auto-unlocks the keyring, without deciding authentication itself.
      login = {
        fprintAuth = true;
        enableGnomeKeyring = true;
        rules.auth = {
          fprintd.control = lib.mkForce "[success=1 default=ignore]";
          tpm_keyring_authtok = {
            control = "optional";
            modulePath = "${pkgs.tpm-keyring-unlock}/lib/security/pam_tpm_keyring_authtok.so";
            # Nixpkgs places pam_gnome_keyring at 12200 in this stack.
            order = 12199;
          };
        };
      };
    };
  };

  # HACK: remove this overlay once joshuagrisham/libfprint egismoc-sdcp is merged
  # upstream and nixpkgs packages a version that includes it.
  nixpkgs.overlays = [
    (_: prev: {
      libfprint = prev.libfprint.overrideAttrs (old: {
        src = inputs.libfprint-src;

        # Nixpkgs patches target the upstream source tree and don't apply to this
        # fork and cause patchPhase to fail.
        patches = [];

        # Add support for 1c7a:05a5 if not present
        postPatch = ''
          sed -i "/subdir('tests')/d" meson.build
          sed -i "/subdir('examples')/d" meson.build

          if [ -f libfprint/drivers/egismoc.c ]; then
            sed -i '/.pid = 0x0582/a \ \ { .vid = 0x1c7a, .pid = 0x05a5, .driver_data = 0 },' libfprint/drivers/egismoc.c
          fi
        '';

        doCheck = false;
        doInstallCheck = false;

        # This fork dropped the meson "tests" option. Passing it causes an
        # "Unknown options" build error, so strip it from what nixpkgs sets.
        mesonFlags = lib.remove "-Dtests=false" old.mesonFlags;
      });
    })
  ];
}
