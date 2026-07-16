{pkgs, ...}: {
  home.packages = [
    # TODO: remove once dmatools updates memprocfs past 5.9.10.157:
    # (1) vendored sqlite3 3.43.0 fails under GCC 15's C23 default; -std=gnu17 reverts to C17
    # (2) vmmpyc.h sets Py_LIMITED_API before Python.h, hiding PyRun_SimpleString;
    #     GCC 15 makes the resulting implicit declaration a hard error even in C17 mode
    (pkgs.memprocfs.overrideAttrs (old: {
      env =
        (old.env or {})
        // {
          NIX_CFLAGS_COMPILE = ((old.env or {}).NIX_CFLAGS_COMPILE or "") + " -std=gnu17 -Wno-implicit-function-declaration";
        };
    }))
  ];
}
