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

    # Input for Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    firefox-addons = {
        url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Proton-CachyOS
    nix-proton-cachyos.url = "github:kimjongbing/nix-proton-cachyos";
  };

  outputs = { self, nixpkgs, home-manager, mango, zen-browser, ... } @ inputs:
    let
      # Define your systems and architectures
      systems = [ "x86_64-linux" ];

      # Helper function to generate a NixOS system configuration
      mkNixosSystem = { system, modules, specialArgs }:
        nixpkgs.lib.nixosSystem {
          inherit system modules specialArgs;
        };

      # Workaround for Nix issues #4423 & #6633 where flakes may not
      # correctly recognize local submodules. `self` refers to the flake's
      # own source tree, which should include submodules.
      mpv-config = "${self}/home/ang3lo/config/mpv";

    in
    {
      # NixOS configuration for pc-angelo
      nixosConfigurations.pc-angelo = mkNixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Add overlays for NUR and Chaotic
          {
            nixpkgs.overlays = [
              inputs.chaotic.overlays.default
            ];
          }
          ./hosts/pc-angelo/configuration.nix

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
              inherit inputs mango zen-browser;
              inherit mpv-config;
            };
          }
        ];
      };

      # NixOS configuration for server-angelo
      nixosConfigurations.server-angelo = mkNixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/server-angelo/configuration.nix
        ];
      };
    };
}