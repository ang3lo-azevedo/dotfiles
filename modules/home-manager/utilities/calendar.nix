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
        url = "https://NEXTCLOUD_URL_HERE/remote.php/dav/"; # TODO: Replace with your Nextcloud URL
        userName = "USERNAME_HERE"; # TODO: Replace with your username
        passwordCommand = ["cat" "${config.home.homeDirectory}/.config/nextcloud_pass"]; # TODO: Create this file or update command
      };
      vdirsyncer = {
        enable = true;
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
