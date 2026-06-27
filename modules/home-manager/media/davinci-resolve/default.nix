{
  pkgs,
  inputs,
  ...
}: let
  cfgDir = inputs.self + "/private/davinci-resolve/config";
  hasCfg = builtins.pathExists cfgDir;

  davinci =
    if hasCfg
    then
      pkgs.davinci-resolve-studio.davinci.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.perl];
        installPhase = (old.installPhase or "") + (import cfgDir).setup;
      })
    else pkgs.davinci-resolve-studio.davinci;

  resolved = let
    wrapper = pkgs.writeShellScriptBin "davinci-resolve-studio" ''
      export QT_QPA_PLATFORM=xcb
      exec ${pkgs.davinci-resolve-studio}/bin/davinci-resolve-studio ${davinci}/bin/resolve "$@"
    '';
  in
    pkgs.symlinkJoin {
      name = "davinci-resolve-studio";
      paths = [pkgs.davinci-resolve-studio];
      postBuild = ''
        rm -f $out/bin/davinci-resolve-studio
        ln -s ${wrapper}/bin/davinci-resolve-studio $out/bin/davinci-resolve-studio
      '';
    };
in {
  home.packages = [resolved];

  home.file =
    if hasCfg
    then (import cfgDir).homeFiles
    else {};
}
