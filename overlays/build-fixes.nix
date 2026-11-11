# Temporary build fixes for upstream nixpkgs packages until fixes land upstream
_: prev: {
  # rayburst: missing sqlite for sqlx/sqlite linker
  rayburst = prev.rayburst.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [prev.sqlite];
  });

  # flare-signal: missing sqlcipher/sqlite for presage/libsqlcipher
  flare-signal = prev.flare-signal.overrideAttrs (old: {
    buildInputs =
      (old.buildInputs or [])
      ++ [
        prev.sqlcipher
        prev.sqlite
      ];
    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ [
        prev.sqlcipher
        prev.sqlite
      ];
    preBuild =
      (old.preBuild or "")
      + ''
        export LIBRARY_PATH="${prev.sqlcipher}/lib:${prev.sqlite.out}/lib:''${LIBRARY_PATH:-}"
        export RUSTFLAGS="-L ${prev.sqlcipher}/lib -L ${prev.sqlite.out}/lib ''${RUSTFLAGS:-}"
      '';
  });

  # owmods-gui: aws-lc-sys requires system-installed aws-lc
  owmods-gui = prev.owmods-gui.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [prev.aws-lc];
  });

  # pwninit: zstd-sys requires system-installed libzstd
  pwninit = prev.pwninit.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [prev.zstd];
  });
}
