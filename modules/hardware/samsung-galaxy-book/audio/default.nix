{ config, inputs, lib, pkgs, ... }:

let
  max98390-hda-fixed =
    (config.boot.kernelPackages.callPackage
      "${inputs.samsung-galaxy-book-linux-fixes}/nixos/max98390-hda-module.nix"
      { })
      .overrideAttrs
      (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          pkgs.llvmPackages.clang-unwrapped
          pkgs.llvmPackages.lld
        ];
        makeFlags = (old.makeFlags or [ ]) ++ [
          "LLVM=1"
          "CC=${pkgs.llvmPackages.clang-unwrapped}/bin/clang"
          "LD=${pkgs.llvmPackages.lld}/bin/ld.lld"
        ];
      });
in
{
  imports = [
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/samsung-speaker-fix.nix"
  ];

  # TODO: Remove this override once upstream nixos/max98390-hda-module.nix
  # builds with clang-compatible kernel toolchains (e.g. CachyOS) out of the box.
  # Upstream module is kept intact; only the package build env is adjusted.
  boot.extraModulePackages = lib.mkForce [ max98390-hda-fixed ];
}