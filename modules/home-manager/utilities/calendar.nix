{ config, pkgs, ... }:

{
  programs.khal = {
    enable = true;
    locale = {
      timeformat = "%H:%M";
      dateformat = "%Y-%m-%d";
      longdateformat = "%Y-%m-%d";
      datetimeformat = "%Y-%m-%d %H:%M";
      longdatetimeformat = "%Y-%m-%d %H:%M";
    };
  };

  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;

  accounts.calendar.accounts = {
    nextcloud = {
      primary = true;
      local = {
        type = "filesystem";
        fileExt = ".ics";
      };
      remote = {
        type = "caldav";
      };
      vdirsyncer = {
        enable = true;
        urlCommand = ["sh" "-c" "source /run/agenix/nextcloud_caldav && echo $URL"];
        userNameCommand = ["sh" "-c" "source /run/agenix/nextcloud_caldav && echo $USERNAME"];
        passwordCommand = ["sh" "-c" "source /run/agenix/nextcloud_caldav && echo $PASSWORD"];
        collections = [ "from a" "from b" ];
        conflictResolution = "remote wins";
      };
      khal = {
        enable = true;
        type = "discover";
      };
    };
  };
}
