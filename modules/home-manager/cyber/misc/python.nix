{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    (customPython313.withPackages (
      ps:
        with ps; [
          pycryptodome
          pwntools
          z3-solver
        ]
    ))

    # A custom Python wrapper that dynamically loads angr using uv!
    # Run `uv-angr script.py` or just `uv-angr` for an interactive shell.
    (pkgs.writeShellScriptBin "uv-angr" ''
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib pkgs.z3]}:$LD_LIBRARY_PATH"
      exec ${pkgs.uv}/bin/uv run --with angr python3 "$@"
    '')
  ];
}
