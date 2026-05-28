{ pkgs, ... }:
let
  idaRun = ./ida93sp2/ida-pro_93_x64linux.run;
  scriptJs = ./ida93sp2/kg_patch/keygen.js;
in
{
  home.packages = with pkgs; [
    (ida-pro.overrideAttrs (old: {
      version = "9.3.0";
      src = idaRun;

      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.nodejs ];
      buildInputs = (old.buildInputs or []) ++ [ pkgs.libxcrypt-legacy ];

      postInstall = (old.postInstall or "") + ''
        if [ -d "$out/opt" ]; then
          cp ${scriptJs} "$out/opt/script.js"
          cd "$out/opt"
          node ./script.js
        fi
      '';
    }))
  ];
}