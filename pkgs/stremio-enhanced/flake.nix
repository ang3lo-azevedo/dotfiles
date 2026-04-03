{
  description = "Stremio Enhanced - Electron-based Stremio desktop client with plugins and themes support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.stremio-enhanced = pkgs.callPackage ./default.nix { };
        packages.default = self.packages.${system}.stremio-enhanced;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            npm
            electron
          ];
        };
      }
    );
}
