{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "angr-management-shell";
  description = "Development environment for angr-management";

  buildInputs = with pkgs; [
    python3.withPackages (ps: with ps; [
      # Core angr-management dependencies
      angr-management
      
      # Useful tools for binary analysis
      pwntools
      
      # Development tools
      ipython
      jupyter
    ])
    
    # Build tools for angr (in case you need to rebuild)
    rustc
    cargo
    setuptools-rust
  ];
}
