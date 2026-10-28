{
  pkgs,
  inputs,
  ...
}: let
  # memprocfs' meson needs fuse2 (pkg-config "fuse"), but current nixpkgs made `fuse`
  # an alias for fuse3 (which only ships fuse3.pc) and removed fuse2 as EOL. Pull the
  # real libfuse 2.9.9 from nixpkgs-eol so the FUSE mount feature keeps building.
  fuse2 = inputs.nixpkgs-eol.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fuse;
in {
  home.packages = [
    # HACK: remove once dmatools updates memprocfs past 5.9.10.157:
    # (1) vendored sqlite3 3.43.0 fails under GCC 15's C23 default; -std=gnu17 reverts to C17
    # (2) vmmpyc.h sets Py_LIMITED_API before Python.h, hiding PyRun_SimpleString;
    #     GCC 15 makes the resulting implicit declaration a hard error even in C17 mode
    ((pkgs.memprocfs.override {fuse = fuse2;}).overrideAttrs (old: {
      env =
        (old.env or {})
        // {
          NIX_CFLAGS_COMPILE = ((old.env or {}).NIX_CFLAGS_COMPILE or "") + " -std=gnu17 -Wno-implicit-function-declaration";
        };
    }))
  ];
}
