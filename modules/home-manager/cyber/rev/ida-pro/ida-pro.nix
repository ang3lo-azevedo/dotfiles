{pkgs, ...}: let
  idaRun = /home/ang3lo/nix-config/private/ida-pro/ida94b1/ida-pro_94_x64linux.run;
  setupDir = /home/ang3lo/nix-config/private/ida-pro/ida94b1/setup;
  setupExists = builtins.pathExists setupDir;
  idaExists = builtins.pathExists idaRun;
in {
  home.packages = with pkgs;
    if idaExists
    then [
      (ida-pro.overrideAttrs (old: {
        version = "9.4.0";
        src = idaRun;

        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.nodejs];
        buildInputs = (old.buildInputs or []) ++ [pkgs.libxcrypt-legacy];

        postInstall =
          (old.postInstall or "")
          + (
            if setupExists
            then (import setupDir).postInstall
            else ""
          );
      }))
    ]
    else [];
}
