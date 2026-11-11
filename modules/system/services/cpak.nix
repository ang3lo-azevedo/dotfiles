{
  inputs,
  pkgs,
  ...
}: let
  version = "2.14.18";
  vendorHash = "sha256-32I5R+ZSnEVyvwSeoKZDP1tstvAESRd6jrLkbe6Qvgo=";
  cpakPackage = pkgs.buildGoModule {
    pname = "cpak";
    inherit version vendorHash;
    src = inputs.cpak;
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [
      pkgs.gtk3
      pkgs.libadwaita
      pkgs.qt6.qtbase
    ];
    dontWrapQtApps = true;
    preBuild = "make UI_ADAPTERS=all ui-adapters";
    overrideModAttrs = _: {
      preBuild = "";
    };
    subPackages = [
      "."
      "cmd/cpak-storaged"
    ];
    ldflags = [
      "-s"
      "-w"
      "-X=main.version=v${version}"
      "-X=main.selfUpdateMode=disabled"
      "-X=github.com/mirkobrombin/cpak/pkg/desktopui.defaultBackend=auto"
      "-X=github.com/mirkobrombin/cpak/pkg/cpak.defaultSlirpPath=${pkgs.slirp4netns}/bin/slirp4netns"
    ];
    postInstall = ''
      install -Dm644 pkg/systemauthority/assets/it.cpak.SystemAuthority1.conf \
        "$out/share/dbus-1/system.d/it.cpak.SystemAuthority1.conf"
      substituteInPlace "$out/share/dbus-1/system.d/it.cpak.SystemAuthority1.conf" \
        --replace-fail '@SERVICEDIR@' ""

      install -Dm644 pkg/systemauthority/assets/it.cpak.SystemAuthority1.service \
        "$out/share/dbus-1/system-services/it.cpak.SystemAuthority1.service"
      substituteInPlace "$out/share/dbus-1/system-services/it.cpak.SystemAuthority1.service" \
        --replace-fail '@BINARY@' "$out/bin/cpak"

      install -Dm644 pkg/systemauthority/assets/cpak-system-authority.service \
        "$out/lib/systemd/system/cpak-system-authority.service"
      substituteInPlace "$out/lib/systemd/system/cpak-system-authority.service" \
        --replace-fail '@BINARY@' "$out/bin/cpak"

      install -Dm644 pkg/systemauthority/assets/it.cpak.system.policy \
        "$out/share/polkit-1/actions/it.cpak.system.policy"
      install -Dm644 pkg/systemauthority/assets/cpak-userns \
        "$out/etc/apparmor.d/cpak-userns"
      substituteInPlace "$out/etc/apparmor.d/cpak-userns" \
        --replace-fail '@BINARY@' "$out/bin/cpak"
      install -Dm644 cpak-icon.png "$out/share/icons/hicolor/512x512/apps/it.cpak.cpak.png"
    '';
  };
in {
  # The upstream module (rather than the nixpkgs package) also registers the
  # D-Bus system authority and polkit policy that `cpak system setup` expects
  imports = [inputs.cpak.nixosModules.default];

  services.cpak = {
    enable = true;
    package = cpakPackage;
  };

  # Apps with displayX11 get a private Xwayland per sandbox, looked up on PATH;
  # niri only ships xwayland-satellite, which cpak can't use
  environment.systemPackages = [pkgs.xwayland];
}
