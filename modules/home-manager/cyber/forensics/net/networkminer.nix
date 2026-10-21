{pkgs, ...}: {
  home.packages = [
    # FIXME: Back to pkgs once it builds: from nixpkgs 09063bd1f2b3 on, patchelf aborts on the
    # PowerShell 7.0.0 that its msbuild dependency bundles (same bug as semgrep in zed.nix)
    pkgs.stable.networkminer
  ];
}
