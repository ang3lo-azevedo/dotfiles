let
  spaces = {
    "University" = {
      id = "44685729-10e1-4832-a869-0b3a93e2f165";
      icon = "🎓";
      position = 1000;
    };
  };
  pins = {
    "WhatsApp" = {
      id = "8b316d70-2b5e-4c46-bf42-f4e82d635154";
      url = "https://web.whatsapp.com/";
      isEssential = true;
      position = 100;
    };
  };
in
{
  pinsForce = true;
  spacesForce = true;
  inherit pins spaces;
}
