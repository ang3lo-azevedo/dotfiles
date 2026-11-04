{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.onlinefix-linux
  ];
}
