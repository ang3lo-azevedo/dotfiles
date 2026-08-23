{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    apk-mitm
  ];
}
