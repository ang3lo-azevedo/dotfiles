{
  pkgs,
  inputs,
  ...
}: let
  idaRun = inputs.self + "/private/ida-pro/ida94b1/ida-pro_94_x64linux.run";
  scriptJs = inputs.self + "/private/ida-pro/ida94b1/setup/setup.js";
  setupExists = builtins.pathExists scriptJs;
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
            then ''
              if [ -d "$out/opt" ]; then
                cp ${scriptJs} "$out/opt/script.js"
                cd "$out/opt"
                node ./script.js
              fi
            ''
            else ""
          );
      }))
    ]
    else [];
}
