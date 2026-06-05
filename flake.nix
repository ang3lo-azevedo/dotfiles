{
  description = "NixOS systems and tools by ang3lo-azevedo";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Latest stable branch of nixpkgs, used for version rollback
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };

    # nixpkgs master
    /* nixpkgs-master = {
      url = "github:nixos/nixpkgs";
    }; */

    # nixpkgs-xr
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
    };

    # dmatools (MemProcFS packaging)
    dmatools = {
      url = "github:tie-infra/dmatools";
    };
    



    # Input for Disko (disk partitioning tool)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Proxmox VE on NixOS modules/overlay
    proxmox-nixos = {
      url = "github:SaumonNet/proxmox-nixos";
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

    # Antigravity (Google Antigravity packaging)
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
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
    samsung-galaxy-book-linux-fixes = {
      url = "path:/home/ang3lo/Documents/projects/samsung-galaxy-book-linux-fixes";
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

    # Archi (ArchiMate tool) from nixpkgs commit
    archi-nixpkgs = {
      url = "github:NixOS/nixpkgs/b347d1435a65f95f3e23dc74f0cc1e30af8a4e9a";
      flake = false;
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

    # Trakt Scrobbler (TODO: fix)
    trakt-scrobbler-src = {
      url = "github:iamkroot/trakt-scrobbler";
      flake = false;
    };

    # angr-management source from GitHub releases (used as `src` for local package)
    angr-management = {
      url = "github:angr/angr-management";
      flake = false;
    };

    # PhotoGIMP assets and config
    photogimp = {
      url = "github:Diolinux/PhotoGIMP/3.0";
      flake = false;
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

    # Steam config for managing launch options and compatibility tools
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Gaming packages, modules, and tools
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic Nyx
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
      "https://cache.saumon.network/proxmox-nixos"
      "https://nix-cache.tokidoki.dev/tokidoki"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
      "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
    ];
    # Allow evaluation of packages that are not available for the detected host
    # platform (e.g. pypy on 32-bit). This makes flake builds accept unsupported
    # packages. Remove if you prefer stricter checks.
    allowUnsupportedSystem = true;
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
      proxmox-nixos,
      zen-browser,
      nix-vscode-extensions,
      spicetify-nix,
      mpv-config,
      trakt-scrobbler-src,
      photogimp,
      nixpkgs-xr,
      steam-config-nix,
      nix-gaming,
      dmatools,
      chaotic,
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
            { networking.hostName = hostname; nixpkgs.config.allowUnsupportedSystem = true; }
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
              (import ./overlays/python-packages.nix)
            ];
          }

          # Stylix overlay
          stylix.nixosModules.stylix

          # Chaotic Nyx (provides nordvpn and other packages)
          chaotic.nixosModules.default
        ];
      };

      # Reusable server-angelo configuration
      server-angelo-config = mkHostConfig {
        stdenv = nixpkgs.legacyPackages.x86_64-linux.stdenv;
        hostname = "server-angelo";
        modules = [
          proxmox-nixos.nixosModules.proxmox-ve
          {
            nixpkgs.overlays = [
              proxmox-nixos.overlays.x86_64-linux
            ];
          }
        ];
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

      # Expose the local `angr-management` package so flakes can reference it
      packages.x86_64-linux.angr-management = import ./pkgs/angr-management/default.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        lib = nixpkgs.lib;
        src = inputs.angr-management;
      };

      # Expose the local `archi` package so flakes can reference it
      packages.x86_64-linux.archi = import ./pkgs/archi/default.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inputs = inputs;
      };

      # Expose the local `nuvio-desktop` package so flakes can reference it
      packages.x86_64-linux.nuvio-desktop = import ./pkgs/nuvio-desktop/default.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        lib = nixpkgs.lib;
      };

      # Expose the local `registry-spy` package so flakes can reference it
      packages.x86_64-linux.registry-spy = import ./pkgs/registry-spy/default.nix {
        lib = nixpkgs.lib;
        fetchFromGitHub = nixpkgs.legacyPackages.x86_64-linux.fetchFromGitHub;
        python3Packages = nixpkgs.legacyPackages.x86_64-linux.python3Packages;
      };

      # Expose the local `dnspy` package so flakes can reference it
      packages.x86_64-linux.dnspy = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/dnspy/default.nix { };

      # Development shells
      devShells.x86_64-linux.android = import ./shells/android.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}
