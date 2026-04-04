{
  description = "NixOS systems and tools by ang3lo-azevedo";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Latest stable branch of nixpkgs, used for version rollback
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };

    # nixpkgs master
    /* nixpkgs-master = {
      url = "github:nixos/nixpkgs";
    }; */

    # nixpkgs-xr
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
    };

    # For Jackify
    nixpkgs-extra = {
      url = "github:Mistyttm/nixpkgs-extra";
    };

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

    # Haumea for filesystem-based module system
    haumea = {
      url = "github:nix-community/haumea";
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
      url = "github:samuelngs/apple-emoji-ttf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Libfprint fork for EgisTec support
    libfprint-src = {
      url = "gitlab:joshuagrisham/libfprint/egismoc-sdcp?host=gitlab.freedesktop.org";
      flake = false;
    };

    # Samsung Galaxy Book Linux fixes repository (use nixos/ modules directly)
    # TODO: Switch this back to github:Andycodeman/samsung-galaxy-book-linux-fixes
    # once the toolchain fix is available in the original upstream source.
    samsung-galaxy-book-linux-fixes = {
      url = "github:ang3lo-azevedo/samsung-galaxy-book-linux-fixes";
      flake = false;
    };

    # Input for CachyOS Kernel
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
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

    # Fake Voice Options Equicord plugin source
    fakeVoiceOptions = {
      url = "github:eightcon/FakeVoiceOptions";
      flake = false;
    };

    # Input for Spicetify Nix (Spotify customizer)
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Pear Desktop (formerly youtube-music)
    pear-desktop = {
      url = "github:h-banii/youtube-music-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for Affinity Designer/Photo/Publisher NixOS/Home Manager modules
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
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

    # PhotoGIMP assets and config
    photogimp = {
      url = "github:Diolinux/PhotoGIMP/3.0";
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

    # For IDA Pro
    ida-pro-overlay = {
      url = "github:msanft/ida-pro-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For Binary Ninja
    binaryninja = {
      url = "github:jchv/nix-binary-ninja";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For QRookie
    glaumar_repo = {
      url = "github:glaumar/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stremio Enhanced - Enhanced Stremio desktop client with plugins and themes
    stremio-enhanced = {
      url = "github:REVENGE977/stremio-enhanced";
      flake = false;
    };

    # Custom package set with Playtorrio v2
    custom-packages = {
      url = "github:Rishabh5321/custom-packages-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  # The outputs of the flake
  outputs =
    {
      self,
      nixpkgs,
      disko,
      agenix,
      home-manager,
      haumea,
      stylix,
      nix-cachyos-kernel,
      zen-browser,
      nix-vscode-extensions,
      spicetify-nix,
      mpv-config,
      trakt-scrobbler-src,
      photogimp,
      nordvpn-flake,
      nixpkgs-xr,
      ...
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
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.ang3lo = import ./home/ang3lo/home.nix;
            home-manager.extraSpecialArgs = {
              inherit
                inputs
                zen-browser
                nix-vscode-extensions
                spicetify-nix
                mpv-config
                trakt-scrobbler-src
                ;
            };
          }

          {
            # Alternatively: use the exact kernel versions as defined in this repo.
            # Guarantees you have binary cache.
            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.pinned
            ];
          }

          # Stylix overlay
          stylix.nixosModules.stylix

          # NordVPN flake overlay
          nordvpn-flake.nixosModules.nordvpn-flake
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

      # Development shells
      devShells.x86_64-linux.android = import ./shells/android.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}
