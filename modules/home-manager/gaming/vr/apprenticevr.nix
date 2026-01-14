{ pkgs, ... }:
let
  apprenticevr = pkgs.appimageTools.wrapType2 {
    name = "apprenticevr";
    src = pkgs.fetchurl {
      url = "https://github.com/jimzrt/apprenticeVr/releases/download/v1.3.4/apprenticevr-1.3.4-x86_64.AppImage";
      sha256 = "09ylmskfpl8qggghy83s9hgfhnc1w7z9ddqyb07473jpmh7gbyjv";
    };
    extraPkgs = pkgs: with pkgs; [
      android-tools # for adb
    ];
  };
in
{
  home.packages = [ apprenticevr ];
}
