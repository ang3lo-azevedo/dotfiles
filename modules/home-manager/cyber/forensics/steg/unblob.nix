{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO: Remove the override once the upstream issue is resolved
    (unblob.overrideAttrs (_: {
      doCheck = false;
      dontUsePytestCheck = true;
    }))
  ];
}
