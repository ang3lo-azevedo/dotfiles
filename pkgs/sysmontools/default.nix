{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "sysmontools";
  version = "2.2.1";

  src = fetchurl {
    url = "https://github.com/nshalabi/SysmonTools/releases/download/v${version}/SysmonView-${version}-linux-x86_64.AppImage";
    sha256 = "17cihikknffffglrpdrn92ysa8vg8a0367s38w70dv0x6x5d2h27";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/sysmon-view.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/sysmon-view.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    meta = with lib; {
      description = "A utility to view and analyze Sysmon logs";
      homepage = "https://github.com/nshalabi/SysmonTools";
      platforms = ["x86_64-linux"];
      mainProgram = "sysmontools";
    };
  }
