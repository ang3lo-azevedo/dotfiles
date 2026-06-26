{pkgs, ...}: {
  home.packages = [
    (pkgs.unblob.overrideAttrs (old: {
      # btrfs_stream handler fails in the Nix sandbox with EXDEV (errno 18):
      # rename(2) across bind-mount boundaries is not allowed.
      # Same root cause as the romfs/yaffs tests already disabled upstream.
      disabledTests =
        (old.disabledTests or [])
        ++ [
          "test_all_handlers[filesystem.btrfs_stream]"
        ];
    }))
  ];
}
