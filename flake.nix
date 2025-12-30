{
  description = "NixOS systems and tools by ang3lo-azevedo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Latest stable branch of nixpkgs, used for version rollback
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # Input for Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Agenix (for managing secrets)
    agenix.url = "github:ryantm/agenix";

    # Input for Disko (disk partitioning tool)
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

    # Input for NUR Firefox add-ons to be used with Zen Browser
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Nix VSCode extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , agenix
    , disko
    , mango
    , zen-browser
    , nix-vscode-extensions
    , ...
    }@inputs:
    let
      lib = nixpkgs.lib;

      # Helper function to generate a NixOS system configuration
      mkNixosSystem =
        { system
        , modules
        , specialArgs
        ,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system modules specialArgs;
        };

      #mpv-config = "${self}/home/ang3lo/config/mpv";

      # Helper function to generate a reusable host configuration
      mkHostConfig =
        { hostname
        , modules ? [ ]
        ,
        }:
        {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { networking.hostName = hostname; }
            ./hosts/${hostname}/configuration.nix

            # Agenix for secrets management
            agenix.nixosModules.default
          ]
          ++ (lib.optional (builtins.pathExists ./hosts/${hostname}/disko.nix) ./hosts/${hostname}/disko.nix)
          ++ (lib.optional (builtins.pathExists ./hosts/${hostname}/disko.nix) disko.nixosModules.disko)
          ++ modules;
        };

      # Reusable pc-angelo configuration
      pc-angelo-config = mkHostConfig {
        hostname = "pc-angelo";
        modules = [
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ang3lo = import ./home/ang3lo/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs mango zen-browser nix-vscode-extensions;
              #inherit mpv-config;
            };
          }

          # Mango Window Compositor
          mango.nixosModules.mango
          {
            programs.mango.enable = true;
          }
        ];
      };

      # Reusable server-angelo configuration
      server-angelo-config = mkHostConfig {
        hostname = "server-angelo";
      };
    in
    {
      # NixOS configuration for pc-angelo
      nixosConfigurations.pc-angelo = mkNixosSystem pc-angelo-config;

      # NixOS configuration for server-angelo
      nixosConfigurations.server-angelo = mkNixosSystem server-angelo-config;
    };
}
