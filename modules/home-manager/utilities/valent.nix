{pkgs, ...}: {
  systemd.user.services.valent = {
    Unit = {
      Description = "Valent, KDE Connect implementation";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.valent}/bin/valent";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
