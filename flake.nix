{
  description = "NixOS systems and tools by ang3lo-azevedo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Latest stable branch of nixpkgs, used for version rollback
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # Input for Disko (disk partitioning tool)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Agenix (for managing secrets)
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Stylix (styling tool)
    stylix = {
      url = "github:nix-community/stylix";
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

    # Input for Nix Firefox Add-ons
    firefox-addons = {
      url = "github:osipog/nix-firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Nix VSCode extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Nixcord (Discord clients configs for NixOS/Home Manager)
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Spicetify Nix (Spotify customizer)
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , disko
    , agenix
    , home-manager
    , stylix
    , mango
    , zen-browser
    , nix-vscode-extensions
    , spicetify-nix
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
          ]
          ++ (lib.optional (builtins.pathExists ./hosts/${hostname}/disko.nix) (import ./hosts/${hostname}/disko.nix))
          ++ (lib.optional (builtins.pathExists ./hosts/${hostname}/disko.nix) disko.nixosModules.disko)
          ++ [
            ./hosts/${hostname}/configuration.nix

            # Agenix for secrets management
            agenix.nixosModules.default
          ]
          ++ modules;
        };

      # Workaround for Nix issues #4423 & #6633 where flakes may not
      # correctly recognize local submodules. `self` refers to the flake's
      # own source tree, which should include submodules.
      mpv-config = "${self}/home/ang3lo/.config/mpv";

      # Reusable pc-angelo configuration
      pc-angelo-config = mkHostConfig {
        hostname = "pc-angelo";
        modules = [
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.ang3lo = import ./home/ang3lo/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs mango zen-browser nix-vscode-extensions spicetify-nix;
              inherit mpv-config;
            };
          }

          # Mango Window Compositor
          mango.nixosModules.mango
          {
            programs.mango.enable = true;
          }

          # Stylix
          stylix.nixosModules.stylix
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
