{pkgs, ...}: {
  home.packages = [
    # pyfatfs (unblob dep) requires pyfilesystem2 (fs), which is disabled for Python 3.14
    # in nixpkgs. Force Python 3.13, then swap in the patched pyfatfs from
    # python313Packages (overrideScope fixes pkg_resources in fs). Remove when nixpkgs fixes it.
    ((pkgs.unblob.override {python3 = pkgs.python313;}).overrideAttrs (old: {
      # btrfs_stream handler fails in the Nix sandbox with EXDEV (errno 18):
      # rename(2) across bind-mount boundaries is not allowed.
      # Same root cause as the romfs/yaffs tests already disabled upstream.
      disabledTests =
        (old.disabledTests or [])
        ++ [
          "test_all_handlers[filesystem.btrfs_stream]"
        ];
      propagatedBuildInputs =
        builtins.filter (d: (d.pname or "") != "pyfatfs") (old.propagatedBuildInputs or [])
        ++ [pkgs.python313Packages.pyfatfs];
    }))
  ];
}
