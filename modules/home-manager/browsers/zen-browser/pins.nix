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
    "WhatsApp" = {
      id = "8b316d70-2b5e-4c46-bf42-f4e82d635154";
      url = "https://web.whatsapp.com/";
      isEssential = true;
      position = 101;
    };
    "Masters" = {
      id = "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d";
      workspace = spaces.University.id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      position = 102;
    };
  };
in
{
  pinsForce = true;
  spacesForce = true;
  inherit pins spaces;
}
