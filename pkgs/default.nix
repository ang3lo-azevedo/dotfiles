{
  pkgs ? import <nixpkgs> {},
  inputs ? {},
  system ? pkgs.stdenv.hostPlatform.system,
  ...
}:
{}
// (
  if inputs ? ang3lo-nur
  then inputs.ang3lo-nur.packages.${system} or {}
  else {}
)
// (
  if inputs ? th3m1ghtyduck-nur
  then inputs.th3m1ghtyduck-nur.packages.${system} or {}
  else {}
)
