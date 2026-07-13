{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "GitHub Stars");
in {
  pins = [
    {
      name = "Your Stars";
      id = lib.mkId (spaceId + "Stars");
      url = "https://github.com/ang3lo-azevedo?tab=stars";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "my-awesome-stars";
      id = lib.mkId (spaceId + "my-awesome-stars");
      url = "https://github.com/ang3lo-azevedo/my-awesome-stars";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
  ];
}
