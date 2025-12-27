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

    # Nyx Chaotic Repository
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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

    # Input for Proton-CachyOS
    nix-proton-cachyos.url = "github:kimjongbing/nix-proton-cachyos";
  };

  outputs = { self, nixpkgs, home-manager, mango, ... } @ inputs: {
    # NixOS configuration for pc-ang3lo
    nixosConfigurations.pc-angelo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
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
          home-manager.extraSpecialArgs = {
            inherit inputs mango;
            mpv-config = ./home/ang3lo/config/mpv;
          };
        }
      ];
    };

    # NixOS configuration for server-ang3lo
    nixosConfigurations.server-ang3lo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/server-ang3lo/configuration.nix
      ];
    };  
  };
}