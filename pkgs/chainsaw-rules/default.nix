{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}: let
  chainsawSrc = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    rev = "v2.16.3";
    hash = "sha256-dG3WxAWnMBMlV3HxI9E7EDvZgK+qYZwRiZVNRf7jekY=";
  };

  sigmaSrc = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "sigma";
    rev = "r2026-07-01";
    hash = "sha256-kb4EcQN9xmA2lYUh6SCG7pST39/Ygoakv/2TwDqgucw=";
  };
in
  stdenvNoCC.mkDerivation rec {
    pname = "chainsaw-rules";
    version = "2.16.3";

    src = chainsawSrc;

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/chainsaw/sigma
      cp -r ${sigmaSrc}/rules $out/share/chainsaw/sigma/
      cp -r mappings $out/share/chainsaw/
    '';

    meta = with lib; {
      description = "Sigma rules and mappings for Chainsaw";
      homepage = "https://github.com/WithSecureLabs/chainsaw";
      platforms = platforms.all;
    };
  }
