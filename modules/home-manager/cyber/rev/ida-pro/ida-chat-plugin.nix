{ pkgs, ... }:
let
  ida-chat-plugin = pkgs.fetchFromGitHub {
    owner = "HexRaysSA";
    repo = "ida-chat-plugin";
    rev = "HEAD";
    sha256 = "sha256-ueGelV0KZhE4k7O5VsBTSfZgWz/gm9Lr3CdIYl99Yd8=";
  };
in
{
  home.packages = with pkgs; [
    (ida-chat-plugin.overrideAttrs (old: {
      buildInputs = (old.buildInputs or []) ++ [ cmake python311 ];
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ cmake python311 ];
    }))
  ];
}
