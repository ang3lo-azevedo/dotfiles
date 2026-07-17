{
  description = "NixOS systems and tools by ang3lo-azevedo";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Latest stable branch of nixpkgs, used for version rollback
    /*
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };
    */

    # nixpkgs master
    /*
       nixpkgs-master = {
      url = "github:nixos/nixpkgs";
    };
    */

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

    # Libfprint fork for EgisTec support
    libfprint-src = {
      url = "gitlab:joshuagrisham/libfprint/egismoc-sdcp?host=gitlab.freedesktop.org";
      flake = false;
    };

    # Samsung Galaxy Book Linux fixes repository (use nixos/ modules directly)
    samsung-galaxy-book-linux-fixes = {
      url = "github:ang3lo-azevedo/samsung-galaxy-book-linux-fixes";
      flake = false;
    };

    # Input for CachyOS Kernel
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    # xddxdd's NUR packages (bambu-studio-bin and others, cached at attic.xuyh0120.win/lantian)
    xddxdd-nur = {
      url = "github:xddxdd/nur-packages";
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

    # Berberman's flakes (for apple-emoji)
    berberman = {
      url = "github:berberman/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Nirinit
    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri main branch, patched with shake-to-find-cursor (PR #2797)
    niri-main = {
      url = "github:niri-wm/niri";
      flake = false;
    };

    # IST Fénix Auto Enroller
    ist-fenix-auto-enroller = {
      url = "github:ang3lo-azevedo/ist-fenix-auto-enroller";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit hooks for Nix
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lanzaboote for Secure Boot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # cryinkfly's Autodesk Fusion 360 on Linux installer
    autodesk-fusion = {
      url = "https://codeberg.org/cryinkfly/Autodesk-Fusion-360-on-Linux/archive/main.tar.gz";
      flake = false;
    };

    # SteaMidra - Steam game setup and management tool
    steamidra = {
      url = "github:Midrags/SFF";
      flake = false;
    };
  };

  # These are the flake-level binary caches.
  # They are read STRICTLY by the Nix evaluator BEFORE anything is built.
  # This ensures Nix can use the cache to download flake inputs (like nixpkgs itself)
  # or cache the initial evaluation and devShell environments.
  #
  # IMPORTANT: Keep this list in sync with `modules/system/binary-cache.nix`!
  nixConfig = {
    extra-substituters = [
      # Personal cache, custom packages and full system closure
      "https://ang3lo.cachix.org"

      # Official cache for community flakes (home-manager, disko, impermanence, stylix)
      "https://nix-community.cachix.org"

      # Lantian's cache (custom networking tools, CachyOS kernels)
      "https://attic.xuyh0120.win/lantian"

      # Garnix CI cache (used by flakes like zen-browser and dmatools)
      "https://cache.garnix.io"

      # Proxmox NixOS cache (pre-compiled guest agents and VM tools)
      "https://cache.saumon.network/proxmox-nixos"

      # Berberman cache (apple-emoji, fcitx5 themes, nvfetcher)
      "https://berberman.cachix.org"

      # Cache for nix-gaming packages (wine, lutris, etc.)
      "https://nix-gaming.cachix.org"

      # Cache for nix-gaming-edge (TODO: Re-enable when it is fixed)
      #"https://nix-cache.tokidoki.dev/tokidoki"
    ];
    extra-trusted-public-keys = [
      "ang3lo.cachix.org-1:RckESjXE0fJr+FTfC4akKPi3+EBgpyPQLmZU23N4y3E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
      "berberman.cachix.org-1:UHGhodNXVruGzWrwJ12B1grPK/6Qnrx2c3TjKueQPds="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
    ];
    # Allow evaluation of packages that are not available for the detected host
    # platform (e.g. pypy on 32-bit). This makes flake builds accept unsupported
    # packages. Remove to prefer stricter checks.
    allowUnsupportedSystem = true;
  };

  # The outputs of the flake
  outputs = {
    self,
    nixpkgs,
    disko,
    agenix,
    home-manager,
    stylix,
    lanzaboote,
    nix-cachyos-kernel,
    proxmox-nixos,
    zen-browser,
    nix-vscode-extensions,
    spicetify-nix,
    mpv-config,
    trakt-scrobbler-src,
    chaotic,
    pre-commit-hooks,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    # Helper function to generate a NixOS system configuration
    mkNixosSystem = {
      system,
      modules,
      specialArgs,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system modules specialArgs;
      };

    # Helper function to generate a reusable host configuration
    mkHostConfig = {
      stdenv,
      hostname,
      modules ? [],
    }: {
      system = stdenv.hostPlatform.system;
      specialArgs = {inherit inputs;};
      modules =
        [
          {
            networking.hostName = hostname;
            nixpkgs.config.allowUnsupportedSystem = true;
          }
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
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            users.ang3lo = import ./home/ang3lo/home.nix;
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
          };
        }

        {
          # Alternatively: use the exact kernel versions as defined in this repo.
          # Guarantees you have binary cache.
          nixpkgs = {
            config = {
              allowBroken = true;
              permittedInsecurePackages = [
                "electron-39.8.10"
                "ventoy-1.1.12"
              ];
            };
            overlays = [
              nix-cachyos-kernel.overlays.pinned
              (import ./overlays/python-packages.nix)
              inputs.firefox-addons.overlays.default
              (import ./overlays/firefox-addons.nix)
              inputs.nix-vscode-extensions.overlays.default
              inputs.antigravity-nix.overlays.default
              inputs.ida-pro-overlay.overlays.default
              inputs.binaryninja.overlays.default
              inputs.dmatools.overlays.default
              (_: _: {
                xr = inputs.nixpkgs-xr.packages."x86_64-linux";
              })
              (_: prev: {
                # TODO: remove once pdal/vtk fix GDAL 3.13 const API incompatibility (GetMetadata returns CSLConstList)
                pdal = prev.pdal.overrideAttrs (old: {
                  env = (old.env or {}) // {NIX_CFLAGS_COMPILE = ((old.env or {}).NIX_CFLAGS_COMPILE or "") + " -fpermissive";};
                });
                vtk = prev.vtk.overrideAttrs (old: {
                  env = (old.env or {}) // {NIX_CFLAGS_COMPILE = ((old.env or {}).NIX_CFLAGS_COMPILE or "") + " -fpermissive";};
                });
                # TODO: drop this override once PR #2797 lands in a niri release and
                # nixpkgs packages that release.
                # Track niri main with PR #2797 (pointer/tablet input events) applied
                # until it lands in a stable release.
                niri = prev.niri.overrideAttrs (_: {
                  src = inputs.niri-main;
                  version = "26.4.0-pr2797";
                  patches = [
                    (prev.fetchpatch {
                      url = "https://github.com/niri-wm/niri/pull/2797.patch";
                      hash = "sha256-ZJiXdYT7on+hAoU2Sh0RlfDE4a0Ta/JYtMC5jUU6Wf8=";
                    })
                  ];
                  cargoDeps = prev.rustPlatform.fetchCargoVendor {
                    pname = "niri-main-pr2797";
                    version = "26.4.0-pr2797";
                    src = inputs.niri-main;
                    hash = "sha256-jmYkGX4M69W16qr9kLHfnAAJWvJ87IMVBQcC2wE9Phc=";
                  };
                  doInstallCheck = false;
                });
              })
              (_: prev: {
                glaumar_repo = inputs.glaumar_repo.packages."x86_64-linux";
                xddxdd = inputs.xddxdd-nur.packages."x86_64-linux";
                nordvpn = prev.callPackage (inputs.self + "/pkgs/nordvpn/default.nix") {};
                angr-management = prev.callPackage (inputs.self + "/pkgs/angr-management/default.nix") {
                  src = inputs.angr-management;
                };
                archi = prev.callPackage (inputs.self + "/pkgs/archi/default.nix") {
                  inherit inputs;
                };
                autodesk-fusion = prev.callPackage (inputs.self + "/pkgs/autodesk-fusion/default.nix") {
                  wine = prev.wineWow64Packages.full;
                  src = inputs.autodesk-fusion;
                };
                trakt-scrobbler = prev.callPackage (inputs.self + "/pkgs/trakt-scrobbler/default.nix") {};
                cursor-id-modifier = prev.callPackage (inputs.self + "/pkgs/cursor-id-modifier/default.nix") {};
                stremio-enhanced = prev.callPackage (inputs.self + "/pkgs/stremio-enhanced/default.nix") {};
                ctfd-parser = prev.callPackage (inputs.self + "/pkgs/ctfd-parser/default.nix") {};
                ese-database-view = prev.callPackage (inputs.self + "/pkgs/ese-database-view/default.nix") {};
                ffmpeg-encoder-plugin-resolve = prev.callPackage (inputs.self + "/pkgs/ffmpeg-encoder-plugin-resolve/default.nix") {};
                libesedb = prev.callPackage (inputs.self + "/pkgs/libesedb/default.nix") {};
                libfsntfs = prev.callPackage (inputs.self + "/pkgs/libfsntfs/default.nix") {};
                sidr = prev.callPackage (inputs.self + "/pkgs/sidr/default.nix") {};
                monkeylauncher = prev.callPackage (inputs.self + "/pkgs/monkeylauncher/default.nix") {};
                linoffice = prev.callPackage (inputs.self + "/pkgs/linoffice/default.nix") {};
                proton-cachyos-linuwux = prev.callPackage (inputs.self + "/pkgs/proton-linuwux/default.nix") {};
                steamidra = prev.callPackage (inputs.self + "/pkgs/steamidra/default.nix") {};
              })
            ];
          };
        }

        # Stylix overlay
        stylix.nixosModules.stylix

        # Lanzaboote for Secure Boot
        lanzaboote.nixosModules.lanzaboote

        # Chaotic Nyx (provides miscellaneous bleeding-edge packages)
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
  in {
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

    # Expose the local packages so flakes can reference them
    packages.x86_64-linux = {
      angr-management = import ./pkgs/angr-management/default.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit (nixpkgs) lib;
        src = inputs.angr-management;
      };

      archi = import ./pkgs/archi/default.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit inputs;
      };

      nuvio-desktop = import ./pkgs/nuvio-desktop/default.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit (nixpkgs) lib;
      };

      registry-spy = import ./pkgs/registry-spy/default.nix {
        inherit (nixpkgs) lib;
        fetchFromGitHub = nixpkgs.legacyPackages.x86_64-linux.fetchFromGitHub;
        python3Packages = nixpkgs.legacyPackages.x86_64-linux.python3Packages;
      };

      rem = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/rem/default.nix {};
      dnspy = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/dnspy/default.nix {};
      ctfd-parser = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/ctfd-parser/default.nix {};
      ese-database-view = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/ese-database-view/default.nix {};
      libesedb = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/libesedb/default.nix {};
      libfsntfs = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/libfsntfs/default.nix {};
      sidr = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/sidr/default.nix {};
      scrollmpris = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/scrollmpris/default.nix {};
      monkeylauncher = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/monkeylauncher/default.nix {};
      autodesk-fusion = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/autodesk-fusion/default.nix {
        wine = nixpkgs.legacyPackages.x86_64-linux.wineWow64Packages.full;
        src = inputs.autodesk-fusion;
      };
      nordvpn = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/nordvpn/default.nix {};
      linoffice = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/linoffice/default.nix {};
      ist-fenix-auto-enroller = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/ist-fenix-auto-enroller/default.nix {
        src = inputs.ist-fenix-auto-enroller;
      };
      harbor = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/harbor/default.nix {};
      proton-cachyos-linuwux = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/proton-linuwux/default.nix {};
      steamidra = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/steamidra/default.nix {};
    };

    # Pre-commit checks
    checks.x86_64-linux = {
      pre-commit-check = pre-commit-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks = {
          # Format Nix code
          alejandra = {
            enable = true;
            excludes = [".*generated\\.nix$"];
          };
          # Check for missing or unused variables
          deadnix = {
            enable = true;
            excludes = [".*generated\\.nix$"];
          };
          # Catch Nix syntax errors and anti-patterns
          statix.enable = true;
          # Lint shell scripts for bugs and pitfalls
          shellcheck.enable = true;
          # Format shell scripts
          shfmt.enable = true;
        };
      };
    };

    # Development shells
    devShells.x86_64-linux = {
      default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        inherit (self.checks.x86_64-linux.pre-commit-check) shellHook;
        buildInputs = self.checks.x86_64-linux.pre-commit-check.enabledPackages;
      };
      android = import ./shells/android.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };

    formatter.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.writeShellApplication {
        name = "alejandra";
        runtimeInputs = [pkgs.alejandra];
        text = ''exec alejandra --exclude './pkgs/_sources/generated.nix' "$@"'';
      };
  };
}
