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
    src =
      if builtins.pathExists /home/ang3lo/Documents/projects/ist-fenix-auto-enroller
      then /home/ang3lo/Documents/projects/ist-fenix-auto-enroller
      else inputs.ist-fenix-auto-enroller;
  };

  vorion = pkgs.callPackage ./ang3lo-nur/pkgs/vorion {};
}
// (
  if inputs ? ang3lo-nur
  then builtins.removeAttrs inputs.ang3lo-nur.legacyPackages.${pkgs.stdenv.hostPlatform.system} ["lib" "nixosModules" "overlays"]
  else {}
)
