{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustc
    cargo
    (python3.withPackages (ps: with ps; [
      pwntools
      setuptools-rust
      angr-management
    ]))
  ];
}
