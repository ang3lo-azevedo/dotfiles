{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    (python3.withPackages (ps:
      with ps; [
        pycryptodome
        pwntools
        #angr
        z3-solver
      ]))
  ];
}
