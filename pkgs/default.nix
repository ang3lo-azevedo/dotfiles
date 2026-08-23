{
  pkgs ? import <nixpkgs> {},
  inputs ? {},
  system ? pkgs.system,
}:
{
  angr-management = import ./angr-management/default.nix {
    inherit pkgs;
    inherit (pkgs) lib;
    src = inputs.angr-management;
  };

  autodesk-fusion = pkgs.callPackage ./autodesk-fusion/default.nix {
    wine = pkgs.wineWow64Packages.full;
    src = inputs.autodesk-fusion;
  };

  ist-fenix-auto-enroller = pkgs.callPackage ./ist-fenix-auto-enroller/default.nix {
    src = inputs.ist-fenix-auto-enroller;
  };
}
// (
  if inputs ? ang3lo-nur
  then inputs.ang3lo-nur.packages.${system}
  else {}
)
