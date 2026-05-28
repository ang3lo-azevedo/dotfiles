{ inputs, ... }:

{
  imports = [
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/samsung-speaker-fix.nix"
  ];
}