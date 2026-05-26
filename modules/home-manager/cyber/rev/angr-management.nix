{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python313.withPackages (ps: with ps; [
      setuptools-rust
      rustc
      cargo
      angr-management
    ]))
  ];
}
