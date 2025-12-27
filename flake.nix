{
  description = "NixOS systems and tools by ang3lo-azevedo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Latest stable branch of nixpkgs, used for version rollback
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # Nix User Repository for additional packages
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for MangoWC window compositor
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Proton-CachyOS
    nix-proton-cachyos.url = "github:kimjongbing/nix-proton-cachyos";
  };

  outputs = { self, nixpkgs, home-manager, mango, spicetify-nix, ... } @ inputs: {

    # NixOS configuration for pc-ang3lo
    nixosConfigurations.pc-angelo = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/pc-ang3lo/configuration.nix

        mango.nixosModules.mango
        {
          programs.mango.enable = true;
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ang3lo = import ./home/ang3lo/home.nix;
          home-manager.extraSpecialArgs = { inherit spicetify-nix mango; };
        }
      ];
    };

    # NixOS configuration for server-ang3lo
    nixosConfigurations.server-ang3lo = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/server-ang3lo/configuration.nix
      ];
    };  

    # Dev shell for development
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        git
        vim
      ];
    };
  };
}