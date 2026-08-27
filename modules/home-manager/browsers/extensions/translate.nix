{pkgs, ...}: {
  my.browsers.extensions.translate = {
    firefoxPackage = pkgs.firefoxAddons.traduzir-paginas-web;
    chromeId = "mifafbjbnhpmhfkpeepbkbkjdlldenlm";
  };
}
