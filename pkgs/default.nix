{
  pkgs ? import <nixpkgs> {},
  inputs ? {},
  ...
}:
{}
// (
  if inputs ? ang3lo-nur
  then builtins.removeAttrs (import "${inputs.ang3lo-nur}/default.nix" {inherit pkgs;}) ["lib" "nixosModules" "overlays"]
  else {}
)
// (
  if inputs ? th3m1ghtyduck-nur
  then builtins.removeAttrs (import "${inputs.th3m1ghtyduck-nur}/default.nix" {inherit pkgs;}) ["lib" "nixosModules" "overlays"]
  else {}
)
