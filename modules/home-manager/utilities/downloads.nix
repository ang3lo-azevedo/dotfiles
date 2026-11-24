{pkgs, ...}: let
  motrix-next = pkgs.symlinkJoin {
    name = "motrix-next-${pkgs.rayburst.version}";
    paths = [pkgs.rayburst];
    preferLocalBuild = true;
    requiredSystemFeatures = ["local"];
    postBuild = ''
      ln -s $out/bin/rayburst $out/bin/motrix-next
      rm -f $out/share/applications/Rayburst.desktop
      sed -e 's/^Name=Rayburst/Name=Motrix Next (Rayburst)/' \
          -e 's/^Comment=/GenericName=Motrix Next\nKeywords=motrix;motrix-next;rayburst;download;torrent;\nComment=/' \
          ${pkgs.rayburst}/share/applications/Rayburst.desktop > $out/share/applications/Rayburst.desktop
      ln -s $out/share/applications/Rayburst.desktop $out/share/applications/motrix-next.desktop
    '';
  };
in {
  home.packages = [
    motrix-next
  ];
}
