{
  inputs,
  lib,
  ...
}: {
  services.fprintd.enable = true;

  # Enable fingerprint authentication for system services
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    swaylock.fprintAuth = true;
    greetd.fprintAuth = true;
    polkit.fprintAuth = true;
  };

  # TODO: remove this overlay once joshuagrisham/libfprint egismoc-sdcp is merged
  # upstream and nixpkgs packages a version that includes it.
  nixpkgs.overlays = [
    (_: prev: {
      libfprint = prev.libfprint.overrideAttrs (old: {
        src = inputs.libfprint-src;

        # Nixpkgs patches target the upstream source tree; they don't apply to this
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

        # This fork dropped the meson "tests" option; passing it causes an
        # "Unknown options" build error, so strip it from what nixpkgs sets.
        mesonFlags = lib.remove "-Dtests=false" old.mesonFlags;
      });
    })
  ];
}
