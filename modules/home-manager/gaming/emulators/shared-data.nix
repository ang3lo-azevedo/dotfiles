{
  config,
  lib,
  ...
}: let
  # All the nx2 forks here descend from Eden and share its config format and
  # on-disk layout, so they can run off one store: same settings, saves, nand
  # and shader cache across every emulator. Each fork hardcodes its own data
  # dir name from its branding (no env var or portable-mode override exists), so
  # the only way to pool them is to redirect those names at a single real store.
  #
  # eglantine is that store: it holds the richest saves, and pokedinner's binary
  # is itself named eglantine, so it already writes there and needs no redirect.
  # The rest get their three XDG roots symlinked onto eglantine's.
  canonical = "eglantine";
  forks = ["eden" "nemyu" "orchid" "lichii"];
  roots = [".config" ".local/share" ".cache"];

  link = config.lib.file.mkOutOfStoreSymlink;
  home = config.home.homeDirectory;
in {
  home.file = builtins.listToAttrs (lib.concatMap (root:
    map (fork: {
      name = "${root}/${fork}";
      value.source = link "${home}/${root}/${canonical}";
    })
    forks)
  roots);
}
