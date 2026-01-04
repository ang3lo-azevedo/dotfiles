let
  spaces = {
    "Space" = {
      id = "b1a4f4e2-3c5d-4f7e-9f2a-8c9e4d5b6a7c";
      position = 1000;
    };

    "University" = {
      id = "44685729-10e1-4832-a869-0b3a93e2f165";
      icon = "🎓";
      position = 2000;
    };
  };
  pins = {

    # Essentials
    "Mailbox" = {
      id = "9c427e81-3c6f-5d7g-9e3h-1f2g3h4i5j6k";
      url = "https://app.mailbox.org";
      isEssential = true;
      position = 101;
    };
    "WhatsApp" = {
      id = "8b316d70-2b5e-4c46-bf42-f4e82d635154";
      url = "https://web.whatsapp.com/";
      isEssential = true;
      position = 102;
    };
    "Nextcloud Calendar" = {
      id = "7d538f92-4e7a-6b8c-9d0e-1f2a3b4c5d6e";
      url = "https://nextcloud.at.eu.org/apps/calendar/timeGridWeek/now";
      isEssential = true;
      position = 103;
    };

    # University
    # Folders
    "Masters" = {
      id = "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d";
      workspace = spaces.University.id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      position = 104;
    };


    # Space
    # Pins
    "Stremio" = {
      id = "6e428f91-3c6f-5d7g-9e3h-1f2g3h4i5j6k";
      url = "https://web.stremio.com/";
      workspace = spaces.Space.id;
      position = 105;
    };
  };
in
{
  pinsForce = true;
  spacesForce = true;
  inherit pins spaces;
}
