{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    (customPython313.withPackages (ps:
      with ps; [
        pycryptodome
        pwntools
        z3-solver
      ]))

    # A custom Python wrapper that dynamically loads angr using uv!
    # Run `angr-python script.py` or just `angr-python` for an interactive shell.
    (pkgs.writeShellScriptBin "angr-python" ''
      exec ${pkgs.uv}/bin/uv run --with angr python3 "$@"
    '')
  ];
}
