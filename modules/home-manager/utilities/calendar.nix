{...}: {
  programs = {
    khal = {
      enable = true;
      locale = {
        timeformat = "%H:%M";
        dateformat = "%Y-%m-%d";
        longdateformat = "%Y-%m-%d";
        datetimeformat = "%Y-%m-%d %H:%M";
        longdatetimeformat = "%Y-%m-%d %H:%M";
      };
    };
    vdirsyncer = {
      enable = true;
    };
  };

  services.vdirsyncer.enable = true;

  accounts.calendar = {
    basePath = ".local/share/calendars";
    accounts = {
      nextcloud = {
        primary = true;
        local = {
          type = "filesystem";
          fileExt = ".ics";
        };
        remote = {
          type = "caldav";
          passwordCommand = ["sh" "-c" "source /run/agenix/nextcloud_caldav && echo $PASSWORD"];
        };
        vdirsyncer = {
          enable = true;
          urlCommand = ["sh" "-c" "source /run/agenix/nextcloud_caldav && echo $URL"];
          userNameCommand = ["sh" "-c" "source /run/agenix/nextcloud_caldav && echo $USERNAME"];
          collections = ["from a" "from b"];
          conflictResolution = "remote wins";
        };
        khal = {
          enable = true;
          type = "discover";
        };
      };
    };
  };
}
