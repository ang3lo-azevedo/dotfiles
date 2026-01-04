{ inputs, lib, ... }:
{
  services.fprintd.enable = true;

  # Enable fingerprint authentication for system services
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    swaylock.fprintAuth = true;
    ly.fprintAuth = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (old: {
        src = inputs.libfprint-src;
        
        # Add support for 1c7a:05a5 if not present
        postPatch = ''
          # Remove tests and examples from build to avoid configuration errors
          sed -i "/subdir('tests')/d" meson.build
          sed -i "/subdir('examples')/d" meson.build

          if [ -f libfprint/drivers/egismoc.c ]; then
            sed -i '/.pid = 0x0582/a \ \ { .vid = 0x1c7a, .pid = 0x05a5, .driver_data = 0 },' libfprint/drivers/egismoc.c
          fi
        '';

        # Disable tests
        doCheck = false;
        doInstallCheck = false;
        
        # Remove invalid meson option
        mesonFlags = lib.remove "-Dtests=false" old.mesonFlags;
      });
    })
  ];
}
