{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.self.packages.${pkgs.system}.onlinefix-linux
  ];
}
