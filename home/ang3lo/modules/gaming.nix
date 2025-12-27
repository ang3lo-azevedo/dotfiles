{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Gaming platforms
    steam
    
    # VR support
    monado
    opencomposite
    wlx-overlay-s
    
    # VR utilities
    alvr
  ];
}
