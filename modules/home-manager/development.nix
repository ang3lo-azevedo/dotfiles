{ pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
    git
    gh
    vscode
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
      ];
    };

    shellAliases = {
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";
      update = "sudo nixos-rebuild switch --flake .#pc-angelo";
      upgrade = "sudo nixos-rebuild switch --upgrade --flake .#pc-angelo";
    };

    initContent = ''
      # NixOS rebuild aliases
      alias reb="sudo nixos-rebuild switch --flake .#"
      alias rebd="sudo nixos-rebuild switch --flake .# --impure"
    '';
  };
}
