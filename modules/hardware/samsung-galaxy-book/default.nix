{ ... }:
{
  imports = [
    ./audio.nix
    ./fingerprint.nix
    ./webcam.nix
    ./fn-keys
  ];

  # TODO: Remove this temporary local workaround once nixpkgs fixes the SDL3 testrwlock timeout upstream.
  # Temporary local workaround: SDL3 has a flaky testrwlock timeout in nixpkgs
  # that blocks full system builds on this host.
  nixpkgs.overlays = [
    (final: prev: {
      sdl3 = prev.sdl3.overrideAttrs (_: {
        doCheck = false;
      });

      # Temporary local workaround: ibus has a parallel install race in pygobject bindings
      # that can attempt to install IBus.py twice and fail with "File exists".
      ibus = prev.ibus.overrideAttrs (_: {
        enableParallelBuilding = false;
      });

      # Temporary local workaround: xdg-desktop-portal 1.20.3 has a flaky
      # USB integration test failure in isolated builders.
      xdg-desktop-portal = prev.xdg-desktop-portal.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];
}