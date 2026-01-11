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

    # Input for Impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Stylix (styling tool)
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apple Emoji
    apple-emoji = {
      url = "github:samuelngs/apple-emoji-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Libfprint fork for EgisTec support
    libfprint-src = {
      url = "gitlab:joshuagrisham/libfprint/egismoc-sdcp?host=gitlab.freedesktop.org";
      flake = false;
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

    # MPV config
    mpv-config = {
      url = "github:ang3lo-azevedo/mpv";
      flake = false;
    };

    # Trakt Scrobbler
    trakt-scrobbler-src = {
      url = "github:iamkroot/trakt-scrobbler";
      flake = false;
    };

    # NordVPN client for NixOS/Home Manager
    nordvpn-flake = {
      url = "github:scouckel/nordvpn-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pwndbg
    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs-xr
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    #max-jobs = 0;
  };

  # The outputs of the flake
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
      , mpv-config
      , trakt-scrobbler-src
      , nordvpn-flake
      , nixpkgs-xr
      , ...
    }@inputs:
    let
      lib = nixpkgs.lib;

      # Helper function to generate a NixOS system configuration
      mkNixosSystem =
        {
          system,
          modules,
          specialArgs,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system modules specialArgs;
        };

      # Helper function to generate a reusable host configuration
      mkHostConfig =
        {
          stdenv,
          hostname,
          modules ? [ ],
        }:
        {
          system = stdenv.hostPlatform.system;
          specialArgs = { inherit inputs; };
          modules = [
            { networking.hostName = hostname; }
          ]
          ++ (lib.optional (builtins.pathExists ./hosts/${hostname}/disko.nix) (
            import ./hosts/${hostname}/disko.nix
          ))
          ++ (lib.optional (builtins.pathExists ./hosts/${hostname}/disko.nix) disko.nixosModules.disko)
          ++ [
            ./hosts/${hostname}/configuration.nix

            # Agenix for secrets management
            agenix.nixosModules.default
          ]
          ++ modules;
        };

      # Configuration for pc-angelo
      pc-angelo-config = mkHostConfig {
        stdenv = nixpkgs.legacyPackages.x86_64-linux.stdenv;
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
              inherit
                inputs
                mango
                zen-browser
                nix-vscode-extensions
                spicetify-nix
                mpv-config
                trakt-scrobbler-src
                ;
            };
          }

          # Mango Window Compositor
          mango.nixosModules.mango
          {
            programs.mango.enable = true;
          }

          # Stylix
          stylix.nixosModules.stylix

          # NordVPN client
          nordvpn-flake.nixosModules.nordvpn-flake

          # nixpkgs-xr
          nixpkgs-xr.nixosModules.nixpkgs-xr
        ];
      };

      # Reusable server-angelo configuration
      server-angelo-config = mkHostConfig {
        stdenv = nixpkgs.legacyPackages.x86_64-linux.stdenv;
        hostname = "server-angelo";
      };
    in
    {
      # NixOS configuration for pc-angelo
      nixosConfigurations.pc-angelo = mkNixosSystem pc-angelo-config;

      # NixOS configuration for server-angelo
      nixosConfigurations.server-angelo = mkNixosSystem server-angelo-config;

      # Standalone Home Manager configuration
      homeConfigurations."ang3lo" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit
            inputs
            mango
            zen-browser
            nix-vscode-extensions
            spicetify-nix
            mpv-config
            trakt-scrobbler-src
            ;
        };
        modules = [
          ./home/ang3lo/home.nix
        ];
      };
    };
}
