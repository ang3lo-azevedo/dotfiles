{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    (pkgs.callPackage (inputs.self + "/pkgs/ist-fenix-auto-enroller/default.nix") {
      src = inputs.ist-fenix-auto-enroller;
    })
  ];
}
