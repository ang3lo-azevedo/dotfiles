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
      exec ${pkgs.uv}/bin/uv run --with angr python3 "$@"
    '')
  ];
}
