{ pkgs, ... }:
let
  sources = pkgs.callPackage ../../../../../pkgs/_sources/generated.nix { };
  ida-chat-plugin = sources.ida-chat-plugin.src;
in
{
  home.packages = with pkgs; [
    (ida-chat-plugin.overrideAttrs (old: {
      buildInputs = (old.buildInputs or []) ++ [ cmake python311 ];
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ cmake python311 ];
    }))
  ];
}
