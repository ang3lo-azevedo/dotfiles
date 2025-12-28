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

    # Input for sops
    sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Disko
    disko = {
        url = "github:nix-community/disko";
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
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, disko, mango, zen-browser, ... } @ inputs:
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
        diskoConfigurations = {
            test-vm = import ./hosts/pc-angelo/disko.nix {
                inherit (nixpkgs) lib;
                config = { myDisko.device = "/dev/sda"; }; 
            };
        };

        # NixOS configuration for pc-angelo
        nixosConfigurations.pc-angelo = mkNixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                disko.nixosModules.disko        # Add Disko module
                ./hosts/pc-angelo/disko.nix
                ./hosts/pc-angelo/configuration.nix

                # Home Manager
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

                # Sops
                sops-nix.nixosModules.sops

                # Add overlays for NUR and Chaotic
                {
                    nixpkgs.overlays = [
                    inputs.chaotic.overlays.default
                    ];
                }

                mango.nixosModules.mango
                {
                    programs.mango.enable = true;
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

        # NixOS configuration for test-vm
        nixosConfigurations.test-vm = mkNixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                disko.nixosModules.disko
                ./hosts/pc-angelo/disko.nix    # Shared layout
                { myDisko.device = "/dev/sda"; } # Override for VM
                ./hosts/pc-angelo/configuration.nix

                # Add overlays for NUR and Chaotic
                {
                    nixpkgs.overlays = [
                    inputs.chaotic.overlays.default
                    ];
                }
                
                mango.nixosModules.mango
                {
                    programs.mango.enable = true;
                }

                sops-nix.nixosModules.sops
                {
                    sops.defaultSopsFile = ../../secrets/secrets.yaml;
                    sops.age.keyFile = "/home/ang3lo/.config/sops/age/keys.txt";
                    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                    sops.age.generateKey = true;
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
    };
}