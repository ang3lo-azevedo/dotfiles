{ pkgs, ... }:
let
  reverser_ai = pkgs.fetchFromGitHub {
    owner = "mrphrazer";
    repo = "reverser_ai";
    rev = "main";
    sha256 = "sha256-07bh4ofudKLKYGgHySSK4mpDstuyybKFktIfp0s8V8g=";
  };
in
{
  # Fetch and link the plugin, Binary Ninja will handle loading
  home.file.".binaryninja/plugins/reverser_ai".source = reverser_ai;
}

