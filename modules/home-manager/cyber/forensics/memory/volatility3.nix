{pkgs, ...}: {
  home.packages = [
    # Community Linux ISF server for auto-downloading kernel symbols from memory dump banners.
    # Upstream ships REMOTE_ISF_URL = None (no official Linux server exists).
    (pkgs.volatility3.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace volatility3/framework/constants/__init__.py \
            --replace-fail 'REMOTE_ISF_URL = None' \
            'REMOTE_ISF_URL = "https://raw.githubusercontent.com/leludo84/vol3-linux-profiles/main/banners-isf.json"'
        '';
    }))
  ];
}
