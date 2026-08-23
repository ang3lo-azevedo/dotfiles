{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "GitHub Stars");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "Your Stars";
      url = "https://github.com/ang3lo-azevedo?tab=stars";
    }
    {
      name = "my-awesome-stars";
      url = "https://github.com/ang3lo-azevedo/my-awesome-stars";
    }
  ];
}
