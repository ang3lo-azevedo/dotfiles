{
  pkgs ? import <nixpkgs> {},
  inputs ? {},
}: {
  angr-management = import ./angr-management/default.nix {
    inherit pkgs;
    inherit (pkgs) lib;
    src = inputs.angr-management;
  };

  archi = pkgs.callPackage ./archi/default.nix {
    inherit inputs;
  };

  registry-spy = pkgs.callPackage ./registry-spy/default.nix {};

  rem = pkgs.callPackage ./rem/default.nix {};
  dnspy = pkgs.callPackage ./dnspy/default.nix {};
  ctfd-parser = pkgs.callPackage ./ctfd-parser/default.nix {};
  ese-database-view = pkgs.callPackage ./ese-database-view/default.nix {};
  libesedb = pkgs.callPackage ./libesedb/default.nix {};
  libfsntfs = pkgs.callPackage ./libfsntfs/default.nix {};
  sidr = pkgs.callPackage ./sidr/default.nix {};
  scrollmpris = pkgs.callPackage ./scrollmpris/default.nix {};
  monkeylauncher = pkgs.callPackage ./monkeylauncher/default.nix {};
  nuvio = pkgs.callPackage ./nuvio/default.nix {};
  onlinefix-linux = pkgs.callPackage ./onlinefix-linux/default.nix {};

  autodesk-fusion = pkgs.callPackage ./autodesk-fusion/default.nix {
    wine = pkgs.wineWow64Packages.full;
    src = inputs.autodesk-fusion;
  };

  nordvpn = pkgs.callPackage ./nordvpn/default.nix {};
  so-crates = pkgs.callPackage ./so-crates/default.nix {};
  linoffice = pkgs.callPackage ./linoffice/default.nix {};

  ist-fenix-auto-enroller = pkgs.callPackage ./ist-fenix-auto-enroller/default.nix {
    src = inputs.ist-fenix-auto-enroller;
  };

  harbor = pkgs.callPackage ./harbor/default.nix {};
  proton-cachyos-linuwux = pkgs.callPackage ./proton-linuwux/default.nix {};
  steamidra = pkgs.callPackage ./steamidra/default.nix {};
  hayabusa = pkgs.callPackage ./hayabusa/default.nix {};
  sysmontools = pkgs.callPackage ./sysmontools/default.nix {};
  chainsaw-rules = pkgs.callPackage ./chainsaw-rules/default.nix {};
  betterbird = pkgs.callPackage ./betterbird/default.nix {};
  analyzeMFT = pkgs.callPackage ./analyzeMFT/default.nix {};
  ciphey = pkgs.callPackage ./ciphey/default.nix {};
  rsactftool = pkgs.callPackage ./rsactftool/default.nix {};
  tplmap = pkgs.callPackage ./tplmap/default.nix {};
}
