# Keep pure binary extractions, autoPatchelf, and lightweight wrappers off
# the eu.nixbuild.net remote builder.
#
# Packages that merely unpack a prebuilt archive (tarball, zip, deb, flatpak)
# and run autoPatchelf or makeWrapper do not compile code. With distributed
# builds on, Nix can route those extractions to eu.nixbuild.net, which first
# uploads the entire multi-megabyte/gigabyte archive over this machine's slow
# uplink, only for nixbuild to extract it in seconds and have the client download
# the even larger uncompressed tree back.
#
# Tagging with requiredSystemFeatures = ["local"] and preferLocalBuild = true
# keeps the extraction and patching on this machine. Substitution stays enabled
# so builds already in binary caches are still downloaded rather than re-extracted.
_: prev: let
  pinLocal = pkg:
    pkg.overrideAttrs (old: {
      preferLocalBuild = true;
      requiredSystemFeatures = (old.requiredSystemFeatures or []) ++ ["local"];
    });
in {
  # Google Antigravity CLI (extracts cli_linux_x64.tar.gz + autoPatchelf)
  google-antigravity-cli =
    if prev ? google-antigravity-cli
    then pinLocal prev.google-antigravity-cli
    else prev.google-antigravity-cli;

  # Betterbird (extracts betterbird.tar.xz + autoPatchelf)
  betterbird =
    if prev ? betterbird
    then pinLocal prev.betterbird
    else prev.betterbird;

  # NordVPN (extracts nordvpn.deb + autoPatchelf)
  nordvpn =
    if prev ? nordvpn
    then pinLocal prev.nordvpn
    else prev.nordvpn;

  # Hayabusa (extracts hayabusa.zip + autoPatchelf)
  hayabusa =
    if prev ? hayabusa
    then pinLocal prev.hayabusa
    else prev.hayabusa;

  # GDSDecomp (extracts gdsdecomp.zip + autoPatchelf)
  gdsdecomp =
    if prev ? gdsdecomp
    then pinLocal prev.gdsdecomp
    else prev.gdsdecomp;

  # Harbor (extracts harbor.deb + autoPatchelf)
  harbor =
    if prev ? harbor
    then pinLocal prev.harbor
    else prev.harbor;

  # Archi (extracts Archi-Linux64.tgz + autoPatchelf)
  archi =
    if prev ? archi
    then pinLocal prev.archi
    else prev.archi;

  # AIOStreams Desktop (extracts .flatpak bundle + autoPatchelf)
  aiostreams-desktop =
    if prev ? aiostreams-desktop
    then pinLocal prev.aiostreams-desktop
    else prev.aiostreams-desktop;
}
