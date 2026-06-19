{ pkgs, ... }:
let
  idaRun = ./ida94b1/ida-pro_94_x64linux.run;
  scriptJs =./ida94b1/kg_patch/keygen.js;
  kgExists = builtins.pathExists scriptJs;
  idaExists = builtins.pathExists idaRun;
in
{
  home.packages = with pkgs; if idaExists then [
    (ida-pro.overrideAttrs (old: {
      version = "9.4.0";
      src = idaRun;

      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.nodejs ];
      buildInputs = (old.buildInputs or []) ++ [ pkgs.libxcrypt-legacy ];

      postInstall = (old.postInstall or "") + (if kgExists then ''
        if [ -d "$out/opt" ]; then
          cp ${scriptJs} "$out/opt/script.js"
          cd "$out/opt"
          node ./script.js
        fi
      '' else "");
    }))
  ] else [];
}