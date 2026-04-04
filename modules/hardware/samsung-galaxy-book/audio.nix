{ inputs, ... }:

{
  imports = [
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/samsung-speaker-fix.nix"
  ];

  # TODO: Remove this commented override block once the original upstream source
  # (Andycodeman/samsung-galaxy-book-linux-fixes) contains the toolchain fix.
  #
  # boot.extraModulePackages = lib.mkForce [
  #   ((config.boot.kernelPackages.callPackage
  #     "${inputs.samsung-galaxy-book-linux-fixes}/nixos/max98390-hda-module.nix"
  #     { })
  #     .overrideAttrs (old: {
  #       nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
  #         pkgs.llvmPackages.clang-unwrapped
  #         pkgs.llvmPackages.lld
  #       ];
  #       makeFlags = (old.makeFlags or [ ]) ++ [
  #         "LLVM=1"
  #         "CC=${pkgs.llvmPackages.clang-unwrapped}/bin/clang"
  #         "LD=${pkgs.llvmPackages.lld}/bin/ld.lld"
  #       ];
  #     }))
  # ];
}