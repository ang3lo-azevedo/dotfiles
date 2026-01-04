{ pkgs, lib, ... }:
{
  services.fprintd.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (old: {
        src = final.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "joshuagrisham";
          repo = "libfprint";
          rev = "egismoc-sdcp";
          sha256 = "07hirwcmsf55vdxkqj0cfhkpnws88cvdfd4xcg6i7frq0hxdprgy";
        };
        
        # Add support for 1c7a:05a5 if not present
        postPatch = old.postPatch or "" + ''
          if [ -f libfprint/drivers/egismoc.c ]; then
            sed -i '/.pid = 0x0582/a \ \ { .vid = 0x1c7a, .pid = 0x05a5, .driver_data = 0 },' libfprint/drivers/egismoc.c
          fi
        '';
      });
    })
  ];
}
