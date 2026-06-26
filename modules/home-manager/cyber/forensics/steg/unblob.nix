{pkgs, ...}: {
  home.packages = [
    # The btrfs_stream integration test fails in the Nix sandbox (cross-device
    # rename: EXDEV errno 18) because the sandbox bind-mounts make rename(2)
    # across directories fail. Disable checks; the package itself is fine.
    (pkgs.unblob.overrideAttrs (_: {
      doCheck = false;
    }))
  ];
}
