{pkgs, ...}: {
  home.packages = [
    # Community Linux ISF server for auto-downloading kernel symbols from memory dump banners.
    # https://github.com/leludo84/vol3-linux-profiles/#symbols-file-automatic-download-in-volatility3
    # https://github.com/Abyss-W4tcher/volatility3-symbols#fetching-symbols-automatically
    (pkgs.unstable.volatility3.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace volatility3/framework/constants/__init__.py \
            --replace-fail 'REMOTE_ISF_URL = None' \
            'REMOTE_ISF_URL = "https://raw.githubusercontent.com/Abyss-W4tcher/volatility3-symbols/master/banners/banners.json"'
        '';
    }))
  ];
}
