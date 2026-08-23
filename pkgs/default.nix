{
  pkgs ? import <nixpkgs> {},
  inputs ? {},
  ...
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
  then builtins.removeAttrs (import "${inputs.ang3lo-nur}/default.nix" {inherit pkgs;}) ["lib" "nixosModules" "overlays"]
  else {}
)
